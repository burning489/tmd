function plot_phase(x)
	global N;
	n = N*N;
	figure;
	subplot(1,3,1);
	imagesc(reshape(x(1:n),N,N));
	colorbar;
	axis square;
	subplot(1,3,2);
	imagesc(reshape(x(n+1:2*n),N,N));
	colorbar;
	axis square;
	subplot(1,3,3);
	imagesc(reshape(x(2*n+1:3*n),N,N));
	colorbar;
	axis square;
end