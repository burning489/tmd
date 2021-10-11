clear, close all

%% setup
setup;

% output folder
global runid;
runid = 5;
run_folder = sprintf(pwd+"/results/run%03d", runid);
if exist(run_folder, "dir")
    system("rm -rf "+run_folder);
end
mkdir(sprintf(pwd+"/results/run%03d/plot", runid));
mkdir(sprintf(pwd+"/results/run%03d/data", runid));

diary(run_folder+"/log.txt");

%% params
k = 1;
options.k0 = 0;
options.k = k;
options.perturb_eps = 1e1;
options.perturb_index = 1:k;
% gen_v params
options.max_gen_iter = 1e2;
options.stepsize = [1e-3 1e-3];
options.l = 1e-6;
options.seed = 1;
options.r_tol = 1e-3;
options.orth_scheme = "mgs";
options.step_scheme = "euler"; % Euler Scheme
options.subspace_scheme = "LOBPCG"; % LOBPCG
options.mgs_eps = 1e-1; % tol for modified Gram-Schmidt
% HiOSD params
options.max_iter = max_iter;
options.step_scheme = "euler"; % Euler Scheme
options.g_tol = 1e-2; % tol for derivative
options.output_fcn = @myoutput;
options.plot_fcn = @plot_fval;
options.display = "iter";
% save params
save_options(options);
mode = "largestreal";

% figure("Visible", "off"); % for server use
% figure("Visible", "off");
figure();
figure();

%% initial x and v0
% x0 = zeros(3*n, 1);
% x0 = load("results/result_001.mat").x;
% v0 = load("results/result_001.mat").v;
% for i=1:4
%     x0 = x0 + options.perturb_eps*v0(:,i);
% end
% v0 = v0(:,1:k);

x0 = load("results/result_004.mat").x;
v0 = load("results/result_004.mat").v;

% v0 = gen_v(der_fcn, x0, 10, mode, options);
% v0 = randn(3*n, k);
% [v0, ~] = qr(v0, 0);
% for i=1:length(options.perturb_index)
%     x0 = x0 + options.perturb_eps*v0(:,options.perturb_index(i));
% end
% for i=1:size(v0,2)
%     x0 = x0 + options.perturb_eps*v0(:,i);
% end
% v0 = v0(:,1:k);


%% HiOSD
[x, fval, exitflag, output] = hiosd(der_fcn, x0, k, v0, options);
save(sprintf(root_path+"/results/run%03d/results.mat", runid));
output.message

diary off;
