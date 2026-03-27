library(power.nb)
##Load libraries
library(tidyverse)
library(dplyr)
library(power.nb)
library(patchwork)

data_path =  "~/Documents/UAlberta_Research_Lab/ob_ross"
##Read count data and metadata
countdata <- read.table(
  file.path(data_path, "ob_ross_ASVs_table.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = "")

metadata <- read.table(
  file.path(data_path, "ob_ross_metadata.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = ""
)

metadata <- metadata %>%
  setNames(c("SampleID", "Groups"))

dim(data); dim(metadata)
#######################################################
## Sanity check
stopifnot(metadata$SampleID == colnames(data))
#######################################################
?power.nb::filter_low_count
filt_data = filter_low_count(countdata,
                             metadata,
                             abund_thresh = 3,
                             sample_thresh = 2,
                             sample_colname = "SampleID",
                             group_colname  = "Groups")



dim(countdata)
dim(filt_data)
View(metadata)

