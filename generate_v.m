function v = generate_v(grad, x, k, options)
% Generate an orthonormal basis of the k-dimension unstable subspace of x.
if ~exist('options','var')
    options = []; 
end
if ~isfield(options,'gen_gamma')
    options.gen_gamma = 1e-3;  
end
if ~isfield(options,'l')
    options.l = 1e-6;  
end
if ~isfield(options,'seed')
    options.seed = 'default';  
end
rng(options.seed);
n = length(x);
v = randn(n,k);
vm1 = v+1;
vm1 = v;
for i=1:k
    vi = v(:,i);
    v(:,i) = vi - options.gen_gamma*dimer(grad, x, options.l, vi);
end
v = mgs(v);
end