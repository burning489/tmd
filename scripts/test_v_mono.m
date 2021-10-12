% clean;
% load('/Users/dz/Documents/MATLAB/tmd/results/result_006.mat');
% steps = logspace(-1, -5, 5);
% fileid = fopen('log.txt','w');
% fprintf(fileid, "  stepsize  ");
% for i=1:5
%     fprintf(fileid, "%15e ", -steps(i));
% end
% for i=5:-1:1
%     fprintf(fileid, "%15e ", steps(i));
% end
% fprintf(fileid, "\n");
% for i=1:size(v,2)
%     fprintf(fileid, "f(x)-f(x+lv)");
%     for j=1:5
%         fprintf(fileid, "%15e ", energy(x) - energy(x-steps(j)*v(:,i)));
%     end
%     for j=5:-1:1
%         fprintf(fileid, "%15e ", energy(x) - energy(x+steps(j)*v(:,i)));
%     end
%     fprintf(fileid, "\n");
% end
% fprintf(fileid,"\n");
% fclose(fileid);

clean;
load('/Users/dz/Documents/MATLAB/tmd/results/result_006.mat');
t = linspace(-1, 1, 1000);
f = zeros(size(t));
fx = energy(x);
for i=1:10
    nexttile;
    for j=1:length(t)
        f(j) = fx - energy(x+t(j)*v(:,i));
    end
    plot(t, f);
    xlabel('step')
    ylabel('f(x)-f(x+lv)');
    title(sprintf("v%d", i));
end