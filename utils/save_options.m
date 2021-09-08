function save_options(options)
global root_path;
i = get_run_index();
fileID = fopen(sprintf(root_path+"/results/run%03d/options.txt", i), "w");
fprintf(fileID, "index: %d\nperturb_eps: %f\nstepsize: %f %f\nl(dimer length): %f\nrng seed: %s\nmax_iter: %d\ndifference scheme: %d\ng_tol: %f\n", options.k, options.perturb_eps, options.stepsize, options.l, options.seed, options.max_iter, options.scheme, options.g_tol);
fclose(fileID);
end

