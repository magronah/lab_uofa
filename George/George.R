##Load libraries
library(tidyverse)
library(dplyr)
library(power.nb)
library(patchwork)

getwd()
##Read count data and metadata
data_path = "~/Documents/lab_uofa/George/wood_plastic_kesy"

data <- read.table(
  file.path(data_path, "wood_plastic_kesy_ASVs_table.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = "",
  row.names = 1
)

metadata <- read.table(
  file.path(data_path, "wood_plastic_kesy_metadata.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = ""
)

dim(data); dim(metadata)

### Find samples in data that aren't in metadata
missing_samples <- colnames(data)[!colnames(data) %in% metadata$sampleid]
print(missing_samples)


### Remove taxonomy column so dimensions match metadata
data <- data[, !colnames(data) %in% "taxonomy"]
dim(data); dim(metadata)



metadata <- metadata %>%
  setNames(c("sampleid", "comparison"))

#View(metadata)
##############Select subset###############################

filter_data  = filter_low_count(
  countdata = data,
  metadata  = metadata,
  abund_thresh = 5,
  sample_thresh = 3,
  sample_colname = "sampleid",
  group_colname  = "comparison"
)

foldchange_est <- deseqfun(countdata = filter_data,
                           metadata  = metadata,
                           alpha_level = 0.1,
                           ref_name  = "wood",
                           group_colname = "sampleid",
                           sample_colname = "comparison")

logfoldchange =  foldchange_est$deseq_estimate$log2FoldChange

#view(data)
logmean    =  log(rowMeans(filter_data))
logmeanFit =  logmean_fit(logmean, sig = 0.05,
                          max.comp = 4, max.boot = 100)
logmeanFit
saveRDS(logmeanFit, file = '~/Documents/lab_uofa/George/wood_plastic_kesylogmeanFit.rds')



