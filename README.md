# REdiscoverTE
Pipe line to run REdiscoverTE tool on paired-end fastq files and creating expression matrix for genes and TEs (transposon elements)

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
