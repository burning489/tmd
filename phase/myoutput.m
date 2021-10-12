function stop = myoutput(x, optimValues, state)
global N root_path timestamp;
n = N*N;
stop = false;
if state == "init" || state == "done" || mod(optimValues.n_iter, 1e3) == 0
    % plots
    set(0, 'CurrentFigure', 2);
    subplot(1,3,1);
    imagesc(reshape(x(1:n),N,N));
    colorbar;
    axis square;
    title(sprintf("#iter = %d",optimValues.n_iter));
    subplot(1,3,2);
    imagesc(reshape(x(n+1:2*n),N,N));
    colorbar;
    axis square;
    subplot(1,3,3);
    imagesc(reshape(x(2*n+1:3*n),N,N));
    colorbar;
    axis square;
    saveas(2, sprintf(root_path+"/results/r%s/plots/phase_%d.png", timestamp, optimValues.n_iter));
    saveas(2, sprintf(root_path+"/results/r%s/phase_%d.png", timestamp, optimValues.n_iter));
    % chcekpoints
    x = optimValues.x;
    v = optimValues.v;
    save(sprintf(root_path+"/results/r%s/checkpoints/xv_%d.mat", timestamp, optimValues.n_iter), "x", "v");
end
end