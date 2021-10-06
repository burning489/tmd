clean;

setup;

% initial phase field 1
eta = zeros(3*N*N, 1);
t = linspace(0,1,N);
[xx, yy] = meshgrid(t);
eta(1:N*N) = reshape(sin(2*pi*(2*xx*Lx+yy*Ly)), N*N, 1);

% initial phase field 2
% eta = zeros(3*N*N, 1);
% eta(1:N*N/2) = 1;

[exx1, exy1, eyy1] = strain(eta);
exx1 = reshape(exx1, N, N);
exy1 = reshape(exy1, N, N);
eyy1 = reshape(eyy1, N, N);

subplot(4,3,1)
surf(exx1);
subplot(4,3,2)
surf(exy1);
subplot(4,3,3)
surf(eyy1);

N = 128;
[kx, ky] = prepare_fft2(Lx, Ly, N);
eta = zeros(3*N*N, 1);
t = linspace(0,1,N);
[xx, yy] = meshgrid(t);
eta(1:N*N) = reshape(sin(2*pi*(2*xx*Lx+yy*Ly)), N*N, 1);

[exx2, exy2, eyy2] = strain(eta);
exx2 = reshape(exx2, N, N);
exy2 = reshape(exy2, N, N);
eyy2 = reshape(eyy2, N, N);

subplot(4,3,4)
surf(exx2);
subplot(4,3,5)
surf(exy2);
subplot(4,3,6)
surf(eyy2);

Lx = 0.5; Ly=0.5; N=64;
[kx, ky] = prepare_fft2(Lx, Ly, N);
eta = zeros(3*N*N, 1);
t = linspace(0,1,N);
[xx, yy] = meshgrid(t);
eta(1:N*N) = reshape(sin(2*pi*(2*xx*Lx+yy*Ly)), N*N, 1);

[exx3, exy3, eyy3] = strain(eta);
exx3 = reshape(exx3, N, N);
exy3 = reshape(exy3, N, N);
eyy3 = reshape(eyy3, N, N);

subplot(4,3,7)
surf(exx3);
subplot(4,3,8)
surf(exy3);
subplot(4,3,9)
surf(eyy3);

Lx = 1; Ly=1; N=128;
[kx, ky] = prepare_fft2(Lx, Ly, N);
eta = zeros(3*N*N, 1);
t = linspace(0,1,N);
[xx, yy] = meshgrid(t);
eta(1:N*N) = reshape(sin(2*pi*(2*xx*Lx+yy*Ly)), N*N, 1);

[exx4, exy4, eyy4] = strain(eta);
exx4 = reshape(exx4, N, N);
exy4 = reshape(exy4, N, N);
eyy4 = reshape(eyy4, N, N);

subplot(4,3,10)
surf(exx4(1:N/2,1:N/2));
subplot(4,3,11)
surf(exy4(1:N/2,1:N/2));
subplot(4,3,12)
surf(eyy4(1:N/2,1:N/2));