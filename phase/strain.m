function [exx, exy, eyy] = strain(eta)
% STRAIN Compute strain for phase parameter (3*N*N,1) eta.
% model Input
global N Lx Ly stiffness s_0 kx ky;

% displacement
r1 = zeros(N, N);
r2 = zeros(N, N);
for i=1:3
    eta_p = reshape(eta(N*N*(i-1)+1:N*N*i),N,N);
%     normalization
    eta_hat2 = fft2(eta_p.^2)/(Lx*Ly);
    eta_hat2(1,1) = 0;
    r1 = r1 + eta_hat2.*(s_0(1,1,i).*kx + s_0(1,2,i).*ky);
    r2 = r2 + eta_hat2.*(s_0(2,1,i).*kx + s_0(2,2,i).*ky);
end
r1 = -1i*r1;
r2 = -1i*r2;
delta = stiffness(1)*stiffness(2)*(kx.^4 + ky.^4) + ...
    (stiffness(1)^2 - stiffness(3)^2 - 2*stiffness(1)*stiffness(3))*kx.^2.*ky.^2;
ux_hat = (stiffness(2)*kx.^2 + stiffness(1)*ky.^2).*r1 - (stiffness(2)+stiffness(2))*kx.*ky.*r2;
uy_hat = (stiffness(1)*kx.^2 + stiffness(2)*ky.^2).*r2 - (stiffness(2)+stiffness(2))*kx.*ky.*r1;
ux_hat = ux_hat./delta;
uy_hat = uy_hat./delta;
ux_hat(1,1) = 0;
uy_hat(1,1) = 0;
% normalization
ux_hat = ux_hat*Lx^2*Ly;
uy_hat = uy_hat*Lx*Ly^2;
ux = real(ifft2(ux_hat));
uy = real(ifft2(uy_hat));

% elastic strain tensor
[px, py] = partial();
hx = Lx/N;
hy = Ly/N;
exx = px*(ux(:))/(2*hx);
eyy = py*(uy(:))/(2*hy);
exy = (px*(uy(:))/(2*hx) + py*(ux(:))/(2*hy))/2;
end

