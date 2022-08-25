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
wget http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz
tar -xf REdiscoverTEdata_1.0.1.tar.gz
```

There is a `Makefile` in the `RediscoverTE` , and it is needed by the pipeline to be renamed to `Makefile_backup` ; 

```shell
# change directory to REdiscoverTE
mv Makefile Makefile_backup

```

### Running the pipline

#### Time for each step 
(based on the authors)


**Index generation**: 90 minutes on a 2017 16-core 2.6 GHz Xeon processor. [This step would be needed only the very first time that you run the software]

**Salmon alignment**: ~30-90 minutes. ~30 minutes for a 64 million sequence 50bp SE input FASTQ file on the same Xeon CPU as above.

**Rollup**: ~5 minutes per quant.sf file. (There will be one quant.sf file for each input sample: for single-end reads, there will be a 1:1 correspondence between .fastq and quant.sf files).


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



