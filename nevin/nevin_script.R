# loading libraries
library(power.nb)
library(readr)

# read dataset
View(countdata)
dim(countdata)  # 1203 rows (features), 50 cols

n = 4
data_path = "~/lab_uofa/Hackathon/Studies"
names_data = c(file.path(data_path, "t1d_alkanani/t1d_alkanani_ASVs_table.tsv"),
           file.path(data_path, "sw_plastic_frere/sw_plastic_frere_ASVs_table.tsv"),
           file.path(data_path, "seston_plastic_mccormick/seston_plastic_mccormick_ASVs_table.tsv"),
           file.path(data_path, "sed_plastic_rosato/sed_plastic_rosato_ASVs_table.tsv"),
           file.path(data_path, "sed_plastic_hoellein/sed_plastic_hoellein_ASVs_table.tsv")
)

names_metadata = c(file.path(data_path, "t1d_alkanani/t1d_alkanani_metadata.tsv"),
               file.path(data_path, "sw_plastic_frere/sw_plastic_frere_metadata.tsv"),
               file.path(data_path, "seston_plastic_mccormick/seston_plastic_mccormick_metadata.tsv"),
               file.path(data_path, "sed_plastic_rosato/sed_plastic_rosato_metadata.tsv"),
               file.path(data_path, "sed_plastic_hoellein/sed_plastic_hoellein_metadata.tsv")
)

names = c("t1d_alkanani", "sw_plastic_frere", "seston_plastic_mccormick", "sed_plastic_rosato", "sed_plastic_hoellein")

for(i in 1:length(names_data)) {
  countdata = read.table(names_data[i], header = TRUE, sep = "\t", check.names = FALSE, comment.char = "", row.names = 1)
  metadata = read.table(names_metadata[i], header = TRUE, sep = "\t", check.names = FALSE, comment.char = "")
  write.csv(countdata, paste0("~/lab_uofa/dataset/data/", names[i], ".csv"))
  write.csv(metadata, paste0("~/lab_uofa/dataset/metadata/", names[i], ".csv"))
}
