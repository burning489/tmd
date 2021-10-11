clean; setup;
load("results/result_006.mat");
for i=1:5
    test_energy(energy_fcn, x, v(:,2*(i-1)+1:2*i), 0.5, 10);
    title(sprintf("energy along v%d,v%d", 2*(i-1)+1, 2*i));
end
saveas(gcf, "results/result_006.fig");