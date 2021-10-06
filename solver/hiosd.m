function [x, fval, exitflag, output] = hiosd(grad, x0, k, v0, options, varargin)
% HIOSD High-index optimization-based shrinking dimer method for finding high-index saddle points. 
% Parameters
% ==============================
% grad: function handle
%       Derivative of function.
% x0: (n,1) double
%     Initial point, specified as a column vector. Solvers use the number of elements in, and size of, x0 to determine the number and size of variables that grad accepts.
% k: integer, necessary
%    The index of the searching target saddle point.
% v0: (n,k) double
%     A basis for the unstable subspace at x0, generated by <a href="matlab:doc gen_v">gen_v</a>.
% options: struct
%          options.mat_iter: integer, default = 1e3
%                            Maximum number of iterations allowed, a positive integer.
%          options.stepsize: 1*2 double, default = [1e-3 1e-3]
%                            Stepsize in iterations of x and v respectively.
%          options.g_tol: double, default = 1e-6
%                         Termination tolerance on derivative, a positive scalar. Solver stops when it satisfies g_tol.
%          options.display: string, default = "notify"
%                           Stategy of information display.
%                           "notify" displays output only if the function does not converge.
%                           "final" displays just the final output.
%                           "off" or "none" displays no output.
%                           "iter" displays output at each iteration.
%          options.plot_fcn: function handle, default=[]
%                            Plot of progress while the algorithm executes. Pass a user defined function handle.
%          options.output_fcn: function handle, default=[]
%                              Specify one or more user-defined functions that an optimization function calls at each iteration. Pass a user defined function handle.
%                              Return true or false to determine whether to stop the progress.
%          options.step_scheme: string, default="euler"
%                               Stepsize scheme in iterations of x and v.
%                               "euler" Euler scheme with options.stepsize
%                               other schemes: TODO 
%          options.subspace_scheme: string, default="LOBPCG"
%                                   Subspace v update scheme.
%                                   "power" Power method of I - beta*Hess with beta = options.stepsize(2)
%                                   "LOBPSD" LOBPSD
%                                   "LOBPCG" LOBPCG
%                                   "rayleigh" Simultaneous Rayleigh-quotient minimization
%          options.mgs_eps: double, default=1e-1
%                           Epsilon used in LOBPSD and LOBPCG.
%          options.l: double, default = 1e-9
%                     Dimer length. Should be shrunk but neglected here.
%          options.energy: function handle, default = @energy
%                          Energy function.
%          options.orth_scheme: string, default="mgs"
%                               Orthonormalization scheme.
%                               "mgs" modified gram schmidt
%                               "qr" qr
% Returns
% ==============================
% x: (n,1) double
%    Solution. The size of x is the same as the size of x0. Typically, x is a local solution to the problem when exitflag is 1.
% fval: double
%       Objective function value at the solution, returned as a real number.
% exitflag: integer
%           Reason HIOSD stopped, returned as an integer.
%           -1 Stopped by options.output_fcn.
%           0 Number of iterations exceeded options.max_iter.
%           1 The function converged to a solution x.
% output: struct
%         output.iterations: integer
%                            Number of iterations.
%         output.message: string
%                         Exit message.
%         output.v: (n,k) double
%                   Unstable space of x if algorithm converges.
% See also dimer, gen_v, mgs1, plot_fval, myoutput

%% prepare parameters
if ~exist('options','var')
    options = [];
end
if nargin < 3
    k = 1; 
end
if nargin < 4
    v0 = gen_v(grad, x0, k, options);
end
if ~isfield(options,'max_iter')
    max_iter = 1e3;
else
    max_iter = options.max_iter;
end
if ~isfield(options,'stepsize')
    stepsize = [1e-3 1e-3];
else
    stepsize = options.stepsize;
end
if ~isfield(options,'g_tol')
    g_tol = 1e-3;
else
    g_tol = options.g_tol;
end
if ~isfield(options,'display')
    display = "notify";
else
    display = options.display;
end
if ~isfield(options,'plot_fcn')
    plot_fcn = [];
else
    plot_fcn = options.plot_fcn;
end
if ~isfield(options,'output_fcn')
    output_fcn = [];
else
    output_fcn = options.output_fcn;
end
if ~isfield(options,'step_scheme')
    step_scheme = "euler";
else
    step_scheme = options.step_scheme;
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
if ~isfield(options,'l')
    l = 1e-6;
else
    l = options.l;
end
if ~isfield(options,'energy')
    errID = "HiOSD:UnknownEnergyFunction";
    msgtext = "HiOSD does not find energy function";
    ME = MException(errID,msgtext);
%     x = [], fval=[], exitflag=[], output=[];
    throw(ME);
else
    energy = options.energy;
end

%% initial point
n_iter = 0;
xn = x0;
fn = -grad(xn);
vn = v0;
vnm1 = []; % for LOBPCG
en = energy(xn);
exitflag = 1;
if ~isempty(plot_fcn)
    opt_values.n_iter = n_iter;
    opt_values.fval = en;
    plot_fcn(en, opt_values);
end

