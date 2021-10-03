function test_energy(f, x, v)
% TEST_ENERGY Plot energy surface around x in directions from v.
% f: function handle
%    Function tested.
% x: (n,1) double
%    Input phase.
% v: (n,1) or (n,2) double
%    Unstable subspace at x.
figure;
L = 0.5;
t = -L:1e-2:L;
if size(v,2) > 1
    [xx, yy] = meshgrid(t, t);
    Z = zeros(size(xx));
    for i=1:length(t)
        for j=1:length(t)
            Z(i,j) =  f(x + xx(i,j)*v(:,1) + yy(i,j)*v(:,2));
        end
    end
    surf(xx, yy, Z);
else
    y = zeros(size(t));
    for i=1:length(t)
        y(i) = f(x + t(i)*v);
    end
    plot(t,y);
end
end


