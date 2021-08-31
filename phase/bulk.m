function [e_bulk, f_bulk ]= bulk(x)
% BULK Compute bulk energy of phase x.
% x: (n,1) double
%    Input phase.
% e_bulk: double
%         Output bulk energy.
% f_bulk: (n,1) double
%         Output bulk energy function.
global N;
f_bulk = 1/4*(1-x.^2).^2;
e_bulk = sum(sum(f_bulk))/N/N;
end

% function [e_bulk, f_bulk ]= bulk(x)
% % BULK Compute bulk energy of phase x.
% % x: (n,1) double
% %    Input phase.
% % e_bulk: double
% %         Output bulk energy.
% % f_bulk: (n,1) double
% %         Output bulk energy function.
% global N a b c;
% n = N*N;
% x1 = x(1:n);
% x2 = x(n+1:2*n);
% x3 = x(2*n+1:end);
% f_bulk = a/2*(x1.^2 + x2.^2 + x3.^2) - b/4*(x1.^4 + x2.^4 + x3.^4);
% f_bulk = f_bulk + c/6*(x1.^6 + 3*x1.^4.*(x2.^2+x3.^2) + 3*x1.^2.*(x2.^4+x3.^4) + ...
%     6*x1.^2.*x2.^2.*x3.^2 + x2.^6 + x3.^6 + 3*x2.^2.*x3.^2.*(x2.^2+x3.^2));
% % f_bulk(n+1:end) = 0;
% e_bulk = sum(sum(f_bulk))/N/N;
% end

