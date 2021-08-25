function e_inter = inter(x)
global N kappa;
n = N*N;
x1 = x(1:n);
x2 = x(n+1:2*n);
x3 = x(2*n+1:end);
f =  kappa/2*(grad2(x1)+grad2(x2)+grad2(x3));
e_inter = sum(sum(f))/N/N;
end