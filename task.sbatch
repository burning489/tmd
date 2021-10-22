#!/bin/bash

#SBATCH --account=yangzhijian
#SBATCH --partition=hpib
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --job-name=search

export MATLAB_PREFDIR=/tmp/dingzhao_matlab

cd $SLURM_SUBMIT_DIR

module load matlab/R2020a

sed "/options.k = /i $1" main.m | sed "/datestr/c timestamp=\"$2\";" | matlab -nosplash -nodisplay -nodesktop
# sed "/log_options(/i $1" main.m | sed "/datestr/c timestamp=\"$2\";" | matlab -nosplash -nodisplay -nodesktop
