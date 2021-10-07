function test_energy(f, x, v, dx, L)
% TEST_ENERGY Plot energy surface around x in directions from v.
% f: function handle
%    Function tested.
% x: (n,1) double
%    Input phase.
% v: (n,1) or (n,2) double
%    Unstable subspace at x.
% dx: double
%     interval
% L: double
%    length of perturbation
t = -L:dx:L;
assert(size(v,2)==2)
[xx, yy] = meshgrid(t, t);
Z = zeros(size(xx));
for i=1:length(t)
    for j=1:length(t)
        Z(i,j) =  f(x + xx(i,j)*v(:,1) + yy(i,j)*v(:,2));
    end
end
nexttile;
surf(xx, yy, Z);
end


