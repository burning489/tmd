function gen_folder()
%GEN_FOLDER Generate new run folder.
global root_path;
i = get_run_index();
mkdir(sprintf(root_path+"/results/run%03d", i+1));
end

