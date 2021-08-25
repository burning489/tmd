function Hv = dimer(grad, x, l, v)
% Approximate projection of Hessian matrix H along direction v.
% H*v \approx (grad(x+l*v) - grad(x-l*v))/(2*l)
Hv = (grad(x+l*v) - grad(x-l*v))/(2*l);
end