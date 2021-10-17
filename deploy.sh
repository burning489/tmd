#!/bin/bash
var1=(power rayleigh LOBPCG)
var2=(euler bb)
var3=(1 Inf)
# var4=(1e-2 1e-1)

for var1i in "${var1[@]}"; do
    for var2i in "${var2[@]}"; do
        for var3i in "${var3[@]}"; do
            # for var4i in "${var4[@]}"; do
            # params="options.subspace_scheme=\"$var1i\";options.step_scheme=\"$var2i\";options.norm_scheme=\"$var3i\";options.r_tol=$var4i;"
            params="options.subspace_scheme=\"$var1i\";options.step_scheme=\"$var2i\";options.norm_scheme=\"$var3i\";"
            sbatch task.sbatch $params
            # done
        done
    done
done
