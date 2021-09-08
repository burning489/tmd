function stop = myoutput(x, optimValues, state)
global N root_path;
n = N*N;
stop = false;
switch state
    case 'init'
        set(0, 'CurrentFigure', 2);
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
        sgtitle(sprintf("#iter = %d",optimValues.n_iter));
        i = get_run_index();
        saveas(2, sprintf(root_path+"/results/run%03d/phase_%07d.png", i, optimValues.n_iter));
    case 'iter'
        if mod(optimValues.n_iter, 1e2)==0
            set(0, 'CurrentFigure', 2);
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
            sgtitle(sprintf("#iter = %d",optimValues.n_iter));
            i = get_run_index();
            saveas(2, sprintf(root_path+"/results/run%03d/phase_%07d.png", i, optimValues.n_iter));
        end
    case 'done'
        set(0, 'CurrentFigure', 2);
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
        sgtitle(sprintf("#iter = %d",optimValues.n_iter));
        i = get_run_index();
        saveas(2, sprintf(root_path+"/results/run%03d/phase_%07d.png", i, optimValues.n_iter));
end
end

