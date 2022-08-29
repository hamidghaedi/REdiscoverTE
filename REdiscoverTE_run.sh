#!/bin/bash
#SBATCH --job-name=redisc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=0-02:00:00
#SBATCH --mem=150gb
#SBATCH --output=redisc.%J.out
#SBATCH --error=redisc.%J.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user= [youremail@company.com]


# loading modules: the module on the first line are required by salmn and R
module load nixpkgs/16.09  gcc/5.4.0  openmpi/2.1.1
module load salmon/0.8.2
module load  r


# define directories
PROJECT='path/to/the/project/directory'
RE_discoverTE_PATH='path/to/the/REdiscoverTE/directory'

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
