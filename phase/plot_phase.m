function plot_phase(x)
% PLOT_PHASE Plot phase graph for (3*N*N,1) x.
	global N;
	n = N*N;
	if ismac | ispc
		figure;
	else
		figure("Visible", "off");
	end	
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