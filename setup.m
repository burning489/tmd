%% path management 
addpath(genpath("."));

%% global variables
global N max_iter a b c kappa Lx Ly stiffness theta s_0 e_0 kx ky EPS options cnt ratio;
cnt = 1;
max_iter = 1e6;
kappa = 1e-3;
syms theta;
EPS = 1e-10;
N = 64;
Lx = 1;
Ly = sqrt(3);
MU = 50;
NU = 0.24;
E_XX_0 = -0.0299;
E_YY_0 = 0.0374;
THETA = [0, 2*pi/3, -2*pi/3];
a = 0.0031;
b = 0.002;
c = 0.00125;
ratio = [1, 1];
n = N^2;

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
% generate_v params
options.seed = 'default';
options.max_iter = max_iter;
options.gen_gamma = 1e-3;
% HiOSD params
options.call_back = @output;
options.tol = 1e-3*N*N;
options.l_eps = 1e-10;
options.scheme = 1;
options.stepsize = [1e-3 1e-3];
options.energy = @energy;
options.dimer = 1e-9;