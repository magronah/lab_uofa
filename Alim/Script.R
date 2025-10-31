# loading libraries

library(power.nb)
library(readr)

# read data set

countdata = read_tsv("ob_ross/ob_ross_ASVs_table.tsv")
View(countdata)
dim(countdata)

