function e_tot = energy(x)
% ENERGY Compute total energy of phase x.
% x: (n,1) double
%    Input phase.
% e_tot: double
%        Output total energy.
% See also chem, elas

e_tot = chem(x) + elas(x);
% e_tot = chem(x);
end