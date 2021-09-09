function save_options(options)
global root_path runid;
fileID = fopen(sprintf(root_path+"/results/run%03d/settings.txt", runid), "w");
fprintf(fileID, "start index: %d\n", options.k0);
fprintf(fileID, "search index: %d\n", options.k);
fprintf(fileID, "perturb_eps: %f\n", options.perturb_eps);
fprintf(fileID, "perturb index:  ");
for i=1:length(options.perturb_index)
    fprintf(fileID, "%d ", options.perturb_index(i));
end
fprintf(fileID, "\n");
fprintf(fileID, "stepsize: %f %f\n", options.stepsize);
fprintf(fileID, "l(dimer length): %f\n", options.l);
fprintf(fileID, "rng seed: %s\n", options.seed);
fprintf(fileID, "max_iter: %d\n", options.max_iter);
fprintf(fileID, "difference scheme: %d\n", options.scheme);
fprintf(fileID, "g_tol: %f\n", options.g_tol);
fclose(fileID);
end

