clear, close all

%% preprocess working directory
if exist('log.txt', 'file')
    delete('./log.txt');
end

%% setup
diary log.txt
setup;

%% initial 
x0 = zeros(3*n, 1);

%% specify solver parameter
% options.stepsize = [1e-2 1e-2];
save_options(options);

%% generate unstable subspace v
v0 = generate_v(grad, x0, k, options);
x0 = x0 + options.perturb_eps*v0(:,1);
v0 = v0(:,1:k);

%% output settings
gen_folder();
figure("Visible", "off");
figure("Visible", "off");
% figure();
% figure();

[x, fval, exitflag, output] = hiosd(grad, x0, k, v0, options);
create_gif(get_run_index());

%% postprocess
output.message

diary off
