% Entrance function to run a search.
clear, close all

% setup global params of physical model and chore params(path management and user-defined function handles)
setup;

% output folder
global timestamp;
timestamp = datestr(now,'yymmdd-HHMMSS'); % e.g. 211012-102728 for 12th, October, 2021, 10:27:38
run_folder = sprintf(pwd+"/results/r%s", timestamp);
if exist(run_folder, "dir")
    system("rm -rf "+run_folder);
end
mkdir(sprintf(pwd+"/results/r%s/plots", timestamp));
mkdir(sprintf(pwd+"/results/r%s/checkpoints", timestamp));

% params
k = 4;
options.k0 = 0; % index of start point
options.k = k; % index of target
options.perturb_eps = 1e0;
options.perturb_index = 1:k;
% gen_v params
options.max_gen_iter = 1e3;
options.stepsize = [1e-2 1e-2];
options.l = 1e-6;
options.seed = 1;
options.r_tol = 1e-2; % tol for approxiation of eigenvectors
options.mgs_eps = 1e-1; % neglect tol for modified Gram-Schmidt
options.norm_scheme = "Inf";
options.orth_scheme = "mgs";
options.subspace_scheme = "rayleigh";
% solver params
options.max_iter = 2e6;
options.tau = 0.5;
options.g_tol = 1e-2; % tol for derivative
options.step_scheme = "bb";
options.output_fcn = @myoutput;
options.plot_fcn = @plot_fval;

x0 = load("results/result_000.mat").x;
v0 = load("results/result_000.mat").v_s;

% plot start point
plot_phase(x0);
saveas(1, sprintf(root_path+"/results/r%s/phase_0.png", timestamp));
close(1);
% show figures on pc and not on server
if ismac || ispc
    figure();
    figure();
else
    figure("Visible", "off");
    figure("Visible", "off");
end

% save configurations
log_options(options);
save(sprintf(root_path+"/results/r%s/log.mat", timestamp), 'x0', 'v0', 'options');

% perturb
for i=1:length(options.perturb_index)
    x0 = x0 + options.perturb_eps*v0(:,options.perturb_index(i));
end

% solver
[x, fval, exitflag, output] = solver(der_fcn, x0, k, v0, options);

% postprocess
v = output.v;
save(sprintf(root_path+"/results/r%s/log.mat", timestamp), 'x', 'v', '-append');
savefig(1, sprintf(root_path+"/results/r%s/energy.fig", timestamp));
output.message