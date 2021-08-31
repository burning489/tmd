function stop = myoutput(x, optimValues, state)
global N;
n = N*N;
stop = false;
switch state
    case 'init'
        figure(2);
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
    case 'iter'
        if mod(optimValues.n_iter, 1e2)==0
            figure(2);
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
            title(sprintf("#iter = %d",optimValues.n_iter));
        end
    case 'done'
        figure(2);
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
end

