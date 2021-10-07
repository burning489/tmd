clean;

setup;

% %% params
grad = @derivative;
k = 10;
% gen_v params
options.max_gen_iter = 1e3;
options.stepsize = [1e-3 1e-3];
options.l = 1e-6;
options.seed = 1;
options.r_tol = 1e-2;
options.orth_scheme = "mgs";
options.step_scheme = "euler"; % Euler Scheme
options.subspace_scheme = "LOBPCG"; % LOBPCG
options.mgs_eps = 1e-1; % tol for modified Gram-Schmidt

% eta = zeros(3*N*N, 1);
% x = load("results/run001/data/xv_40000").x;
x = load("x.mat").xn;
[v, eig_vals] = gen_v(grad, x, k, options);

fprintf("#index of unstable subspace:%d\n", sum(eig_vals<0));

save('results/result_003.mat', 'x', 'v', 'eig_vals');