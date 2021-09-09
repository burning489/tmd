clear, close all

%% setup
setup;
global runid;
runid = 1;
run_folder = sprintf(pwd+"/results/run%03d", runid);
if exist(run_folder, "dir")
    system("rm -rf "+run_folder);
end
mkdir(sprintf(pwd+"/results/run%03d/plot", runid));
mkdir(sprintf(pwd+"/results/run%03d/data", runid));

diary(run_folder+"/log.txt");

%% save params
save_options(options);

[x, fval, exitflag, output] = hiosd(grad, x0, k, v0, options);
save(sprintf(root_path+"/results/run%03d/results.mat", runid));

%% postprocess
output.message

diary off;