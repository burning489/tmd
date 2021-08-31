% Test bulk energy function
setup;

%% Plot sphere heatmap of bulk energy w.r.t. three phases.
x = 0:0.01:1;
y = x;
z = x;
[X,Y,Z] = meshgrid(x,y,z);
mask = X.^2 + Y.^2 + Z.^2 <= 1 &  X.^2 + Y.^2 + Z.^2 >= 0.9 | (X==0 & Y.^2+Z.^2 <= 1)  | (Y==0 & X.^2+Z.^2 <= 1);
grids = length(x);
F = zeros(grids, grids, grids);
eta = zeros(3*n, 1);
for i=1:grids
    for j=1:grids
        for k=1:grids
            if mask(i,j,k)
                eta(1:n) = x(i);
                eta(n+1:2*n) = y(j);
                eta(2*n+1:3*n) = z(k);
                F(i,j,k) = bulk(eta);
            end
        end
    end
end
scatter3(X(mask),Y(mask),Z(mask),20,F(mask));

% %% Plot energy surface around x0
% x0 = zeros(3*n,1);
% v0 = generate_v(grad, x0, 2, options);
% test_energy(@bulk, x0, v0);
% 
% x0 = zeros(3*n,1);
% x0(1:n) = 1;
% v0 = generate_v(grad, x0, 2, options);
% test_energy(@bulk, x0, v0);
% 
% x0 = zeros(3*n,1);
% x0(1:n) = -1;
% v0 = generate_v(grad, x0, 2, options);
% test_energy(@bulk, x0, v0);
% 
% x0 = zeros(3*n,1);
% x0(n+1:2*n) = 1;
% v0 = generate_v(grad, x0, 2, options);
% test_energy(@bulk, x0, v0);
% 
% x0 = zeros(3*n,1);
% x0(n+1:2*n) = -1;
% v0 = generate_v(grad, x0, 2, options);
% test_energy(@bulk, x0, v0);
% 
% x0 = zeros(3*n,1);
% x0(2*n+1:3*n) = 1;
% v0 = generate_v(grad, x0, 2, options);
% test_energy(@bulk, x0, v0);
% 
% x0 = zeros(3*n,1);
% x0(2*n+1:3*n) = -1;
% v0 = generate_v(grad, x0, 2, options);
% test_energy(@bulk, x0, v0);
