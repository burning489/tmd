clean; setup;

% %% params
mode = "smallestreal";
k = 10;
% gen_v params
options.max_gen_iter = 10000;
options.stepsize = [1e-3 1e-2];
options.l = 1e-6;
options.seed = 1;
options.r_tol = 1e-2;
options.orth_scheme = "mgs";
options.step_scheme = "euler"; 
options.subspace_scheme = "rayleigh"; 
options.mgs_eps = 1e-3; % neglect tol for modified Gram-Schmidt

x = load("results/result_000.mat").x;
[v, eig_vals] = gen_v(der_fcn, x, k, mode, options);

fprintf("#index of unstable subspace:%d\n", sum(eig_vals<0));

save('results/result_000.mat', 'x', 'v', 'eig_vals');