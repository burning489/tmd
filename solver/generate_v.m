function v = generate_v(grad, x, k, options)
% GENERATE_V Generate an orthonormal basis of the k-dimension unstable subspace of x.
% Parameters
% ==============================
% grad: function handle
%       Derivative of function.
% x: (n,1) double
% k: integer
%    Index of target saddle point.
% options: struct
%          options.gen_gamma: double, default=1e-3
%                             Stepsize in iteration.
%          options.l: double, default=1e-9
%                             Dimer Length.
%          options.seed: integer or string, default="default"
%                        Seed of random number generator.
% See also dimer, mgs
if ~exist('options','var')
    options = []; 
end
if ~isfield(options,'gen_gamma')
    options.gen_gamma = 1e-3;  
end
if ~isfield(options,'l')
    options.l = 1e-9;  
end
if ~isfield(options,'seed')
    options.seed = 'default';  
end
rng(options.seed);
n = length(x);
v = randn(n,k);
for i=1:k
    vi = v(:,i);
    v(:,i) = vi - options.gen_gamma*dimer(grad, x, options.l, vi);
end
v = mgs(v);
end