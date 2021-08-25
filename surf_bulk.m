function surf_bulk(x)
global N a b c;
n = N*N;
x1 = x(1:n);
x2 = x(n+1:2*n);
x3 = x(2*n+1:end);
f = a/2*(x1.^2 + x2.^2 + x3.^2) - b/4*(x1.^4 + x2.^4 + x3.^4);
f = f + c/6*(x1.^6 + 3*x1.^4.*(x2.^2+x3.^2) + 3*x1.^2.*(x2.^4+x3.^4) + ...
    6*x1.^2.*x2.^2.*x3.^2 + x2.^6 + x3.^6 + 3*x2.^2.*x3.^2.*(x2.^2+x3.^2));
figure;
t = 1:N;
[X, Y] = meshgrid(t/N, t/N);
surf(X,Y,reshape(f,N,N));
title('bulk energy density function at the saddle');
saveas(gcf, 'bulk.jpg');
end