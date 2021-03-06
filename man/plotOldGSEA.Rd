% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bagOfGenesEnrichment.R
\name{plotOldGSEA}
\alias{plotOldGSEA}
\title{compute gene set enrichment - osama's code wrapped in package.}
\usage{
plotOldGSEA(genes.with.values, prot.univ, prefix)
}
\arguments{
\item{genes.with.values}{of genes and difference values}

\item{prot.univ}{the space of all proteins we are considering}
}
\value{
gSEA output type stuff
computeGSEA<-function(genes.with.values,prefix,gsea_FDR=0.01){
  
  library(WebGestaltR)
  library(ggplot2)
  inputdfforWebGestaltR <- genes.with.values%>%
    dplyr::rename(genes='Gene',scores='value')%>%
    dplyr::arrange(scores)
  
  
  #' * GSEA using gene ontology biological process gene sets
  
  go.bp.res.WebGestaltR <- WebGestaltR(enrichMethod = "GSEA", 
                                       organism="hsapiens", 
                                       enrichDatabase="geneontology_Biological_Process", 
                                       interestGene=inputdfforWebGestaltR, 
                                       interestGeneType="genesymbol", 
                                       collapseMethod="mean", perNum = 1000,
                                       fdrThr = gsea_FDR, nThreads = 2, isOutput = F)
  write.table(go.bp.res.WebGestaltR, paste0("proteomics_", prefix, "_gseaGO_result.txt"), sep="\t", row.names=FALSE, quote = F)
  
  top_gseaGO <- go.bp.res.WebGestaltR %>% 
    filter(FDR < gsea_FDR) %>% 
    dplyr::rename(pathway = description, NES = normalizedEnrichmentScore) %>% 
    arrange(desc(NES)) %>% 
    dplyr::mutate(status = case_when(NES > 0 ~ "Up",
                                     NES < 0 ~ "Down"),
                  status = factor(status, levels = c("Up", "Down"))) %>% 
    #\group_by(status) %>% 
    top_n(30, wt = NES) %>% 
    ungroup() %>% 
    ggplot2::ggplot(aes(x=reorder(pathway, NES), y=NES)) +
    geom_bar(stat='identity', aes(fill=status)) +
    scale_fill_manual(values = c("Up" = "darkred", "Down" = "dodgerblue4")) +
    coord_flip() +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 18),
          axis.title.x = element_text(size=16),
          axis.title.y = element_blank(), 
          axis.text.x = element_text(size = 14),
          axis.text.y=element_text(size = 14),
          axis.line.y = element_blank(),
          axis.ticks.y = element_blank(),
          legend.position = "none") +
    labs(title = "", y="NES") +#for some reason labs still works with orientation before cord flip so set y
    ggtitle(paste('Up-regulated',prefix))
  ggsave(paste0("upRegProts_", prefix,"_gseaGO_plot.pdf"), top_gseaGO, height = 8.5, width = 11, units = "in")
  
  
  all_gseaGO <- go.bp.res.WebGestaltR %>% 
    filter(FDR < gsea_FDR) %>% 
    dplyr::rename(pathway = description, NES = normalizedEnrichmentScore) %>% 
    arrange(NES) %>% 
    dplyr::mutate(status = case_when(NES > 0 ~ "Up",
                                     NES < 0 ~ "Down"),
                  status = factor(status, levels = c("Up", "Down"))) %>% 
    group_by(status) %>% 
    top_n(20, wt = abs(NES)) %>% 
    ungroup() %>% 
    ggplot2::ggplot(aes(x=reorder(pathway, NES), y=NES)) +
    geom_bar(stat='identity', aes(fill=status)) +
    scale_fill_manual(values = c("Up" = "darkred", "Down" = "dodgerblue4")) +
    coord_flip() +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 18),
          axis.title.x = element_text(size=16),
          axis.title.y = element_blank(), 
          axis.text.x = element_text(size = 14),
          axis.text.y=element_text(size = 14),
          axis.line.y = element_blank(),
          axis.ticks.y = element_blank(),
          legend.position = "none") +
    labs(title = "", y="NES") +#for some reason labs still works with orientation before cord flip so set y
    ggtitle(paste('All',prefix))
  ggsave(paste0("allRegProts_", prefix,"_gseaGO_plot.pdf"), all_gseaGO, height = 8.5, width = 11, units = "in")
  
  
  bot_gseaGO <- go.bp.res.WebGestaltR %>% 
    filter(FDR < gsea_FDR) %>% 
    dplyr::rename(pathway = description, NES = normalizedEnrichmentScore) %>% 
    arrange(NES) %>% 
    dplyr::mutate(status = case_when(NES > 0 ~ "Up",
                                     NES < 0 ~ "Down"),
                  status = factor(status, levels = c("Up", "Down"))) %>% 
    #group_by(status) %>% 
    top_n(40, wt = rev(NES)) %>% 
    ungroup() %>% 
    ggplot2::ggplot(aes(x=reorder(pathway, rev(NES)), y=NES)) +
    geom_bar(stat='identity', aes(fill=status)) +
    scale_fill_manual(values = c("Up" = "darkred", "Down" = "dodgerblue4")) +
    coord_flip() +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 18),
          axis.title.x = element_text(size=16),
          axis.title.y = element_blank(), 
          axis.text.x = element_text(size = 14),
          axis.text.y=element_text(size = 14),
          axis.line.y = element_blank(),
          axis.ticks.y = element_blank(),
          legend.position = "none") +
    labs(title = "", y="NES") +#for some reason labs still works with orientation before cord flip so set y
    ggtitle(paste('Down-regulated',prefix))
  ggsave(paste0("downRegProts_", prefix,"_gseaGO_plot.pdf"), bot_gseaGO, height = 8.5, width = 11, units = "in")
  
  return(go.bp.res.WebGestaltR) 
}
Old plot using clusterProfiler
}
\description{
compute gene set enrichment - osama's code wrapped in package.
}
\author{
Osama
}
