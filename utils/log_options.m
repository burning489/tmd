function log_options(options)
global root_path timestamp kappa ratio;

fileID = fopen(sprintf(root_path+"/results/r%s/settings.json", timestamp), "w");
fprintf(fileID, "{\n"); 

% search params
fprintf(fileID, "\t""start_index"": %d,\n", options.k0);
fprintf(fileID, "\t""search_index"": %d,\n", options.k);
fprintf(fileID, "\t""perturb_eps"": %f,\n", options.perturb_eps);
% gen_v params
fprintf(fileID, "\t""max_gen_iter"": %d,\n", options.max_gen_iter);
fprintf(fileID, "\t""stepsize"": [%f, %f],\n", options.stepsize);
fprintf(fileID, "\t""l"": %f,\n", options.l);
fprintf(fileID, "\t""tau"": %f,\n", options.tau);
fprintf(fileID, "\t""rng_seed"": %d,\n", options.seed);
fprintf(fileID, "\t""r_tol"": %f,\n", options.r_tol);
fprintf(fileID, "\t""mgs_eps"": %f,\n", options.mgs_eps);
fprintf(fileID, "\t""norm_scheme"": ""%s"",\n", options.norm_scheme);
fprintf(fileID, "\t""orth_scheme"": ""%s"",\n", options.orth_scheme);
fprintf(fileID, "\t""subspace_scheme"": ""%s"",\n", options.subspace_scheme);
% solver params
fprintf(fileID, "\t""max_iter"": %d,\n", options.max_iter);
fprintf(fileID, "\t""g_tol"": %f,\n", options.g_tol);
fprintf(fileID, "\t""step_scheme"": ""%s"",\n", options.step_scheme);
% physical model params
fprintf(fileID, "\t""kappa"": %d,\n", kappa);
fprintf(fileID, "\t""ratio"": [%f, %f],\n", ratio(1), ratio(2));

fprintf(fileID, "}");
fclose(fileID);
end

