function v = generate_v(grad, x, k, options)
% generate_v generate an orthonormal basis of the k-dimension unstable subspace of x, i.e. x is a local maximum on v, or v is span of the smallest k eigenvectors of hess(x).
% parameters
% ==============================
% grad: function handle
%       derivative of function.
% x: (n,1) double
% k: integer
%    index of target saddle point.
% options: struct
%          options.stepsize: 1*2 double, default = [1e-3 1e-3]
%                            stepsize in iterations of x and v respectively.
%          options.l: double, default=1e-6
%                             dimer length.
%          options.seed: integer or string, default="default"
%                        seed of random number generator.
%          options.subspace_scheme: string, default="LOBPCG"
%                                   Subspace v update scheme.
%                                   "power" Power method of I - beta*Hess with beta = options.stepsize(2)
%                                   "LOBPSD" LOBPSD
%                                   "LOBPCG" LOBPCG
%                                   "rayleigh" Simultaneous Rayleigh-quotient minimization(TODO)
%          options.preconditioner(todo): (n, n) double, default=i
%                                  precondioner used in lobpcg and lobpsd.
%          options.mgs_eps: double, default=1e-1
%                           epsilon used in lobpsd and lobpcg.
%          options.max_gen_iter: integer, default=1e2
%                                max iterations allowd.
%          options.r_tol: double, default=1e-3
%                         tolerance for residuals.
%          options.orth_scheme: string, default="mgs"
%                               orthonormalization scheme.
%                               "mgs" modified gram schmidt
%                               "qr" qr
% see also dimer, mgs1
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
if ~isfield(options,'subspace_scheme')
    subspace_scheme = "LOBPCG";
else
    subspace_scheme = options.subspace_scheme;
end
if ~isfield(options,'preconditioner')
    preconditioner = eye(length(x0));
else
    preconditioner = options.preconditioner;
end
if ~isfield(options,'mgs_eps')
    mgs_eps = 1e-1;
else
    mgs_eps = options.mgs_eps;
end
if ~isfield(options, 'max_gen_iter')
    max_gen_iter = 1e2;
else
    max_gen_iter = options.max_gen_iter;
end
if ~isfield(options, 'r_tol')
    r_tol = 1e-3;
else
    r_tol = options.r_tol;
end
if ~isfield(options, 'orth_scheme')
    orth_scheme = "mgs";
else
    orth_scheme = options.orth_scheme;
end
rng(seed);
n = length(x);
v = randn(n,k);
vm1 = [];
for iter = 1:max_gen_iter
    switch subspace_scheme
    case "power"
        for i=1:k
            vi = v(:,i);
            v(:,i) = vi - stepsize(2)*dimer(grad, x, l, vi);
        end
    case "LOBPSD"
        res = zeros(size(v));
        for i=1:k
             vi = v(:,i);
             ui = dimer(grad, x, l, vi);
             res(:,i) = ui - dot(vi, ui)*vi;
        end
        u_sd = [v, res];
        u_sd = mgs2(u_sd, k, mgs_eps);
        y_sd = zeros(size(u_sd));
        for i=1:size(u_sd, 2)
            y_sd(:,i) = dimer(grad, x, l, u_sd(:,i));
        end
        p_sd = u_sd'*y_sd;
        p_sd = (p_sd + p_sd')/2;
        [V, ~] = eigs(p_sd , k, 'SM');
        v = u_sd*V;
    case "LOBPCG"
        res = zeros(size(v));
        for i=1:k
            vi = v(:,i);
            ui = dimer(grad, x, l, vi);
            res(:,i) = ui - dot(vi, ui)*vi;
        end
        u_cg = [v, vm1, res];
        u_cg = mgs2(u_cg, k, mgs_eps);
        y_cg = zeros(size(u_cg));
        for i=1:size(u_cg, 2)
            y_cg(:,i) = dimer(grad, x, l, u_cg(:,i));
        end
        p_cg = u_cg'*y_cg;
        p_cg = (p_cg + p_cg')/2;
        [V, ~] = eigs(p_cg , k, 'SM');
        vm1 = v;
        v = u_cg*V;
    case "rayleigh"
        vm1 = v;
        for i=1:k
            vi = vm1(:,i);
            ui = dimer(grad, x, l, vi);
            di = -ui + dot(vi, ui)*vi;
            for j=1:i-1
               di = di + 2*dot(vm1(:,j), ui)*vm1(:,j); 
            end
            if step_scheme == "euler"
                v(:,i) = vi + stepsize(2)*di;
            end
        end
    end
    if orth_scheme == "mgs"
        v = mgs1(v);
    elseif orth_scheme == "qr"
        [v, ~] = qr(v, 0);
    end
    av = zeros(size(v));
    for i=i:k
        av(:,i) = dimer(grad, x, l, v(:,i));
    end
    eigens = v'*av;
    residuals = av - v*eigens;
    norm_res = norm(residuals, 'fro');
    norm_av = norm(av, 'fro');
    if norm_res < r_tol*norm_av
        return;
    end
end
warning("GENERATE_V does not converge\n");
end
