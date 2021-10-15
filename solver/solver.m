function [x, fval, exitflag, output] = solver(grad, x0, k, v0, options, varargin)
% SOLVER High-index optimization-based dimer method for finding high-index saddle points
% Input
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
%          options.max_iter: integer, default = 1e3
%                            Maximum number of iterations allowed, a positive integer.
%          options.stepsize: 1*2 double, default = [1e-3 1e-3]
%                            Stepsize in iterations of x and v respectively.
%          options.g_tol: double, default = 1e-3
%                         Termination tolerance on derivative, a positive scalar. Solver stops when it satisfies g_tol.
%          options.mgs_eps: double, default=1e-1
%                           Epsilon used in LOBPSD and LOBPCG.
%          options.l: double, default = 1e-9
%                     Dimer length. Should be shrunk but neglected here.
%          options.norm_scheme: string, default="Inf"
%                               Which norm to use.
%                               "Inf": infinity norm
%                               "1": 1-norm divided by n
%                               "2": 2-norm divided by sqrt(n)
%          options.step_scheme: string, default="euler"
%                               Stepsize scheme in iterations of x and v.
%                               "euler" Euler scheme with options.stepsize
%          options.orth_scheme: string, default="mgs"
%                               Orthogonalization scheme.
%                               "mgs" modified Gram Schmidt
%                               "qr" QR decomposition
%          options.subspace_scheme: string, default="LOBPCG"
%                                   Subspace v update scheme.
%                                   "power" Power method of I - beta*Hess with beta = options.stepsize(2)
%                                   "LOBPSD" LOBPSD
%                                   "LOBPCG" LOBPCG
%                                   "rayleigh" Simultaneous Rayleigh-quotient minimization
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
% Output
% ==============================
% x: (n,1) double
%    Solution. The size of x is the same as the size of x0. Typically, x is a local solution to the problem when exitflag is 1.
% fval: double
%       Objective function value at the solution, returned as a real number.
% exitflag: integer
%           Reason solver stopped, returned as an integer.
%           -1 Stopped by options.output_fcn.
%           0 Number of iterations exceeded options.max_iter.
%           1 The function converged to a solution x.
% output: struct
%         output.iterations: integer
%                            Number of iterations.
%         output.message: string
%                         Exit message.
%         output.v: (n,k) double
%                   Unstable subspace at x if algorithm converges.
% See also dimer, gen_v, mgs1, plot_fval, myoutput

%% prepare Input
if ~exist('options','var')
    options = [];
end
if nargin < 4
    errID = "SOLVER:NotEnoughInput";
    msgtext = "solver should at least receive grad, x0, k and v0";
    ME = MException(errID,msgtext);
    throw(ME);
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
if ~isfield(options,'norm_scheme')
    norm_scheme = "Inf";
else
    norm_scheme = options.norm_scheme;
end
if ~isfield(options,'step_scheme')
    step_scheme = "euler";
else
    step_scheme = options.step_scheme;
end
if ~isfield(options,'orth_scheme')
    orth_scheme = "mgs";
else
    orth_scheme = options.orth_scheme;
end
if ~isfield(options,'subspace_scheme')
    subspace_scheme = "LOBPCG";
else
    subspace_scheme = options.subspace_scheme;
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
if ~isfield(options,'display')
    display = "notify";
else
    display = options.display;
end

global energy_fcn
energy = energy_fcn;

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
    if mynorm(fn, norm_scheme) < g_tol
        output.message = sprintf("Meet First-Order Optimality Tolerance.\n");
        exitflag = 1;
        break;
    end
    
    % update x
    % gn = fn - 2*sum_{i=1}^{k}(<vni, fn>*vni), with vni = vn(:,i) and fn = -grad(xn).
    gnm1 = gn;
    gn = fn;
    for i = 1:k;
        vni = vn(:,i);
        gn = gn - 2*dot(vni,fn)*vni;
    end
    dg = gn - gnm1
    switch step_scheme
        case "euler"
            step_x = stepsize(1);
        case "bb"
            if n_iter == 1
                step_x = stepsize(1);
            else
                step_x = min(tau/mynorm(gn, norm_scheme), abs(dot(dx,dg)/dot(dg,dg)));
            end
        otherwise
            errID = "SOLVER:UnknownStepScheme";
            msgtext = "solver receive invalid step_scheme";
            ME = MException(errID,msgtext);
            throw(ME);
    end
    xnp1 = xn + step_x*gn;
    dx = xnp1 - xn;
    
    % update x
    vnp1 = gen_v(grad, xnp1, k, vn, vnm1, 'smallestreal', options);
    
    vnm1 = vn;
    vn = vnp1;
    xn = xnp1;
    fn = -grad(xn);
    en = energy(xn);
    
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
                output.message = "Solver stopped by output function.\n";
                fprintf(output.message);
            end
            break;
        end
    end
    if n_iter ~= 1
        fprintf(repmat('\b', 1, nbytes));
    end
    if display == "iter"
        if exist("k_", "var")
            nbytes = fprintf("#iter=%d\tfval=%e\tgnrm=%e\t#dim_u=%d\n", n_iter, en, mynorm(fn, norm_scheme), k_);
        else
            nbytes = fprintf("#iter=%d\tfval=%e\tgnrm=%e\n", n_iter, en, mynorm(fn, norm_scheme));
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
        fprintf("Solver does not converge. " + output.message);
    end
end
output.iterations = n_iter;
output.v = vn;

if display == "final"
    fprintf("#iter=%d\tfval=%e\t gnrm=%e\n", n_iter, fval, mynorm(grad(x), norm_scheme));
end

end