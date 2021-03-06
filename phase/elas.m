function [e_elas, f_elas] = elas(x)
% ELAS Compute elastic energy of phase x.
% x: (n,1) double
%    Input phase.
% e_elas: double
%         Output elastic energy.
% f_elas: (n,1) double
%         Output elastic energy function.
global N e_0 stiffness ratio;
[exx, exy, eyy] = strain(x);
n = N*N;
x1 = x(1:n);
x2 = x(n+1:2*n);
x3 = x(2*n+1:end);
f_elas = 1/2*stiffness(1)*(exx.^2+eyy.^2) + 2*stiffness(2)*exy.^2 + stiffness(3)*exx.*eyy;
f_elas = f_elas + 1/2*(stiffness(1)*(e_0(1,1,1)^2 + e_0(2,2,1)^2) + 4*stiffness(2)*e_0(1,2,1)^2 + 2*stiffness(3)*e_0(1,1,1)*e_0(2,2,1)).*x1.^4;
f_elas = f_elas + 1/2*(stiffness(1)*(e_0(1,1,2)^2 + e_0(2,2,2)^2) + 4*stiffness(2)*e_0(1,2,2)^2 + 2*stiffness(3)*e_0(1,1,2)*e_0(2,2,2)).*x2.^4;
f_elas = f_elas + 1/2*(stiffness(1)*(e_0(1,1,3)^2 + e_0(2,2,3)^2) + 4*stiffness(2)*e_0(1,2,3)^2 + 2*stiffness(3)*e_0(1,1,3)*e_0(2,2,3)).*x3.^4;
f_elas = f_elas - (stiffness(1)*(exx*e_0(1,1,1)+eyy*e_0(2,2,1)) + 4*stiffness(2)*exy*e_0(1,2,1) + stiffness(3)*(exx*e_0(2,2,1)+eyy*e_0(1,1,1))).*x1.^2;
f_elas = f_elas - (stiffness(1)*(exx*e_0(1,1,2)+eyy*e_0(2,2,2)) + 4*stiffness(2)*exy*e_0(1,2,2) + stiffness(3)*(exx*e_0(2,2,2)+eyy*e_0(1,1,2))).*x2.^2;
f_elas = f_elas - (stiffness(1)*(exx*e_0(1,1,3)+eyy*e_0(2,2,3)) + 4*stiffness(2)*exy*e_0(1,2,3) + stiffness(3)*(exx*e_0(2,2,3)+eyy*e_0(1,1,3))).*x3.^2;
e_elas = sum(sum(f_elas))/N/N;
e_elas = e_elas*ratio(2);
end