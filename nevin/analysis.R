library(power.nb)
library(tidyverse)
library(dplyr)

data_path = "~/lab_uofa/Hackathon/Studies"

countdata <- read.table(
  file.path(data_path, "t1d_alkanani/t1d_alkanani_ASVs_table.tsv"),
  header = TRUE, sep = "\t",
  check.names = FALSE, comment.char = "", row.names = 1  # treat the first column as row name
)

countdata <- countdata[1:ncol(countdata) - 1]

metadata <- read.table(
  file.path(data_path, "t1d_alkanani/t1d_alkanani_metadata.tsv"),
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

### function to mute printing out messages about
### update on the number of iterations
quiet <- function(expr) {
  out <- suppressWarnings(suppressMessages(
    capture.output(res <- eval.parent(substitute(expr)))
  ))
  res}

?logmean_fit
logmean = log(rowMeans(filt_data))
logmeanFit = logmean_fit(logmean, sig = 0.05,
                          max.comp = 4, max.boot = 100)  # use hypothesis testing to decide
logmeanFit
#saveRDS(logmeanFit, file = "~/lab_uofa/nevin/parameter_estimates/sed_plastic_hoellein_logmean.rds")  # the object you want saved
saveRDS(logmeanFit, file = "~/lab_uofa/nevin/parameter_estimates/seston_plastic_mccormick_default.rds")  # the object you want saved

foldchange_est <- deseqfun(
  countdata = filt_data,
  metadata  = metadata,
  alpha_level = 0.1,
  ref_name  = "plastic",
  group_colname = "Groups",
  sample_colname = "SampleID"
)  # calculate fold changes, one group divided by other group, T1D / H
# which group you should use as denominator

saveRDS(foldchange_est, file = "~/lab_uofa/nevin/foldchange_estimate/sed_plastic_hoellein/sed_plastic_hoellein_foldchange_est_default.rds")
logfoldchange = foldchange_est$deseq_estimate$log2FoldChange

logfoldchangeFit <- logfoldchange_fit(logmean,
                                      logfoldchange,
                                      ncore = 3,
                                      max_sd_ord = 2,
                                      max_np = 5,
                                      minval = -5,
                                      maxval = 5,
                                      itermax = 100,
                                      NP = 800,
                                      seed = 100)

logfoldchangeFit
saveRDS(logfoldchangeFit, file = "~/lab_uofa/nevin/logfoldchangeFits/sed_plastic_hoellein_foldchange_fits.rds")
