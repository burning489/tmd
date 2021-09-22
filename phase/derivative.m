function f = derivative(x)
% DERIVATIVE Approximate partial derivative of energy functional of the phase parameter.
% x: (n,1) double
%    Input phase.
% f: (n,1) double
%    Partial derivative.
global N Lx Ly kappa e_0 stiffness a b c ratio;
n = N*N;
x1 = x(1:n);
x2 = x(n+1:2*n);
x3 = x(2*n+1:end);
f = zeros(size(x));
del = laplacian();
f(1:n) =  a*x1 - b*x1.^3 + c*x1.^5 + 2*c*x1.^3.*(x2.^2+x3.^2) + c*x1.*(x2.^4 + x3.^4) + 2*c*x1.*x2.^2.*x3.^2;
f(1:n) = f(1:n) - ratio(1)*kappa*del*x1*N*N/Lx/Ly;
f(n+1:2*n) =  a*x2 - b*x2.^3 + c*x2.^5 + 2*c*x2.^3.*(x1.^2+x3.^2) + c*x2.*(x1.^4 + x3.^4) + 2*c*x2.*x1.^2.*x3.^2;
f(n+1:2*n) = f(n+1:2*n) - ratio(1)*kappa*del*x2*N*N/Lx/Ly;
f(2*n+1:end) =  a*x3 - b*x3.^3 + c*x3.^5 + 2*c*x3.^3.*(x1.^2+x2.^2) + c*x3.*(x1.^4 + x2.^4) + 2*c*x3.*x1.^2.*x2.^2;
f(2*n+1:end) = f(2*n+1:end) - ratio(1)*kappa*del*x3*N*N/Lx/Ly;

[exx, exy, eyy] = strain(x);
f(1:n) = f(1:n) + ratio(2)*2*(stiffness(1)*(e_0(1,1,1)^2 + e_0(2,2,1)^2) + 4*stiffness(2)*e_0(1,2,1)^2 + 2*stiffness(3)*e_0(1,1,1)*e_0(2,2,1)).*x1.^3;
f(n+1:2*n) = f(n+1:2*n) + ratio(2)*2*(stiffness(1)*(e_0(1,1,2)^2 + e_0(2,2,2)^2) + 4*stiffness(2)*e_0(1,2,2)^2 + 2*stiffness(3)*e_0(1,1,2)*e_0(2,2,2)).*x2.^3;
f(2*n+1:3*n) = f(2*n+1:3*n) + ratio(2)*2*(stiffness(1)*(e_0(1,1,3)^2 + e_0(2,2,3)^2) + 4*stiffness(2)*e_0(1,2,3)^2 + 2*stiffness(3)*e_0(1,1,3)*e_0(2,2,3)).*x3.^3;
f(1:n) = f(1:n) - ratio(2)*2*(stiffness(1)*(exx*e_0(1,1,1)+eyy*e_0(2,2,1)) + 4*stiffness(2)*exy*e_0(1,2,1) + stiffness(3)*(exx*e_0(2,2,1)+eyy*e_0(1,1,1))).*x1;
f(n+1:2*n) = f(n+1:2*n) - ratio(2)*2*(stiffness(1)*(exx*e_0(1,1,2)+eyy*e_0(2,2,2)) + 4*stiffness(2)*exy*e_0(1,2,2) + stiffness(3)*(exx*e_0(2,2,2)+eyy*e_0(1,1,2))).*x2;
f(2*n+1:3*n) = f(2*n+1:3*n) - ratio(2)*2*(stiffness(1)*(exx*e_0(1,1,3)+eyy*e_0(2,2,3)) + 4*stiffness(2)*exy*e_0(1,2,3) + stiffness(3)*(exx*e_0(2,2,3)+eyy*e_0(1,1,3))).*x3;
end