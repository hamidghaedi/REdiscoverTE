# Checking for packages and install
# For CRAN
list.of.packages <- c("BiocManager")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='http://cran.us.r-project.org')

# For Bioconductor package 
list.of.packages <- c("edgeR")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) BiocManager::install(new.packages)


# defining fixed variables
prj_dir_path <- list.dirs(full.names = TRUE, recursive = FALSE)
sample_names <- list.dirs(full.names = FALSE, recursive = FALSE)
prj_path <- getwd()

#_______________________Interested files___________________________#

# [1] "GENE_1_raw_counts.RDS"                
# [2] "GENE_2_counts_normalized.RDS"         
# [3] "GENE_3_TPM.RDS"                       
# [4] "RE_all_1_raw_counts.RDS"              
# [5] "RE_all_2_counts_normalized.RDS"       
# [6] "RE_all_3_TPM.RDS"                     
# [7] "RE_exon_1_raw_counts.RDS"             
# [8] "RE_exon_2_counts_normalized.RDS"      
# [9] "RE_exon_3_TPM.RDS"                    
# [10] "RE_intergenic_1_raw_counts.RDS"       
# [11] "RE_intergenic_2_counts_normalized.RDS"
# [12] "RE_intergenic_3_TPM.RDS"              
# [13] "RE_intron_1_raw_counts.RDS"           
# [14] "RE_intron_2_counts_normalized.RDS"    
# [15] "RE_intron_3_TPM.RDS"   

#____________________merging data per files________________________#
## item 1

GENE_1_raw_counts <- c(1:57374)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/GENE_1_raw_counts.RDS"))
  df <- df$counts
  GENE_1_raw_counts <- cbind(GENE_1_raw_counts, df)
}
GENE_1_raw_counts <- GENE_1_raw_counts[,-1]
colnames(GENE_1_raw_counts) <- sample_names
saveRDS(GENE_1_raw_counts, file =paste0(prj_path, "/GENE_1_raw_counts.RDS"))


## item 2
GENE_2_counts_normalized <- c(1:57374)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/GENE_2_counts_normalized.RDS"))
  df <- df$counts
  GENE_2_counts_normalized <- cbind(GENE_2_counts_normalized, df)
}
GENE_2_counts_normalized <- GENE_2_counts_normalized[,-1]
colnames(GENE_2_counts_normalized) <- sample_names
saveRDS(GENE_2_counts_normalized, file =paste0(prj_path, "/GENE_2_counts_normalized.RDS"))

## item 3

GENE_3_TPM <- c(1:57374)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/GENE_3_TPM.RDS"))
  df <- df$counts
  GENE_3_TPM <- cbind(GENE_3_TPM, df)
}
GENE_3_TPM <- GENE_3_TPM[,-1]
colnames(GENE_3_TPM) <- sample_names
saveRDS(GENE_3_TPM, file =paste0(prj_path, "/GENE_3_TPM.RDS"))

## item 4

RE_all_1_raw_counts <- c(1:15422)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_all_1_raw_counts.RDS"))
  df <- df$counts
  RE_all_1_raw_counts <- cbind(RE_all_1_raw_counts, df)
}
RE_all_1_raw_counts <- RE_all_1_raw_counts[,-1]
colnames(RE_all_1_raw_counts) <- sample_names
saveRDS(RE_all_1_raw_counts, file =paste0(prj_path, "/RE_all_1_raw_counts.RDS"))


## item 5
RE_all_2_counts_normalized <- c(1:15422)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_all_2_counts_normalized.RDS"))
  df <- df$counts
  RE_all_2_counts_normalized <- cbind(RE_all_2_counts_normalized, df)
}
RE_all_2_counts_normalized <- RE_all_2_counts_normalized[,-1]
colnames(RE_all_2_counts_normalized) <- sample_names
saveRDS(RE_all_2_counts_normalized, file =paste0(prj_path, "/RE_all_2_counts_normalized.RDS"))

## item 6
RE_all_3_TPM<- c(1:15422)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_all_3_TPM.RDS"))
  df <- df$counts
  RE_all_3_TPM <- cbind(RE_all_3_TPM, df)
}
RE_all_3_TPM <- RE_all_3_TPM[,-1]
colnames(RE_all_3_TPM) <- sample_names
saveRDS(RE_all_3_TPM, file =paste0(prj_path, "/RE_all_3_TPM.RDS"))

## item 7
RE_exon_1_raw_counts <- c(1:4579)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_exon_1_raw_counts.RDS"))
  df <- df$counts
  RE_exon_1_raw_counts <- cbind(RE_exon_1_raw_counts, df)
}
RE_exon_1_raw_counts <- RE_exon_1_raw_counts[,-1]
colnames(RE_exon_1_raw_counts) <- sample_names
saveRDS(RE_exon_1_raw_counts, file =paste0(prj_path, "/RE_exon_1_raw_counts.RDS"))

