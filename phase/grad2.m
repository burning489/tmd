function g2 = grad2(x)
% GRAD2 Square of length of gradient of x, i.e. partial_x.^2 + partial_y.^2.
% x: (N,1) double
%    Input phase.
% g2: (N,1) double
%     Output.
% See also partial
global N Lx Ly;
[px, py] = partial();
hx = Lx/N;
hy = Ly/N;
g2 = (px*x/(2*hx)).^2 + (py*x/(2*hy)).^2;
end