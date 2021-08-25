load("./phases.mat")
setup;
k = 5;
% options.gen_gamma = 1e-3;
% options.l = 1e-5;
% options.l_eps = 1e-10;
steps = [1e-4 1e-3 1e-2 1e-1 1e0];
for i=1:size(phases,2)
    phase = phases(:,i);
    v = generate_v(@derivative, phase, k, options);
    fx = -derivative(phase);
    dx = fx;
    for j = 1:k
        vj = v(:,j);
        dx = dx - 2*dot(fx,vj)*vj;
    end
    for j = 1:length(steps)
        f_diff = energy(phase) - energy(phase + steps(j)*dx);
        fprintf("%f\t", f_diff);
    end
    fprintf("\n");
end

steps = [1e-4 1e-3 1e-2 1e-1 1e0];
phase = xn;
options.l = 1e-3;
v = generate_v(@derivative, phase, k, options);
% v = vn;
fx = -derivative(phase);
dx = fx;
for j = 1:k
    vj = v(:,j);
    dx = dx - 2*dot(fx,vj)*vj;
end
for j = 1:length(steps)
    f_diff = energy(phase) - energy(phase + steps(j)*dx);
    fprintf("%f\t", f_diff);
end
fprintf("\n");
