function [v, eig_vals] = gen_v(grad, x, k, options)
% GEN_V Generate an orthonormal basis of the k-dimension unstable subspace of x, i.e. x is a local maximum on v, or v is span of the smallest k eigenvectors of hess(x).
% Parameters
% ==============================
% grad: function handle
%       derivative of function.
% x: (n,1) double
% k: integer
%    Dimension of the unstable subspace, or the number of the smallest eigenparis to compute.
% options: struct
%          options.stepsize: 1*2 double, default = [1e-3 1e-3]
%                            stepsize in iterations of x and v respectively.
%          options.l: double, default=1e-6
%                     dimer length.
%          options.seed: integer, default=0
%                        seed of random number generator.
%          options.subspace_scheme: string, default="LOBPCG"
%                                   Subspace v update scheme.
%                                   "power" Power method of I - beta*Hess with beta = options.stepsize(2)
%                                   "LOBPSD" LOBPSD
%                                   "LOBPCG" LOBPCG
%                                   "rayleigh" Simultaneous Rayleigh-quotient minimization
%          options.mgs_eps: double, default=1e-1
%                           epsilon used in lobpsd and lobpcg.
%          options.max_gen_iter: integer, default=1e2
%                                max iterations allowd.
%          options.r_tol: double, default=1e-3
%                         tolerance for residuals.
%          options.orth_scheme: string, default="mgs"
%                               Orthonormalization scheme after each iteration.
%                               "mgs" modified gram schmidt
%                               "qr" qr decomposition
%          options.step_scheme: string, default="euler"
%                               Stepsize scheme in iterations of x and v.
%                               "euler": Euler scheme with options.stepsize.
%                               other schemes: TODO
% Returns
% ==============================
% v: (n,k) double
%    Unstable subspace.
% eig_vals: (k,1) double, returns if subspace_scheme="LOBPSD"/"LOBPCG"
%           Eigenvalues corresponding to v.
% see also dimer, mgs1, mgs2

%% prepare parameters
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
    seed = 0;
else
    seed = options.seed;
end
if ~isfield(options,'subspace_scheme')
    subspace_scheme = "LOBPCG";
else
    subspace_scheme = options.subspace_scheme;
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
if ~isfield(options,'step_scheme')
    step_scheme = "euler";
else
    step_scheme = options.step_scheme;
end

% preprations
rng(seed);
n = length(x);
v = randn(n,k);
vm1 = []; % for LOBPCG and simultaneous Rayleigh iteration
eig_vals = [];

% iterations
for iter = 1:max_gen_iter
    switch subspace_scheme
    case "power"
        % v <- (I - beta*H)*v
        % vi <- vi - beta*H*vi
        for i=1:k
            vi = v(:,i);
            v(:,i) = vi - stepsize(2)*dimer(grad, x, l, vi);
        end
    case "LOBPSD"
        % res <- H*v - v*diag(v'*H*v)
        res = zeros(size(v));
        for i=1:k
             vi = v(:,i);
             ui = dimer(grad, x, l, vi);
             res(:,i) = ui - dot(vi, ui)*vi;
        end
        % u <- span(v, res)
        u_sd = [v, res];
        % orthogonalize w.r.t. v, and drop (relatively) small terms
        u_sd = mgs2(u_sd, k, mgs_eps);
        % Rayleigh-Ritz methods to calculate eigenpairs
        % evd on u'*H*u, and get Ritz pairs: eigenvalues directly and vecs as u*V
        % y <- H*u
        y_sd = zeros(size(u_sd));
        for i=1:size(u_sd, 2)
            y_sd(:,i) = dimer(grad, x, l, u_sd(:,i));
        end
        % p <- u'*y
        % p <- (p'+p)/2 for symmetry
        p_sd = u_sd'*y_sd;
        p_sd = (p_sd + p_sd')/2;
        [V, D] = eigs(p_sd , k, 'SM');
        v = u_sd*V;
    case "LOBPCG"
        % res <- H*v - v*diag(v'*H*v)
        res = zeros(size(v));
        for i=1:k
            vi = v(:,i);
            ui = dimer(grad, x, l, vi);
            res(:,i) = ui - dot(vi, ui)*vi;
        end
        % u <- span(v, vm1, res)
        u_cg = [v, vm1, res];
        % orthogonalize w.r.t. v, and drop (relatively) small terms
        u_cg = mgs2(u_cg, k, mgs_eps);
        % Rayleigh-Ritz methods to calculate eigenpairs
        % evd on u'*H*u, and get Ritz pairs: eigenvalues directly and vecs as u*V
        % y <- H*u
        y_cg = zeros(size(u_cg));
        for i=1:size(u_cg, 2)
            y_cg(:,i) = dimer(grad, x, l, u_cg(:,i));
        end
        % p <- u'*y
        % p <- (p'+p)/2 for symmetry
        p_cg = u_cg'*y_cg;
        p_cg = (p_cg + p_cg')/2;
        [V, D] = eigs(p_cg , k, 'SM');
        vm1 = v;
        v = u_cg*V;
    case "rayleigh" % simultaneously (not suggested, numerically stable)
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

    % orthonormalize
    if orth_scheme == "mgs"
        v = mgs1(v);
    elseif orth_scheme == "qr"
        [v, ~] = qr(v, 0);
    else
        errID = "GEN_V:UnknownOrthScheme";
        msgtext = "gen_v receive wrong orth_scheme";
        ME = MException(errID,msgtext);
        throw(ME);
    end

    % error
    hv = zeros(size(v));
    for i=i:k
        hv(:,i) = dimer(grad, x, l, v(:,i));
    end
    eigens = v'*hv;
    residuals = hv - v*eigens;
    norm_res = norm(residuals, 'fro');
    norm_hv = norm(hv, 'fro');
    if norm_res < r_tol*norm_hv
        return;
    end
end
if ~exist('D', 'var')
    eig_vals = diag(D); 
end
warning("GEN_V does not converge\n");
end
