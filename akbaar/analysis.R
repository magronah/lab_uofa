library(power.nb)
library(tidyverse)

data_path = "C:/Users/Dell/Downloads/Hackathon/Studies"

countdata <- read.table(
  file.path(data_path, "ob_goodrich/ob_goodrich_ASVs_table.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = "", row.names = 1  # treat the first column as row name
)

metadata <- read.table(
  file.path(data_path, "ob_goodrich/ob_goodrich_metadata.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = ""
)

metadata <- metadata %>% setNames(c("SampleID", "Groups"))

####################################################
## Sanity check
stopifnot(metadata$SampleID == colnames(countdata))
####################################################
?power.nb::filter_low_count
filt_data = filter_low_count(
  countdata,
  metadata,
  abund_thresh = 5,
  sample_thresh = 3,
  sample_colname = "SampleID",
  group_colname = "Groups"
)  # 80k to 6k good enough (dealing with a few thousands)

dim(countdata)
dim(filt_data)
View(metadata)

# abund_thresh
# sample_thresh
# go through each TAXA (ROWS), find count of taxa that have more than abund_thresh, and this count must be greater than sample_thresh
# filter out taxa that are below sample_thresh
# how to decide on the threshold, use default for now
# in example went from 1203 taxa only down to 345, took out a lot, should be more gentle with filter
# make the decision filter_low_count parameters is really useful

# figuring out if rows are taxas and cols are samples or vice versa (counts of taxas (high), counts of samples (low))

foldchange_est <- deseqfun(
  countdata = filt_data,
  metadata  = metadata,
  alpha_level = 0.1,
  ref_name  = "H",
  group_colname = "Groups",
  sample_colname = "SampleID"
)  # calculate fold changes, one group divided by other group, T1D / H
# which group you should use as denominator

logfoldchange =  foldchange_est$deseq_estimate$log2FoldChange

?logmean_fit
logmean = log(rowMeans(filt_data))
logmeanFit = logmean_fit(logmean, sig = 0.05,
                          max.comp = 4, max.boot = 100)  # use hypothesis testing to decide
logmeanFit
saveRDS(logmeanFit, file = "~/lab_uofa/akbaar/New folder/ob_goodrich.rds")  # the object you want saved
saveRDS(test, file = "~/lab_uofa/nevin/foldchange_estimate/t1d_alkanani/t1d_alkanani_foldchang_est.rds")
