# REdiscoverTE
Pipeline to run REdiscoverTE tool on paired-end fastq files and creating expression matrix for genes and TEs (transposon elements).

A detailed instruction can be find [here](http://research-pub.gene.com/REdiscoverTEpaper/software/REdiscoverTE_README.html), Also, following this tutorial you will be able to install and run the software.  

To download the software :

```shell
wget http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz
gunzip REdiscoverTEdata_1.0.1.tar.gz
```
Prerequisites:

REdiscoverTE is written in R and to run the software two programs must already be installed: ```R``` and ```salmon```.

- `R` (https://www.r-project.org/). Tested version is 3.4.3.

- `salmon`. Tested version is 0.8.2, available at the developers’ github page: https://github.com/COMBINE-lab/salmon/releases/tag/v0.8.2 .

Required RAM and disk space

- 89 gigabytes of disk space is required for the Salmon index.
- At least 30 GB of RAM is recommended for Salmon. Salmon requires a substantial amount of RAM with the included 5-million-entry FASTA reference.


To download the software :

```shell
wget http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz
gunzip REdiscoverTEdata_1.0.1.tar.gz
```




 general idea:edit makefile per sample

```
for dir in fasqdir
r1 = dir/*.R1_fastq.gz
r2 = dir/*.R2_fastq.gz
```
replace fastq_R1 (_R2) file address with r1 (r2) in the makefile in RediscoverTE directory
```
FASTQ_READS_1=r1
FASTQ_READS_2=r2
```
specify where to save outputs:
```
SALMON_COUNTS_DIR= $dir/
ROLLUP_RESULTS_DIR= $dir/
```
running the tool for all samples, then rolling up outputs:

 for .qs files
 
 for .rds files
