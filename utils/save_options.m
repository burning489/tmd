function save_options(options)
global root_path timestamp kappa ratio;
fileID = fopen(sprintf(root_path+"/results/r%s/settings.json", timestamp), "w");
fprintf(fileID, "{\n");
fprintf(fileID, "\t""start_index"": %d,\n", options.k0);
fprintf(fileID, "\t""search_index"": %d,\n", options.k);
fprintf(fileID, "\t""mgs_eps"": %f,\n", options.mgs_eps);
fprintf(fileID, "\t""perturb_eps"": %f,\n", options.perturb_eps);
fprintf(fileID, "\t""perturb_index"": [\n\t\t");
for i=1:length(options.perturb_index)
    fprintf(fileID, "%d, ", options.perturb_index(i));
end
fprintf(fileID, "\n\t],\n");
fprintf(fileID, "\t""rng_seed"": %d,\n", options.seed);
fprintf(fileID, "\t""max_iter"": %d,\n", options.max_iter);
fprintf(fileID, "\t""max_gen_iter"": %d,\n", options.max_gen_iter);
fprintf(fileID, "\t""stepsize"": [%f %f],\n", options.stepsize);
fprintf(fileID, "\t""l"": %f,\n", options.l);
fprintf(fileID, "\t""r_tol"": %f,\n", options.r_tol);
fprintf(fileID, "\t""g_tol"": %f,\n", options.g_tol);
fprintf(fileID, "\t""step_scheme"": ""%s"",\n", options.step_scheme);
fprintf(fileID, "\t""orth_scheme"": ""%s"",\n", options.orth_scheme);
fprintf(fileID, "\t""subspace_scheme"": ""%s"",\n", options.subspace_scheme);
% physics model param
fprintf(fileID, "\t""kappa"": %d\n", kappa);
fprintf(fileID, "\t""ratio"": [%f %f],\n", ratio(1), ratio(2));
fprintf(fileID, "}");
fclose(fileID);
end

