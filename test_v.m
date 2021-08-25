clear, close all

for suffix=1:31
	fprintf("suffix=%3d\n", suffix);
	setup;
	load(sprintf("./mats/%03d.mat", suffix));
	t = 1:100:n_iter+1;
	fs_sample = zeros(length(t),1);
	for j=1:length(t)
		fs_sample(j) = energy(xs_sample(j,:)');
	end
	[~, ind] = max(fs_sample);
	x = xs_sample(ind,:)';
	k = 5;
	options.l = 1e-4;
	v = generate_v(@derivative, x, k, options);
	steps = [1e-4 1e-3 1e-2 1e-1 1e0 1e1];
	for v_i=1:5
		for step_i = 1:length(steps)
			f_diff = energy(x) - energy(x+steps(step_i)*v(:,v_i));
			% if f_diff > 1e-6
			% 	warning('!\n');
			% end
			fprintf("%12.10f\t", f_diff);
		end
		fprintf("\n");
	end
	fprintf("\n");
end
