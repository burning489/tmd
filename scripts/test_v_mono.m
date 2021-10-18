clean;
load('log.mat');
t = linspace(-20, 20, 1000);
f = zeros(size(t));
fx = energy(x);
for i=1:size(v_s, 2)
    nexttile;   
    for j=1:length(t)
        f(j) = fx - energy(x+t(j)*v_s(:,i));
    end
    plot(t, f);
    xlabel('step')
    ylabel('f(x)-f(x+lv)');
    title(sprintf("v%d", i));
end
for i=1:size(v_l, 2)
    nexttile;   
    for j=1:length(t)
        f(j) = fx - energy(x+t(j)*v_l(:,i));
    end
    plot(t, f);
    xlabel('step')
    ylabel('f(x)-f(x+lv)');
    title(sprintf("v%d", i));
end
savefig(gcf, "log.fig");