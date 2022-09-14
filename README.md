# REdiscoverTE
A pipeline to run REdiscoverTE tool on paired-end fastq data to obtain expression matrix for genes and TEs (transposon elements) simultaneously.

A detailed instruction on the software can be find [here](http://research-pub.gene.com/REdiscoverTEpaper/software/REdiscoverTE_README.html), Also, following this tutorial you will be able to install and run the software.  


### Prerequisites:

REdiscoverTE is written in R and to run the software two programs must already be installed: ```R``` and ```salmon```.

- `R` (https://www.r-project.org/). Tested version is 3.4.3.

- `salmon`. Tested version is 0.8.2, available at the developers’ github page: https://github.com/COMBINE-lab/salmon/releases/tag/v0.8.2 .

Required RAM and disk space

- 89 gigabytes of disk space is required for the Salmon index.
- At least 30 GB of RAM is recommended for Salmon. Salmon requires a substantial amount of RAM with the included 5-million-entry FASTA reference.

This thread is all about running REdiscoverTE on paired-end bulk RNA-seq files coming from human sources (patients or cell-lines). The pipeline assumed that: The fastq files for each sample are in a directory called `sample_name` and are named as `sample_name_R1.fq.gz` and  `sample_name_R2.fq.gz`;

```
├── project
│   └── sample_name
│       ├── sample_name_R1.fq.gz
│       └── sample_name_R2.fq.gz
```

### REdiscoverTE download :

```shell
wget http://research-pub.gene.com/REdiscoverTEpaper/software/REdiscoverTE_1.0.1.tar.gz
tar -xf REdiscoverTE_1.0.1.tar.gz
```

There is a `Makefile` in the `RediscoverTE` , and it is needed by the pipeline to be renamed to `Makefile_backup` ; 

```shell
# change directory to REdiscoverTE
mv Makefile Makefile_backup

```

### Running the pipline

#### Time for each step 
(based on the REdiscoverTE authors)


**Index generation**: 90 minutes on a 2017 16-core 2.6 GHz Xeon processor. [This step would be needed only the very first time that you run the software]

**Salmon alignment**: ~30-90 minutes. ~30 minutes for a 64 million sequence 50bp SE input FASTQ file on the same Xeon CPU as above.

**Rollup**: ~5 minutes per quant.sf file. (There will be one quant.sf file for each input sample: for single-end reads, there will be a 1:1 correspondence between .fastq and quant.sf files).

**NB**

A shell script to run the following code chunck can be find in the repo by the name `REdiscoverTE_run.sh`. This can be run on any HPC with **Slurm Workload Manager** such as ComputeCanada. You need to add your email address to the line 10 and specify absolute path to the _project_ and _REdiscoverTE_ directories on line 20 and 21, respectively. 


```shel
# define directories
PROJECT='/full/path/to/project/directory'
RE_discoverTE_PATH='/full/path/to/REdiscoverTE/'

# loop
for dir in $PROJECT/*; do
  echo $dir
  # make a directory to store the result
  mkdir -p $dir/result
  SAMPLE_NAME=$(basename $dir)
  #echo $(basename $dir)
  R_1="${dir}"/"${SAMPLE_NAME}"_R1.fq.gz
  R_2="${dir}"/"${SAMPLE_NAME}"_R2.fq.gz
  echo $R_1
  echo $R_2
  # copying Makefile_backup to Makefile 
  cp "${RE_discoverTE_PATH}"/Makefile_backup "${RE_discoverTE_PATH}"/Makefile
  # editting makefile
  sed -i "s|FASTQ_READS_1=SIMULATED_FASTQS/input_R1.fq.gz|FASTQ_READS_1=$R_1|g" "${RE_discoverTE_PATH}"/Makefile
  sed -i "s|FASTQ_READS_2=SIMULATED_FASTQS/input_R2.fq.gz|FASTQ_READS_2=$R_2|g" "${RE_discoverTE_PATH}"/Makefile
  sed -i "s|SALMON_COUNTS_DIR=Step_2_salmon_counts|SALMON_COUNTS_DIR=$dir/result|g" "${RE_discoverTE_PATH}"/Makefile
  sed -i "s|ROLLUP_RESULTS_DIR=Step_4_rollup|ROLLUP_RESULTS_DIR=$dir/result|g" "${RE_discoverTE_PATH}"/Makefile
  cd $RE_discoverTE_PATH
  make all
  mv "${RE_discoverTE_PATH}"/Makefile $dir/result
done
```
### Processing the result files

After running the REdiscoverTE tool , a directory called "result" would be generated in each sample directory. In the result directory , should be 15 different ```RDS``` file which are needed for downstream analysis. There files are :

**GENE**: Transcript-level expression values:
- GENE_1_raw_counts.RDS: raw counts DGEList data object.
- GENE_2_counts_normalized.RDS: normalized counts (by total gene counts) DGEList data object.
- GENE_3_TPM.RDS: TPM (transcripts per million) for each gene/transcript. DGEList data object.


**RE all**: Repetitive elements found anywhere in the genome. Granularity for all RE reporting is at repName level (where the three levels we use are name, family, and class, in increasing order of generality).
- RE_all_1_raw_counts.RDS: raw counts DGEList data object.
- RE_all_2_counts_normalized.RDS: note that counts are normalized by total gene counts
- RE_all_3_TPM.RDS: TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.


**RE exon**: Subset of RE all: only repetitive elements found at least partially within an annotated exon.
- RE_exon_1_raw_counts.RDS: raw counts DGEList data object.
- RE_exon_2_counts_normalized.RDS: counts are normalized by total gene counts
- RE_exon_3_TPM.RDS: TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.


**RE intron**: Subset of RE all: only repetitive elements that do not have any overlap with an exon, and have some overlap with an intron.
- RE_intron_1_raw_counts.RDS: raw counts DGEList data object.
- RE_intron_2_counts_normalized.RDS:counts are normalized by total gene counts
- RE_intron_3_TPM.RDS: TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.


**RE intergenic**: Subset of RE all: only repetitive elements that have no overlap with annotated introns or exons.
- RE_intergenic_1_raw_counts.RDS: raw counts DGEList data object.
- RE_intergenic_2_counts_normalized.RDS: counts are normalized by total gene counts
- RE_intergenic_3_TPM.RDS: TPM (transcripts per million) for each repetitive element ‘repName’. DGEList data object.



So the next step is to merge sample level ```RDS``` files to generate a project level ```RDS``` per file (15 project level files). The following R script will do this job; it goes into each directory , read a file then merge all files from all samples into one file. These files are considred as input for downstream analysis.

A copy of the following script can be found in the repository.

```R
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

```

