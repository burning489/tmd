clear, close all

%% setup
setup;

% output folder
global runid;
run_folder = sprintf(pwd+"/results/run%03d", runid);
if exist(run_folder, "dir")
    system("rm -rf "+run_folder);
end
mkdir(sprintf(pwd+"/results/run%03d/plot", runid));
mkdir(sprintf(pwd+"/results/run%03d/data", runid));

diary(run_folder+"/log.txt");

%% params
grad = @derivative;
k = 2;
options.k0 = 0;
options.k = k;
options.perturb_eps = 1e1;
options.perturb_index = 1:k;
% generate_v params
options.max_gen_iter = 1e2;
options.stepsize = [1e-3 1e-3];
options.l = 1e-6;
options.seed = 1;
options.r_tol = 1e-3;
options.orth_scheme = "mgs";
options.subspace_scheme = "LOBPCG"; % LOBPCG
options.preconditioner = eye(n); % TODO
options.mgs_eps = 1e-1; % tol for modified Gram-Schmidt
% HiOSD params
options.max_iter = max_iter;
options.step_scheme = "euler"; % Euler Scheme
options.g_tol = 1e-2; % tol for grad
options.output_fcn = @myoutput;
options.plot_fcn = @plot_fval;
options.energy = @energy;
options.display = "iter";
% save params
save_options(options);

figure("Visible", "off"); % for server use
figure("Visible", "off");
% figure();
% figure();

%% initial x and v0
x0 = zeros(3*n, 1);
% x0(1:n) = -1;
v0 = generate_v(grad, x0, k, options);
% v0 = randn(3*n, k);
% [v0, ~] = qr(v0, 0);
for i=1:length(options.perturb_index)
    x0 = x0 + options.perturb_eps*v0(:,options.perturb_index(i));
end

%% HiOSD
[x, fval, exitflag, output] = hiosd(grad, x0, k, v0, options);
save(sprintf(root_path+"/results/run%03d/results.mat", runid));
output.message

diary off;
