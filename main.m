clear, close all

%% preprocess working directory
if exist('log.txt', 'file')
    delete('./log.txt');
end

if exist('mgs.txt', 'file')
    delete('./mgs.txt');
end

%% setup
diary log.txt

setup;

global N options;

rng('default');

%% initial minimization
% fun = @energy;
% options.plot_fcn = @plot_fval;
% [x, fval, exitflag, output] = steepest(fun, x0, options);
% output.iterations
% output.message

x0 = zeros(3*n, 1);
% x0(1:n) = 1;

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
% options.stepsize = [1e-4 1e-4];
options.gen_gamma = options.stepsize(2);

%% generate unstable subspace v
v0 = generate_v(grad, x0, k, options);
x0 = x0 + 1e-1*v0(:,1);
options.v0 = v0(:,1:end);

ratio = [1, 0];
x0(n+1:end)=0;
[x, fval, exitflag, output] = hiosd(grad, x0, options);

%% postprocess
output.message
% if exitflag
%     h = gcf;
%     saveas(h,"./main.jpg");
%     save("main.mat");
%     close all;
%     plot_phase(x);
%     saveas(gcf, "x.jpg");
%     close all;
% end

% %% ratios
% r1 = [1e3];
% r2 = [0];
% attempts = 0;
% for i = 1:length(r1)
%     for j = 1:length(r2)
%         attempts = attempts + 1;
%         ratio = [r1(i) r2(j)];
%         fprintf("ratio = [%f,%f]\n", ratio);
%         %% HiOSD
%         [x, fval, exitflag, output] = hiosd(grad, x0, options);
%
%         %% postprocess
%         output.message
%         if exitflag
%             h = gcf;
%             saveas(h, sprintf("en%d.jpg", attempts));
%             save(sprintf("main%d.mat", attempts));
%             close all;
%             plot_phase(x);
%             saveas(gcf, sprintf("x%d.jpg", attempts));
%             close all;
%         end
%     end
% end

diary off
