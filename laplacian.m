function del = lap()
global N Lx Ly;
I = speye(N,N);
E = sparse(2:N,1:N-1,1,N,N);
D = E+E'-2*I;
del = kron(D,I)+kron(I,D);
for i=1:N
    %     left
    del(i, N*(N-1)+i) = 1;
    %     right
    del(N*(N-1)+i, i) = 1;
    %     top
    del(N*(i-1)+1, N*i) = 1;
    %     bottom
    del(N*i, N*(i-1)+1) = 1;
end
end