## item 8
RE_exon_2_counts_normalized <- c(1:4579)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_exon_2_counts_normalized.RDS"))
  df <- df$counts
  RE_exon_2_counts_normalized <- cbind(RE_exon_2_counts_normalized, df)
}
RE_exon_2_counts_normalized <- RE_exon_2_counts_normalized[,-1]
colnames(RE_exon_2_counts_normalized) <- sample_names
saveRDS(RE_exon_2_counts_normalized, file =paste0(prj_path, "/RE_exon_2_counts_normalized.RDS"))

## item 9
RE_exon_3_TPM <- c(1:4579)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_exon_3_TPM.RDS"))
  df <- df$counts
  RE_exon_3_TPM <- cbind(RE_exon_3_TPM, df)
}
RE_exon_3_TPM <- RE_exon_3_TPM[,-1]
colnames(RE_exon_3_TPM) <- sample_names
saveRDS(RE_exon_3_TPM, file =paste0(prj_path, "/RE_exon_3_TPM.RDS"))

## item 10
RE_intergenic_1_raw_counts <- c(1:10670)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_intergenic_1_raw_counts.RDS"))
  df <- df$counts
  RE_intergenic_1_raw_counts <- cbind(RE_intergenic_1_raw_counts, df)
}
RE_intergenic_1_raw_counts <- RE_intergenic_1_raw_counts[,-1]
colnames(RE_intergenic_1_raw_counts) <- sample_names
saveRDS(RE_intergenic_1_raw_counts, file =paste0(prj_path, "/RE_intergenic_1_raw_counts.RDS"))

## item 11
RE_intergenic_2_counts_normalized <- c(1:10670)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_intergenic_2_counts_normalized.RDS"))
  df <- df$counts
  RE_intergenic_2_counts_normalized <- cbind(RE_intergenic_2_counts_normalized, df)
}
RE_intergenic_2_counts_normalized <- RE_intergenic_2_counts_normalized[,-1]
colnames(RE_intergenic_2_counts_normalized) <- sample_names
saveRDS(RE_intergenic_2_counts_normalized, file =paste0(prj_path, "/RE_intergenic_2_counts_normalized.RDS"))


# item 12
RE_intergenic_3_TPM <- c(1:10670)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_intergenic_3_TPM.RDS"))
  df <- df$counts
  RE_intergenic_3_TPM <- cbind(RE_intergenic_3_TPM, df)
}
RE_intergenic_3_TPM <- RE_intergenic_3_TPM[,-1]
colnames(RE_intergenic_3_TPM) <- sample_names
saveRDS(RE_intergenic_3_TPM, file =paste0(prj_path, "/RE_intergenic_3_TPM.RDS"))


# item 13
RE_intron_1_raw_counts <- c(1:11415)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_intron_1_raw_counts.RDS"))
  df <- df$counts
  RE_intron_1_raw_counts <- cbind(RE_intron_1_raw_counts, df)
}
RE_intron_1_raw_counts <- RE_intron_1_raw_counts[,-1]
colnames(RE_intron_1_raw_counts) <- sample_names
saveRDS(RE_intron_1_raw_counts, file =paste0(prj_path, "/RE_intron_1_raw_counts.RDS"))

# item 14
RE_intron_2_counts_normalized <- c(1:11415)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_intron_2_counts_normalized.RDS"))
  df <- df$counts
  RE_intron_2_counts_normalized <- cbind(RE_intron_2_counts_normalized, df)
}
RE_intron_2_counts_normalized <- RE_intron_2_counts_normalized[,-1]
colnames(RE_intron_2_counts_normalized) <- sample_names
saveRDS(RE_intron_2_counts_normalized, file =paste0(prj_path, "/RE_intron_2_counts_normalized.RDS"))

# item 15
RE_intron_3_TPM <- c(1:11415)

for(d in 1:length(prj_dir_path)){
  print(paste0(d, "_", sample_names[d]))
  df <- readRDS(paste0(prj_dir_path[d],"/result/RE_intron_3_TPM.RDS"))
  df <- df$counts
  RE_intron_3_TPM <- cbind(RE_intron_3_TPM, df)
}
RE_intron_3_TPM <- RE_intron_3_TPM[,-1]
colnames(RE_intron_3_TPM) <- sample_names
saveRDS(RE_intron_3_TPM, file =paste0(prj_path, "/RE_intron_3_TPM.RDS"))
