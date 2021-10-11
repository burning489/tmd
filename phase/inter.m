function [e_inter, f_inter] = inter(x)
% INTER Compute interface energy of phase x.
% x: (n,1) double
%    Input phase.
% e_inter: double
%          Output interface energy.
% f_inter: (n,1) double
%          Output interface energy function.
global N kappa ratio;
n = N*N;
x1 = x(1:n);
x2 = x(n+1:2*n);
x3 = x(2*n+1:end);
f_inter =  kappa/2*(grad2(x1)+grad2(x2)+grad2(x3));
e_inter = sum(sum(f_inter))/N/N;
e_inter = e_inter*ratio(1);
end