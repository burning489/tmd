clean;
load('results/result_006.mat');
t = linspace(-10, 10, 1000);
f = zeros(size(t));
fx = energy(x);
for i=1:size(v,2)
    nexttile;
    for j=1:length(t)
        f(j) = fx - energy(x+t(j)*v(:,i));
    end
    plot(t, f);
    xlabel('step')
    ylabel('f(x)-f(x+lv)');
    title(sprintf("v%d", i));
end