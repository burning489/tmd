function e_tot = energy(x)
% ENERGY Compute total energy of phase x.
% x: (n,1) double
%    Input phase.
% e_tot: double
%        Output total energy.
% See also chem, elas

global ratio e_bulk e_inter e_elas
e_bulk = bulk(x);
e_inter = inter(x);
if ratio(2) == 0
	e_elas = 0;
else
    e_elas = elas(x);
end
e_tot = e_bulk + e_inter + e_elas;
end
