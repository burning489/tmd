clear, close all

if exist('log.txt', 'file')
    delete('./log.txt');
end

if exist('mgs.txt', 'file')
    delete('./mgs.txt');
end

% if exist('pngs','dir')
%     system('rm -rf ./pngs');
% end
% 
% if exist('mats','dir')
%     system('rm -rf ./mats');
% end
% 
% if exist('gifs','dir')
%     system('rm -rf ./gifs');
% end

% mkdir pngs
% mkdir mats
% mkdir gifs

diary log.txt

setup;

global N Lx Ly options;

rng('default');

phase1 = zeros(3*n, 1);
phase1(1:n/2) = 1;
phase1(n/2+11:n) = -1;

phase2 = zeros(3*n, 1);
phase2(n+1:2*n) = 1;

phase3 = zeros(3*n, 1);
phase3(2*n+1:3*n) = 1;

phase4 = zeros(3*n, 1);

phase5 = zeros(3*n, 1);
phase5_1 = ones(N, N);
phase5_1(1:N/2, 1:N/2) = -1;
phase5_1(N/2+1:end, N/2+1:end) = -1;
phase5(1:n) = phase5_1(:);

phase6 = zeros(3*n, 1);
phase6_1 = ones(N, N);
phase6_1(1:N*N/2) = -1;
phase6_2 = ones(N, N);
phase6_2(1:N*N/2) = -1;
phase6_2 = phase6_2';
phase6(1:n) = phase6_1(:);
phase6(n+1:2*n) = phase6_2(:);

% initial minimization
% fun = @energy;
% options.plot_fcn = @plot_fval;
% [x, fval, exitflag, output] = steepest(fun, x0, options);
% output.iterations
% output.message

% x0 = load("phase6.mat").phase6;
x0 = zeros(3*n, 1);

% k = 1;
% v0 = generate_v(grad, x0, k+1, options);
% % plot_phase(x0);
% x0 = x0 + 1e0*v0(:,end);
% % plot_phase(x0);
% v0(:,1) = [];

k = 1;
v0 = generate_v(grad, x0, k, options);
x0 = x0 + 1e-1*v0;

options.k = k;
options.v0 = v0;
options.x_tol = 1e-9;
options.f_tol = 1e-9;
options.plot_fcn = @plot_fval;

options.stepsize = [1e-2 1e-3];
[x, fval, exitflag, output] = model(grad, x0, options);
h = gcf;
savefig(h, "en.fig");
saveas(h, "en.jpg");
save("main.mat");

diary off
