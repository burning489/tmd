function e_chem = chem(x)
% CHEM Compute chemical energy of phase x.
% x: (n,1) double
%    Input phase.
% e_chem: double
%         Output chemical energy.
% See Also
% bulk, inter
e_bulk = bulk(x);
e_inter = inter(x);
e_chem = e_bulk + e_inter;
end