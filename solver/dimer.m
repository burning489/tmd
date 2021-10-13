function Hv = dimer(grad, x, l, v)
% DIMER Approximate projection of Hessian matrix H along direction v
% H*v $\approx$ (grad(x+l*v) - grad(x-l*v))/(2*l)
% Input
% ==============================
% grad: function handle
%       Derivative of function.
% x: (n,1) double
% l: double
%    Dimer length.
% v: (n,1) double
%    Unstable direction.
Hv = (grad(x+l*v) - grad(x-l*v))/(2*l);
end