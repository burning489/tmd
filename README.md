## Energy landscape construct

This repository contains MATLAB code implementing High-Index based Dimer method (by Zhang Lei) of constructing a pathway map of saddle points on an energy surface(TMD structure).

## Code Structure

1. solver: search solver related
2. phase: energy function related
3. utils: auxiliary functions
4. scripts: test scripts
  - test_elastic: test normalization on elastic energy sin(2\*pi*(2\*x+y)), draw 4*3 subplots to illustrate, every line contains strain on xx, xy and yy at different configurations:
    - Lx,Ly=1,N=64
    - Lx,Ly=1,N=128, refine mesh
    - Lx,Ly=0.5,N=64, restrict area
    - Lx,Ly=1, N=128 constrained at the [0,0.5]\*[0,0.5] square, to compare with the above
  - test_gen_v: generate v for some x with some k
  - test_plot_v: plot energy surface around x along any 2 basis from v
  - test_v_mono: test monotonicity of energy function at x along v

## Implemention

1. solver
  - adopt dimer method to approximate hessian of energy, denote as H, instead of explicitly calculating H, approxmate H\*v = [f'(x+lv) - f'(x-lv)] / (2\*l) to obtian the information of H along v direction. Thus, the method is matrix-free, which is useful in approximating eigenvectors.
  - implement 4 methods to approximate (smallest or largest) eigenpairs of H:
    - Simultaneous Rayleigh quotient iteration, requires a stepsize for iteration, currently not working so well on my case, might test again later.
    - Power iteration on I - beta\*H, with beta small enough, approximate the smallest eigenpairs. Change - to + for largest case.
    - LOBPSD and LOBPCG. Preconditioner set as identity. Subroutine not understood yet(TODO).
  - use modified Gram-Schmidt process(default) or MATLAB default QR to do the orthonomalizaion

2. problem
	- need correct derivative(TODO)

## Results

following with elastic part
- result001 single circle in one phase
- result002 double circles in one phase
- result003 a thin stick in one phase, index=0 with a degenerate eigenpair, got from upward search from all zero with k=1
- result004 a thin wave in one phase, got from downward search from result001 with k=1, with another small negative eigenvalue -0.05, taken as zero
following without elastic part
- result005 single circle in one phase
- result006 refined result005, index=1, with 2 degenerate eigenpairs, got from upward search from all zero with k=1

## Remarks

1. If i start upward search from assumed index-0 saddle, random orthogonal initial guess v will just do. But if i want to seach upward/downward from index-k saddle, downward search needs the computed k eigenvectors, while upward one needs to compute more eigenvectors orthogonal to the known k eigenvectors, i.e. construct a index m(m>k) unstable subspace v_m of x with negative eigenvalues, then mgs w.r.t. v_k. In all, i must know the correct index of the starting saddle to do the right perturbation.

2. might need to check the influence of the dimer length
  update: 1e-6 will just do

3. descent or ascent along v might not be a good standard, now i plot surface along any two basis from v, energy along v1 and v2 seems flat but other v seem a basin
  update: now i use plots for each v and it works

4. current LOBPCG actually does not differ from LOBSD much because previous and current approximation of eigenvectors might be linear dependent, need to check the original LOBPCG for a more stable version if i really want the conjugacy

5. now i have checked power and rayleigh on allzero and single circle, it turns out that allzero is actually a index-0 saddle and single circle might be a degenerated index-0 saddle
## TODO

- [x] test on elastic
- [x] use gen_v to calculate the eigenpais of current 3 results
  - all zero: index-0, any direction is ascent direction and eigenvalues are positive
  - single circle in one phase: index-4, with smallest positive eigenvalue 0.026, which is likely to be zero, energy decreases along the corresponding (4+1) eigenvectors, the 0.026 eigenpair might require discussion
  - double circles in one phase: index-8, requires more discussion, cannot see information from v
- [x] rerun the upward search from all zero with corrected switch sentence
- [x] with computed exact index of the results, try downward search
- [x] improve output structure， better for reproduce
- [x] if the above not working, remove the elastic part and retry
- [x] consider multi v update in each iteration
- [ ] introuduce BB step scheme for x iteration again 
- [x] retry rayleigh quotient iteration and power method, add eigenvalue computing and largestreal case
- [x] decouple gen_v from solver
- [x] understand LOBPSD/LOBPCG: notice current and previous approximation might be linear dependent.

## Bugs
- [x] LOBPSD and LOBPCG in solver use wrong parameter for eigs, should replace SM with smllestreal