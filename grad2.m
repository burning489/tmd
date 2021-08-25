function g2 = grad2(x)
global N Lx Ly;
[px, py] = partial();
hx = Lx/N;
hy = Ly/N;
g2 = (px*x/(2*hx)).^2 + (py*x/(2*hy)).^2;
end