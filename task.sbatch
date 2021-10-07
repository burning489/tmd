#!/bin/bash

#SBATCH --partition=hpxg
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00
#SBATCH --job-name=search1
#SBATCH --output=search1.out
#SBATCH --error=search1.err

export MATLAB_PREFDIR=/tmp/dingzhao_matlab

cd $SLURM_SUBMIT_DIR

module load matlab/R2020a

matlab -nosplash -nodisplay -nodesktop -r "global runid; runid = 1; run('main.m')"
