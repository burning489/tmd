#!/bin/bash

#SBATCH --partition=hpxg
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00
#SBATCH --job-name=search
#SBATCH --output=search.out
#SBATCH --error=search.err

export MATLAB_PREFDIR=/tmp/dingzhao_matlab

cd $SLURM_SUBMIT_DIR

module load matlab/R2020a

echo $1
sed "/log_options(/i $1" main.m | sed "/datestr/c timestamp=\"$2\";" | matlab -nosplash -nodisplay -nodesktop
