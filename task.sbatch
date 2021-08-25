#!/bin/bash

#SBATCH --partition=hpxg
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00
#SBATCH --job-name=p6u_e3
#SBATCH --output=main.out
#SBATCH --error=main.err

export MATLAB_PREFDIR=/tmp/dingzhao_matlab

cd $SLURM_SUBMIT_DIR

module load matlab/R2018b

matlab -nosplash -nodisplay -nodesktop < ./main.m