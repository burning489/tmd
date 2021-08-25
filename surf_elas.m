function surf_elas(x)
global N e_0 stiffness ratio;
[exx, exy, eyy] = strain(x);
n = N*N;
x1 = x(1:n);
x2 = x(n+1:2*n);
x3 = x(2*n+1:end);
f = 1/2*stiffness(1)*(exx.^2+eyy.^2) + 2*stiffness(2)*exy.^2 + stiffness(3)*exx.*eyy;
f = f + 1/2*(stiffness(1)*(e_0(1,1,1)^2 + e_0(2,2,1)^2) + 4*stiffness(2)*e_0(1,2,1)^2 + 2*stiffness(3)*e_0(1,1,1)*e_0(2,2,1)).*x1.^4;
f = f + 1/2*(stiffness(1)*(e_0(1,1,2)^2 + e_0(2,2,2)^2) + 4*stiffness(2)*e_0(1,2,2)^2 + 2*stiffness(3)*e_0(1,1,2)*e_0(2,2,2)).*x2.^4;
f = f + 1/2*(stiffness(1)*(e_0(1,1,3)^2 + e_0(2,2,3)^2) + 4*stiffness(2)*e_0(1,2,3)^2 + 2*stiffness(3)*e_0(1,1,3)*e_0(2,2,3)).*x3.^4;
f = f - (stiffness(1)*(exx*e_0(1,1,1)+eyy*e_0(2,2,1)) + 4*stiffness(2)*exy*e_0(1,2,1) + stiffness(3)*(exx*e_0(2,2,1)+eyy*e_0(1,1,1))).*x1.^2;
f = f - (stiffness(1)*(exx*e_0(1,1,2)+eyy*e_0(2,2,2)) + 4*stiffness(2)*exy*e_0(1,2,2) + stiffness(3)*(exx*e_0(2,2,2)+eyy*e_0(1,1,2))).*x2.^2;
f = f - (stiffness(1)*(exx*e_0(1,1,3)+eyy*e_0(2,2,3)) + 4*stiffness(2)*exy*e_0(1,2,3) + stiffness(3)*(exx*e_0(2,2,3)+eyy*e_0(1,1,3))).*x3.^2;
figure;
t = 1:N;
[X, Y] = meshgrid(t/N, t/N);
surf(X,Y,reshape(f,N,N));
title('elastic energy density function at the saddle');
saveas(gcf, 'elas.jpg');
end