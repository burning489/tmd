function [e_chem, f_chem] = chem(x)
% CHEM Compute chemical energy of phase x.
% x: (n,1) double
%    Input phase.
% e_chem: double
%         Output chemical energy.
% See also bulk, inter
[e_bulk, f_bulk] = bulk(x);
[e_inter, f_inter] = inter(x);
e_chem = e_bulk + e_inter;
f_chem = f_bulk + f_inter;
end