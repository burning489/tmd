#!/bin/bash
index=($(seq 1 1 20))

for k in "${index[@]}"; do
    # params="options.subspace_scheme=\"$var1i\";options.step_scheme=\"$var2i\";options.norm_scheme=\"$var3i\";options.r_tol=$var4i;"
    params="options.subspace_scheme=\"$var1i\";options.step_scheme=\"$var2i\";options.norm_scheme=\"$var3i\";"
    params="k=$k;"
    time=$(date +"%y%m%d-%H%M%S")
    sbatch task.sbatch $params $time
    sleep 1.01
done
