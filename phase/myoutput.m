function stop = myoutput(x, optimValues, state)
global N root_path runid;
n = N*N;
stop = false;
switch state
    case 'init'
        
    case 'iter'
      
    case 'done'
end
if state == "init" || state == "done" || mod(optimValues.n_iter, 1e2) == 0
%     phase plots
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
    saveas(2, sprintf(root_path+"/results/run%03d/plot/phase_%d.png", runid, optimValues.n_iter));
%     save x and v
    x = optimValues.x;
    v = optimValues.v;
    save(sprintf(root_path+"/results/run%03d/data/xv_%d.mat", runid, optimValues.n_iter), "x", "v");
end
end