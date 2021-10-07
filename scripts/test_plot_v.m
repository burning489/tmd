clean; setup;
load("results/result_003.mat");
for i=1:5
    test_energy(@energy, x, v(:,2*(i-1)+1:2*i), 0.5, 10);
    title(sprintf("energy along v%d,v%d", 2*(i-1)+1, 2*i));
end
saveas(gcf, "results/result_003.fig");