clear, close all

setup;
n = N*N;
phases = zeros(3*n, 33);

phase5 = zeros(3*n, 1);
phase5_1 = ones(N, N);
phase5_1(1:N/2, 1:N/2) = -1;
phase5_1(N/2+1:end, N/2+1:end) = -1;
phase5(1:n) = phase5_1(:);

phase6 = zeros(3*n, 1);
phase6_1 = ones(N, N);
phase6_1(1:N*N/2) = -1;
phase6_2 = ones(N, N);
phase6_2(1:N*N/2) = -1;
phase6_2 = phase6_2';
phase6(1:n) = phase6_1(:);
phase6(n+1:2*n) = phase6_2(:);

phases(:,1) = phase5;
phases(:,2) = phase6;

for suffix=1:31
	load(sprintf("./mats/%03d.mat", suffix));
	t = 1:100:n_iter+1;
	fs_sample = zeros(length(t),1);
	for j=1:length(t)
		fs_sample(j) = energy(xs_sample(j,:)');
	end
	[~, ind] = max(fs_sample);
	% plot_phase(xs_sample(ind,:));
	% saveas(gcf,sprintf("/Users/dz/Desktop/%03d_%03d.png", suffix, ind));
	% close all;
	phases(:,suffix+2) = xs_sample(ind,:);
end

save("./phases.mat", "phases");
