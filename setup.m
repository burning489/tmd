%% path management 
addpath(genpath("."));

if ~exist("results", 'dir')
    mkdir("results/")
end

%% global variables
global N max_iter a b c kappa Lx Ly stiffness theta s_0 e_0 kx ky EPS ratio root_path;
max_iter = 5e6;
kappa = 0.01;
syms theta;
EPS = 1e-10;
N = 64;
Lx = 1;
% Ly = sqrt(3);
Ly = 1;
MU = 50;
NU = 0.24;
E_XX_0 = -0.0299;
E_YY_0 = 0.0374;
THETA = [0, 2*pi/3, -2*pi/3];
% a = 3; b=2; c=1;
a = 2.4; b=8.4; c=6;
ratio = [1, 0];
n = N^2;
root_path = pwd;

%% Kronecker Delta function
k_delta = @(x, y) double(x==y);

%% elastic modulus(stiffness)
stiffness = [2*MU/(1-NU) MU 2*MU*NU/(1-NU)];

%% transformation strain tensor
e = [E_XX_0, 0; 0, E_YY_0];
r = [cos(theta), -sin(theta); sin(theta), cos(theta)];
et = r*e*r.';
e_0 = zeros(2, 2, 3);
e_0(:,:,1) = double(subs(et, theta, THETA(1)));
e_0(:,:,2) = double(subs(et, theta, THETA(2)));
e_0(:,:,3) = double(subs(et, theta, THETA(3)));

%% transformation stress tensor
s_0 = zeros(2, 2, 3);
for i=1:3
    s_0(:,:,i) = [stiffness(1)*e_0(1,1,i) + stiffness(3)*e_0(2,2,i), ...
        stiffness(2)*e_0(1,2,i) + stiffness(2)*e_0(2,1,i); ...
        stiffness(2)*e_0(1,2,i) + stiffness(2)*e_0(2,1,i), ...
        stiffness(3)*e_0(1,1,i) + stiffness(1)*e_0(2,2,i)];
end

%% prepare wave vectors
[kx, ky] = prepare_fft2(Lx, Ly, N);

%% global options
grad = @derivative;
k = 1;
options.k = k;
options.perturb_eps = 1e-1;
% generate_v params
options.stepsize = [1e-3 1e-3];
options.l = 1e-6;
options.seed = 'default';
% HiOSD params
options.max_iter = max_iter;
options.scheme = 1;
options.x_tol = 1e-9;
options.f_tol = 1e-9;
options.g_tol = 1e-2;
options.output_fcn = @myoutput;
options.plot_fcn = @plot_fval;
options.energy = @energy;
options.display = "notify";

