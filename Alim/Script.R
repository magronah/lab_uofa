##Load libraries
library(tidyverse)
library(dplyr)
library(power.nb)
library(patchwork)

getwd()
##Read count data and metadata
data_path = "~/abundance_analysis/Alim/crc_zeller"

data <- read.table(
  file.path(data_path, "crc_zeller_ASVs_table.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = "",
  row.names = 1
)

metadata <- read.table(
  file.path(data_path, "crc_zeller_metadata.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = ""
)

dim(data); dim(metadata)


metadata <- metadata %>%
  setNames(c("SampleID", "Groups"))



##############Select subset###############################

filter_data  = filter_low_count(
  countdata = data,
  metadata  = metadata,
  abund_thresh = 5,
  sample_thresh = 3,
  sample_colname = "SampleID",
  group_colname  = "Groups"
)

foldchange_est <- deseqfun(countdata = filter_data,
                           metadata  = metadata,
                           alpha_level = 0.1,
                           ref_name  = "H",
                           group_colname = "Groups",
                           sample_colname = "SampleID")

logfoldchange =  foldchange_est$deseq_estimate$log2FoldChange

view(data)
logmean    =  log(rowMeans(filter_data))
logmeanFit =  logmean_fit(logmean, sig = 0.05,
                          max.comp = 4, max.boot = 100)
logmeanFit
saveRDS(logmeanFit, file = '~/abundance_analysis/Alim/parameter_estimate/crc_zeller_logmeanfit.rds')


