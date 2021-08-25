function e_chem = chem(x)
e_bulk = bulk(x);
e_inter = inter(x);
e_chem = e_bulk + e_inter;
end