%% searching
for n_iter = 1:max_iter
    % check if first order converged
    if mynorm(fn) < g_tol
        output.message = sprintf("Meet First-Order Optimality Tolerance.\n");
        exitflag = 1;
        break;
    end

    % update x
    % gn = fn - 2*sum_{i=1}^{k} <vni, fn>*vni, with vni = vn(:,i), with fn = -grad(xn).
    gn = fn;
    for i = 1:k
        vni = vn(:,i);
        gn = gn - 2*dot(vni,fn)*vni;
    end
    if step_scheme == "euler"
        xnp1 = xn + stepsize(1)*gn;
    end

    % update v
    vnp1 = zeros(size(vn));
    switch subspace_scheme
        case "power" % power method on I - beta*Hess
            for i=1:k
                vni = vn(:,i);
                % uni = (grad(xnp1+l*vni) - grad(xnp1-l*vni)) / (2*l), i.e. approximate Hess*vni
                uni = dimer(grad, xnp1, l, vni);
                if step_scheme == "euler"
                    vnp1(:,i) = vni - stepsize(2)*uni;
                end
            end
        case "LOBPSD" % LOBPSD
            % construct unstable subspace span(vn, T*(Hess*vni - <vni, Hess*vni>*vni)) for i = 1 to k
            res = zeros(size(vn));
            for i=1:k
                vni = vn(:,i);
                uni = dimer(grad, xnp1, l, vni);
                res(:,i) = uni - dot(vni, uni)*vni;
            end
            u_sd = [vn, res];
            u_sd = mgs2(u_sd, k, mgs_eps);
            % test_orth(u_sd);
            y_sd = zeros(size(u_sd));
            k_ = size(u_sd, 2);
            for i=1:k_
                y_sd(:,i) = dimer(grad, xnp1, l, u_sd(:,i));
            end
            p_sd = u_sd'*y_sd;
            p_sd = (p_sd + p_sd')/2;
            [V, ~] = eigs(p_sd , k, 'smallestreal');
            vnp1 = u_sd*V;
        case "LOBPCG" % LOBPCG
            % construct unstable subspace span(vn, vnm1, T*(Hess*vni - <vni, Hess*vni>*vni)) for i = 1 to k
            res = zeros(size(vn));
            for i=1:k
                vni = vn(:,i);
                uni = dimer(grad, xnp1, l, vni);
                res(:,i) = uni - dot(vni, uni)*vni;
            end
            u_cg = [vn, vnm1, res];
            u_cg = mgs2(u_cg, k, mgs_eps);
            test_orth(u_cg);
            y_cg = zeros(size(u_cg));
            k_ = size(u_cg, 2);
            for i=1:k_
                y_cg(:,i) = dimer(grad, xnp1, l, u_cg(:,i));
            end
            p_cg = u_cg'*y_cg;
            p_cg = (p_cg + p_cg')/2;
            [V, ~] = eigs(p_cg , k, 'smallestreal');
            vnm1 = vn;
            vnp1 = u_cg*V;
        case "rayleigh" % simultaneous Rayleigh-quotient minimization
            for i=1:k
                vni = vn(:,i);
                uni = dimer(grad, xnp1, l, vni);
                dni = -uni + dot(vni, uni)*vni;
                for j=1:i-1
                    dni = dni + 2*dot(vn(:,j), uni)*vn(:,j);
                end
                if step_scheme == "euler"
                    vnp1(:,i) = vni + stepsize(2)*dni;
                end
            end
        otherwise
            errID = "HiOSD:UnknownSubspaceScheme";
            msgtext = "Invalid subspace_scheme";
            ME = MException(errID,msgtext);
            throw(ME);
    end

    % orthnormalize
    if orth_scheme == "mgs"
        vnp1 = mgs1(vnp1);
    elseif orth_scheme == "qr"
        [vnp1, ~] = qr(vnp1, 0);
    else
        errID = "GEN_V:UnknownOrthScheme";
        msgtext = "gen_v receive wrong orth_scheme";
        ME = MException(errID,msgtext);
        throw(ME);
    end

    xn = xnp1;
    vn = vnp1;
    fn = -grad(xn);
    en = energy(xn);

    % check if energy exceeds upper bound
    if en > 1e4
        output.message = sprintf("Function value exceeds 1e4.\n");
        exitflag = 0;
        if display == "notify"
            fprintf("HiOSD does not converge. " + output.message);
        end
        break;
    end

    % plot energy functions 
    if ~isempty(plot_fcn)
        opt_values.n_iter = n_iter;
        opt_values.fval = en;
        plot_fcn(en, opt_values);
    end
    
    % user defined output function 
    if ~isempty(output_fcn)
        opt_values.n_iter = n_iter;
        opt_values.fval = en;
        opt_values.x = xn;
        opt_values.v = vn;
        if n_iter == 1
            state = "init";
        elseif n_iter < max_iter
            state = "iter";
        else
            state = "done";
        end
        stop = output_fcn(xn, opt_values, state);
        if stop
            exitflag = -1;
            if display == "notify"
                output.message = "HiOSD stopped by output function.\n";
                fprintf(output.message);
            end
            break;
        end
    end
    if display == "iter"
        if exist("k_", "var")
            fprintf("#iter=%d\tfunc_value=%e\t der_norm=%e\t #dim_v=%d\n", n_iter, en, mynorm(fn), k_);
        else
            fprintf("#iter=%d\tfunc_value=%e\t der_norm=%e\n", n_iter, en, mynorm(fn));
        end
    end
end

%% postprocessing
x = xn;
fval = energy(x);
if n_iter == max_iter
    exitflag = 0;
    output.message = sprintf("Reach Max Iterations.\n");
    if display == "notify"
        fprintf("HiOSD does not converge. " + output.message);
    end
end
output.iterations = n_iter;
output.v = vn;

if display == "final"
    fprintf("#iter=%d\tfunc_value=%e\t der_norm=%e\n", n_iter, fval, mynorm(grad(x)));
end

end