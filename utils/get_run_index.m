function i = get_run_index()
% GET_RUN_INDEX Get the index for currnet run folders.
global root_path;
folders = dir(root_path+"/results/run*");
i = length(folders);
end