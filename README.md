## Energy landscape construct
This repository contains MATLAB code implementing High-Index based Dimer method (by Zhang Lei) of constructing a pathway map of saddle points on an energy surface(TMD structure).

## Code Structure

1. solver: search solver related
2. phase: energy function related
3. utils: auxiliary functions
4. scripts: test scripts

## Implemention

1. solver
  - adopt dimer method to approximate hessian of energy, denote as H, instead of explicitly calculating H, approxmate H\*v = [f'(x+lv) - f'(x-lv)] / (2\*l) to obtian the information of H along v direction. Thus, the method is matrix-free, which is useful in approximating eigenvectors.
  - implement 4 methods to approximate (smallest or largest) eigenpairs of H:
    - Simultaneous Rayleigh quotient iteration, requires a stepsize for iteration, currently not working so well on my case, might test again later.
    - Power iteration on I - beta\*H, with beta small enough, approximate the smallest eigenpairs. Change - to + for LM case.
    - LOBPSD and LOBPCG. Preconditioner set as identity. Subroutine not understood yet(TODO).
  - use modified Gram-Schmidt process(default) or MATLAB default QR to do the orthonomalizaion

2. problem
	- length normalization, test on Lx, Ly(TODO)
	- need correct derivative(TODO)

## Results

1. all zero phase (assumed to be global minimum, index=0)
2. circle in one phase (index=1?TODO)
3. double circles in one phase (index=4?TODO)
4. splines (index=3?TODO)

## Remarks

1. If i start upward search from assumed index-0 saddle, random orthogonal initial guess v should be fine. But if i want to seach upward/downward from index-k saddle, downward search needs the computed k eigenvectors, while upward one needs to compute more eigenvectors orthogonal to the known k eigenvectors, i.e. construct a index m(m>k) unstable subspace v_m of x with negative eigenvalues, then mgs w.r.t. v_k. In all, i must know the correct index of the starting saddle to do the right perturbation.

2. might need to check the influence of the dimer length

3. if all-zero is indeed index-0, the initial guess v could be random orthogonal vectors

## TODO

1. test on elastic
2. use gen_v to calculate the eigenpais of current 3 results
3. rerun the upward search with corrected switch sentence
4. with computed exact index of the results, try downward search
5. if the above not working, remove the elastic part and retry