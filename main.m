clear, close all

%% preprocess working directory
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

%% setup
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

%% initial minimization
% fun = @energy;
% options.plot_fcn = @plot_fval;
% [x, fval, exitflag, output] = steepest(fun, x0, options);
% output.iterations
% output.message

% x0 = load("phase6.mat").phase6;
x0 = zeros(3*n, 1);

%% specify solver parameter
grad = @derivative;
% HiOSD params
k = 1;
options.energy = @energy;
options.scheme = 1;
options.dimer = 1e-9;
options.k = k;
options.x_tol = 1e-9;
options.f_tol = 1e-9;
options.plot_fcn = @plot_fval;
options.stepsize = [1e-2 1e-2];
options.gen_gamma = options.stepsize(2);

%% generate unstable subspace v
v0 = generate_v(grad, x0, k, options);
x0 = x0 + 1e-1*v0;
options.v0 = v0;

%% ratios
r1 = [0.5 1 2];
r2 = [1 1e1 1e2 1e3 1e4];
attempts = 0;
for i = 1:length(r1)
    for j = 1:length(r2)
        attempts = attempts + 1;
        ratio = [ri(i) r2(j)];
        fprintf("ratio = [%f,%f]\n", ratio);
        %% HiOSD
        [x, fval, exitflag, output] = hiosd(grad, x0, options);
        
        %% postprocess
        output.message
        if exitflag
            h = gcf;
            saveas(h, sprintf("en%d.jpg", attempts));
            save(sprintf("main%d.mat", attempts));
            close all;
            plot_phase(x);
            saveas(gcf, sprintf("x%d.jpg", attempts));
            close all;
        end
    end
end

diary off
