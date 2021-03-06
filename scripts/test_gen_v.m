clean; setup;

% %% params
k = 15;
% gen_v params
options.max_gen_iter = 10000;
options.stepsize = [1e-3 1e-2];
options.l = 1e-6;
options.seed = 1;
options.r_tol = 1e-2;
options.orth_scheme = "mgs";
options.subspace_scheme = "LOBPCG"; 
options.mgs_eps = 1e-3; % neglect tol for modified Gram-Schmidt

x = load('/Users/dz/Documents/MATLAB/tmd/results/r211022-164854/xv_2568.mat').x;
v = [];
vm1 = [];
[v_s, eig_vals_s] = gen_v(der_fcn, x, k, v, vm1, "smallestreal", options);
[v_l, eig_vals_l] = gen_v(der_fcn, x, k, v, vm1, "largestreal", options);

save('/Users/dz/Documents/MATLAB/tmd/results/r211022-164854/x_gen_v.mat', 'x', 'v_s', 'v_l', 'eig_vals_s', 'eig_vals_l');
