clear, close all

% setup
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

% logging
diary(run_folder+"/log.txt");

% params
k = 4;
options.k0 = 0; % index of start point
options.k = k; % index of target
options.perturb_eps = 1e1;
options.perturb_index = 1:k;
% gen_v params
options.max_gen_iter = 1e2;
options.stepsize = [1e-3 1e-3];
options.l = 1e-6;
options.seed = 1;
options.r_tol = 1e-2; % tol for residuals
options.mgs_eps = 1e-1; % neglect tol for modified Gram-Schmidt
options.norm_scheme = "Inf";
options.orth_scheme = "mgs";
options.step_scheme = "euler";
options.subspace_scheme = "LOBPCG";
% solver params
options.max_iter = max_iter;
options.g_tol = 1e-2; % tol for derivative
options.output_fcn = @myoutput;
options.plot_fcn = @plot_fval;
options.display = "iter"; % print info at every iteration
% save params
log_options(options);

% show figures on pc and not on server
if ismac | ispc
    figure();
    figure();
else
    figure("Visible", "off");
    figure("Visible", "off");
end

% initial x and v0
% x0 = zeros(3*n, 1);
% rng(0);
% v0 = randn(3*n, k);
% [v0, ~] = qr(v0, 0);
% for i=1:k
%     x0 = x0 + options.perturb_eps*v0(:,i);
% end
x0 = load("results/result_006.mat").x;
v0 = load("results/result_006.mat").v;
for i=4:5
    x0 = x0 + options.perturb_eps*v0(:,i);
end
v0 = v0(:,1:4);

% mode = "largestreal";
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

% solver
[x, fval, exitflag, output] = solver(der_fcn, x0, k, v0, options);
save(sprintf(root_path+"/results/r%s/results.mat", timestamp));
output.message

diary off;
