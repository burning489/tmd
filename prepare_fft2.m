% compute (normalized) wave numbers and relevant variables
function [kx, ky]= prepare_fft2(Lx, Ly, N)
k_x = [0:N/2 -N/2+1:-1]*(2*pi/Lx);
k_y = [0:N/2 -N/2+1:-1]*(2*pi/Ly);

global EPS;
k_x(1) = EPS;
k_y(1) = EPS;

[kx, ky] = meshgrid(k_x, k_y);

% normalization
kx = kx*Lx;
ky = ky*Ly;
end 