function [partial_x, partial_y] = partial()
% PARTIAL Partial operator for 2D mesh generated by MATLAB.
global N;
e = ones(N^2,1);
partial_x = spdiags([e -e e -e], [-N*(N-1) -N N N*(N-1)], N^2, N^2);
e = ones(N, 1);
E = spdiags([e, -e], [1, -1], N, N);
I = speye(N,N);
partial_y = kron(I, E);
for i=1:N
    partial_y(i*N, (i-1)*N+1) = 1;
    partial_y((i-1)*N+1, i*N) = -1;
end
end