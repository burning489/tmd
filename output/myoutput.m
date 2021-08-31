function stop = myoutput(x, optimValues, state)
global N;
n = N*N;
stop = false;
switch state
    case 'init'
        figure(2);
        imagesc(reshape(x,N,N));
        colorbar;
        axis square;
        %         subplot(1,3,1);
        %         imagesc(reshape(x(1:n),N,N));
        %         colorbar;
        %         axis square;
        %         subplot(1,3,2);
        %         imagesc(reshape(x(n+1:2*n),N,N));
        %         colorbar;
        %         axis square;
        %         subplot(1,3,3);
        %         imagesc(reshape(x(2*n+1:3*n),N,N));
        %         colorbar;
        %         axis square;
    case 'iter'
        if mod(optimValues.n_iter, 1e2)==0
            figure(2);
            imagesc(reshape(x,N,N));
            colorbar;
            axis square;
            %             subplot(1,3,1);
            %             imagesc(reshape(x(1:n),N,N));
            %             colorbar;
            %             axis square;
            %             subplot(1,3,2);
            %             imagesc(reshape(x(n+1:2*n),N,N));
            %             colorbar;
            %             axis square;
            %             subplot(1,3,3);
            %             imagesc(reshape(x(2*n+1:3*n),N,N));
            %             colorbar;
            %             axis square;
            title(sprintf("#iter = %d",optimValues.n_iter));
        end
    case 'done'
        figure(2);
        imagesc(reshape(x,N,N));
        colorbar;
        axis square;
        %         subplot(1,3,1);
        %         imagesc(reshape(x(1:n),N,N));
        %         colorbar;
        %         axis square;
        %         subplot(1,3,2);
        %         imagesc(reshape(x(n+1:2*n),N,N));
        %         colorbar;
        %         axis square;
        %         subplot(1,3,3);
        %         imagesc(reshape(x(2*n+1:3*n),N,N));
        %         colorbar;
        %         axis square;
end
end
% function output(xs, ~, f_norms, ~, n_iter)
% global N options cnt;
% n = N^2;

% figH = figure('visible','off');
% ax1 = subplot(4,3,[1 2 3]);
% plot(1:n_iter+1, f_norms(1:n_iter+1));
% title(ax1, 'L_2 norm of gradient of function');

% ax2 = subplot(4,3,[4 5 6]);
% fs = zeros(1+n_iter,1);
% for i=1:n_iter+1
%     fs(i) = energy(xs(i,:)');
% end
% plot(1:n_iter+1, fs);
% title(ax2, 'energy at each iteration');

% ax3 = subplot(4,3,7);
% imagesc(reshape(xs(1,1:n), N, N));
% colorbar;
% title(ax3, 'start state 1')

% ax4 = subplot(4,3,8);
% imagesc(reshape(xs(1,n+1:2*n), N, N));
% colorbar;
% title(ax4, 'start state 2')

% ax5 = subplot(4,3,9);
% imagesc(reshape(xs(1,2*n+1:3*n), N, N));
% colorbar;
% title(ax5, 'start state 3')

% ax6 = subplot(4,3,10);
% imagesc(reshape(xs(n_iter+1,1:n), N, N));
% colorbar;
% title(ax6, 'end state 1')

% ax7 = subplot(4,3,11);
% imagesc(reshape(xs(n_iter+1,n+1:2*n), N, N));
% colorbar;
% title(ax7, 'end state 2')

% ax8 = subplot(4,3,12);
% imagesc(reshape(xs(n_iter+1,2*n+1:3*n), N, N));
% colorbar;
% title(ax8, 'end state 3')

% prefix = sprintf("%03d", cnt);
% png_name = "./pngs/" + prefix + ".png";
% saveas(gcf, png_name);
% close(figH);

% % txtName = './'+prefix+'/ex7.txt';
% % fileID = fopen(txtName,'w');
% % fprintf(fileID,'%6s %12s %12s %12s %12s %12s %12s %12s %12s\n','iter', '1e-6', '1e-5', '1e-4', '1e-3', '1e-2', '1e-1', '1');
% % steps = [1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1];
% % for i = 1:n_iter
% %     fprintf(fileID,'%6d ', i);
% %     for j=1:7
% %         fprintf(fileID, '%12.8f ', energy(xs(i,:)' + steps(j)*directions(i,:)', options) - energy(xs(i,:)', options));
% %     end
% %     fprintf(fileID, "\n");
% % end
% % fclose(fileID);

% mat_name = "./mats/" + prefix + ".mat";
% t = 1:100:n_iter+1;
% xs_sample = xs(t, :);
% f_norms_trunc = f_norms(t);
% save(mat_name, 'xs_sample', 'n_iter', 'f_norms_trunc');

% gif_name = "./gifs/" + prefix + ".gif";
% cnt = cnt + 1;
% h = figure('visible','off');
% axis tight manual

% ax1 = subplot(3,3,[1 2 3]);
% plot(1:n_iter+1, f_norms(1:n_iter+1));
% title(ax1, sprintf('L_2 norm of gradient of function, iterations=%d',n_iter));

% ax2 = subplot(3,3,[4 5 6]);
% plot(1:n_iter+1, fs);
% title(ax2, 'energy at each iteration');

% for i = 1:length(t)
%     ax3 = subplot(3,3,7);
%     imagesc(reshape(xs_sample(i, 1:n), N, N));
%     axis square;
%     colorbar;
%     title(ax3, 'phase 1')

%     ax4 = subplot(3,3,8);
%     imagesc(reshape(xs_sample(i, n+1:2*n), N, N));
%     axis square;
%     colorbar;
%     title(ax4, 'phase 2')

%     ax5 = subplot(3,3,9);
%     imagesc(reshape(xs_sample(i, 2*n+1:3*n), N, N));
%     axis square;
%     colorbar;
%     title(ax5, 'phase 3')
%     drawnow

%     frame = getframe(h);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256);

%     if i == 1
%         imwrite(imind,cm,gif_name,'gif', 'Loopcount',inf, 'DelayTime',0.1);
%     else
%         imwrite(imind,cm,gif_name,'gif','WriteMode','append', 'DelayTime',0.1);
%     end
% end
% close(h);
% end

