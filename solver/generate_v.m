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
%          options.stepsize: 1*2 double, default = [1e-3 1e-3]
%                            Stepsize in iterations of x and v respectively.
%          options.l: double, default=1e-6
%                             Dimer Length.
%          options.seed: integer or string, default="default"
%                        Seed of random number generator.
% See also dimer, mgs
if ~exist('options','var')
    options = []; 
end
if ~isfield(options,'stepsize')
    stepsize = [1e-3 1e-3];  
else
    stepsize = options.stepsize;
end
if ~isfield(options,'l')
    l = 1e-6;  
else 
    l = options.l;
end
if ~isfield(options,'seed')
    seed = 'default';  
else
    seed = options.seed;
end
rng(seed);
n = length(x);
v = randn(n,k);
for i=1:k
    vi = v(:,i);
    v(:,i) = vi - stepsize(2)*dimer(grad, x, l, vi);
end
v = mgs(v);
end