function [v, eig_vals] = gen_v(grad, x, k, v, vm1, mode, options)
% GEN_V Generate an orthonormal basis of some k-dimension subspace of x
% v is span of the smallest or largest k eigenvectors of hessian at x.
% Input
% ==============================
% grad: function handle
%       Derivative of function.
% x: (n,1) double
%    Input data.
% k: integer
%    Dimension of the subspace, or the number of the smallest or largest eigenparis to compute.
% v: (n,k) double
%    Current approximation of eigenvectors.
% vm1: (n,k) double
%      Previous approximation of eigenvectors, for LOBPCG
% mode: string, default="smallest"
%       Which part of eigenpairs to compute, "smallestreal" or "largestreal";
% options: struct
%          options.stepsize: 1*2 double, default = [1e-3 1e-3]
%                            Stepsize in iterations of x and v respectively.
%          options.l: double, default=1e-6
%                     Dimer length.
%          options.seed: integer, default=0
%                        Seed of random number generator.
%          options.subspace_scheme: string, default="LOBPCG"
%                                   Subspace v update scheme.
%                                   "power" Power method of I -/+ beta*Hess with beta = options.stepsize(2)
%                                   "LOBPSD" LOBPSD
%                                   "LOBPCG" LOBPCG
%                                   "rayleigh" Simultaneous Rayleigh-quotient minimization or maximization
%          options.mgs_eps: double, default=1e-1
%                           Neglect threshold used in LOBPSD and LOBPCG.
%          options.max_gen_iter: integer, default=1e2
%                                Max iterations allowd.
%          options.r_tol: double, default=1e-3
%                         Tolerance for error of eigenvector approximation.
%          options.orth_scheme: string, default="mgs"
%                               Orthonormalization scheme after each iteration.
%                               "mgs" modified gram schmidt
%                               "qr" qr decomposition
% Output
% ==============================
% v: (n,k) double
%    Unstable subspace.
% eig_vals: (k,1) double, returns if subspace_scheme="LOBPSD"/"LOBPCG"
%           Rayleigh quotient corresponding to v.
% see also dimer, mgs1, mgs2

%% prepare Input
if ~exist('options','var')
    options = [];
end
if ~isfield(options, 'max_gen_iter')
    max_gen_iter = 1e2;
else
    max_gen_iter = options.max_gen_iter;
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
if ~isfield(options,'mgs_eps')
    mgs_eps = 1e-1;
else
    mgs_eps = options.mgs_eps;
end
if ~isfield(options, 'r_tol')
    r_tol = 1e-3;
else
    r_tol = options.r_tol;
end
if ~isfield(options,'seed')
    seed = 0;
else
    seed = options.seed;
end
if ~isfield(options, 'orth_scheme')
    orth_scheme = "mgs";
else
    orth_scheme = options.orth_scheme;
end
if ~isfield(options,'subspace_scheme')
    subspace_scheme = "LOBPCG";
else
    subspace_scheme = options.subspace_scheme;
end

% preprations
n = length(x);
if isempty(v)
    rng(seed);
    v = randn(n,k);
    v = myorth(v, orth_scheme);
end

% iterations
for iter = 1:max_gen_iter
    if iter == 1
        hv = zeros(size(v));
        for i=1:k
            hv(:,i) = dimer(grad, x, l, v(:,i));
        end
    end
    switch subspace_scheme
        case "power"
            if mode == "largestreal"
                sgn = 1;
            elseif mode == "smallestreal"
                sgn = -1;
            end
            % v <- (I - beta*H)*v for smallestreal case
            % vi <- vi - beta*H*vi
            for i=1:k
                vi = v(:,i);
                v(:,i) = vi + sgn*stepsize(2)*hv(:,i);
            end
            % Rayleigh Ritz method
            p = v'*hv;
            p = (p+p')/2;
            [V, D] = eigs(p, k, mode);
            v = v*V;
        case "rayleigh" % simultaneously rayleigh quotient
            if mode == "largestreal"
                sgn = 1;
            elseif mode == "smallestreal"
                sgn = -1;
            end
            vm1 = v;
            for i=1:k
                vi = vm1(:,i);
                di = -hv(:,i) + dot(vi, hv(:,i))*vi;
                for j=1:i-1
                    di = di + 2*dot(vm1(:,j), hv(:,i))*vm1(:,j);
                end
                v(:,i) = vi - sgn*stepsize(2)*di;
            end
            % Rayleigh Ritz method
            p = v'*hv;
            p = (p+p')/2;
            [V, D] = eigs(p, k, mode);
            v = v*V; 
        case "LOBPSD"
            % res <- H*v - v*diag(v'*H*v)
            res = zeros(size(v));
            for i=1:k
                vi = v(:,i);
                res(:,i) = hv(:,i) - dot(vi, hv(:,i))*vi;
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
            [V, D] = eigs(p_sd , k, mode);
            v = u_sd*V;
        case "LOBPCG"
            % res <- H*v - v*diag(v'*H*v)
            res = zeros(size(v));
            for i=1:k
                vi = v(:,i);
                res(:,i) = hv(:,i) - dot(vi, hv(:,i))*vi;
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
            [V, D] = eigs(p_cg , k, mode);
            vm1 = v;
            v = u_cg*V;
        otherwise
            errID = "GEN_V:UnknownSubspaceScheme";
            msgtext = "gen_v receive invalid subspace_scheme";
            ME = MException(errID,msgtext);
            throw(ME);
    end
    
    % orthonormalize
    v = myorth(v, orth_scheme);
    
    % error
    hv = zeros(size(v));
    for i=1:k
        hv(:,i) = dimer(grad, x, l, v(:,i));
    end
   
    if exist('nbytes', 'var')
        fprintf(repmat('\b', 1, nbytes));
    end
    
    residuals = hv - v*D;
    norm_res = norm(residuals, 'fro');
    norm_hv = norm(hv, 'fro');
    nbytes = fprintf(['#v_iter=%d\n', 'eig_val:', repmat('%f  ', 1, k), '\n', 'relative_err=%f\n'], iter, diag(D), norm_res/norm_hv);
    if norm_res < r_tol*norm_hv
        fprintf(repmat('\b', 1, nbytes));
        eig_vals = diag(D);
        return;
    end
end

fprintf(repmat('\b', 1, nbytes));
eig_vals = diag(D);

end