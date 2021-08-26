function [x, fval, exitflag, output] = hiosd(grad, x0, options, varargin)
% HIOSD High-index optimization-based shrinking dimer method for finding high-index saddle points. 
% Parameters
% ==============================
% grad: function handle
%       Derivative of function.
% x0: (n,1) double
%     Initial point, specified as a column vector. Solvers use the number of elements in, and size of, x0 to determine the number and size of variables that grad accepts.
% options: struct
%          options.k: integer, necessary
%                     The index of the searching target saddle point.
%          options.v0: (n,k) double
%                      A basis for the unstable subspace at x0, generated by <a href="matlab:doc generate_v">generate_v</a>.
%          options.mat_iter: integer, default = 1e3
%                            Maximum number of iterations allowed, a positive integer.
%          options.stepsize: 1*2 double, default = [1e-3 1e-3]
%                            Stepsize in iterations of x and v respectively.
%          options.x_tol: double, default = 1e-4
%                         Termination tolerance on x, a positive scalar. Solver stops when it satisfies x_tol.
%          options.y_tol: double, default = 1e-4
%                         Termination tolerance on function values, a positive scalar. Solver stops when it satisfies y_tol.
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
%          options.scheme: integer, default=1
%                          Stepsize scheme in iterations of x and v.
%                          1 Euler scheme with options.stepsize.
%                          2 Line Search(TODO).
%          options.dimer: double, default = 1e-9
%                         Dimer length. Should be shrunk but neglected here.
%          options.energy: function handle, default = @energy
%                          Energy function.
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
% See Also 
% dimer, generate_v, mgs, plot_fval, myoutput

%% prepare parameters
if ~exist('options','var')
    options = [];
end
if ~isfield(options,'k')
    errID = "HiOSD:UnknownIndexK";
    msgtext = "HiOSD does not recieve appropriate searching index";
    ME = MException(errID,msgtext);
    x = [], fval=[], exitflag=[], output=[];
    throw(ME);
end
if ~isfield(options,'v0')
    options.v0 = generate_v(grad, x0, options.k, options);
end
if ~isfield(options,'max_iter')
    options.max_iter = 1e3;
end
if ~isfield(options,'stepsize')
    options.stepsize = [1e-3 1e-3];
end
if ~isfield(options,'x_tol')
    options.x_tol = 1e-4;
end
if ~isfield(options,'f_tol')
    options.f_tol = 1e-4;
end
if ~isfield(options,'g_tol')
    options.g_tol = 1e-6;
end
if ~isfield(options,'display')
    options.display = "notify";
end
if ~isfield(options,'plot_fcn')
    options.plot_fcn = [];
end
if ~isfield(options,'output_fcn')
    options.output_fcn = [];
end
if ~isfield(options,'scheme')
    options.scheme = 1;
end
if ~isfield(options,'dimer')
    options.dimer = 1e-9;
end
if ~isfield(options,'energy')
    if exist("energy", "file")
        options.energy = @energy;
    else
        errID = "HiOSD:UnknownEnergyFunction";
        msgtext = "HiOSD does not find energy function";
        ME = MException(errID,msgtext);
        x = [], fval=[], exitflag=[], output=[];
        throw(ME);
    end
end

%% initial point
n_iter = 0;
xn = x0;
fn = -grad(xn);
vn = options.v0;
% en = options.energy(xn);
e_bulk = bulk(xn);
e_inter = inter(xn);
global ratio
if ratio == 0
    e_elas = 0;
else
    e_elas = elas(xn);
end
en = e_bulk + e_inter + e_elas;
if ~isempty(options.plot_fcn)
    opt_values.n_iter = n_iter;
    opt_values.e_bulk = e_bulk;
    opt_values.e_inter = e_inter;
    opt_values.e_elas = e_elas;
    options.plot_fcn(en, opt_values);
end
exitflag = 1;

%% HiOSD searching
while n_iter < options.max_iter
    gn = fn;
    if norm(gn, Inf) < options.g_tol
        output.message = sprintf("Meet First-Order Optimality Tolerance.\n");
        exitflag = 1;
        break;
    end
    for i = 1:options.k
        vni = vn(:,i);
        gn = gn - 2*dot(vni,fn)*vni;
    end
    if options.scheme == 1
        xnp1 = xn + options.stepsize(1)*gn;
    end
    vnp1 = zeros(size(vn));
    for i=1:options.k
        vni = vn(:,i);
        uni = dimer(grad, xnp1, options.dimer, vni);
        dni = -uni;
        if options.scheme == 1
            vnp1(:,i) = vni + options.stepsize(2)*dni;
        end
    end
    vnp1 = mgs(vnp1);
    
    xnm1 = xn;
    xn = xnp1;
    vn = vnp1;
    test_orth(vn);
    n_iter = n_iter + 1;
    fn = -grad(xn);
    
    if norm(xn-xnm1) < options.x_tol*(1+norm(xnm1))
        output.message = sprintf("Meet Step Tolerance.\n");
        exitflag = 1;
        break;
    end
    enm1 = en;
    %     en = options.energy(xn);
    e_bulk = bulk(xn);
    e_inter = inter(xn);
    if ratio == 0
        e_elas = 0;
    else
        e_elas = elas(xn);
    end
    en = e_bulk + e_inter + e_elas;
    if en < enm1
        output.message = sprintf("Function value decreases.\n");
        exitflag = 0;
        break;
    end
    if en > 1e3
        output.message = sprintf("Function value exceeds 1e3.\n");
        exitflag = 0;
        break;
    end
    if abs(en-enm1) < options.f_tol*(1+enm1)
        output.message = sprintf("Meet Energy Function Tolerance.\n");
        exitflag = 1;
        break;
    end
    
    if ~isempty(options.plot_fcn)
        opt_values.n_iter = n_iter;
        opt_values.e_bulk = e_bulk;
        opt_values.e_inter = e_inter;
        opt_values.e_elas = e_elas;
        options.plot_fcn(en, opt_values);
    end
    if ~isempty(options.output_fcn)
        opt_values.n_iter = n_iter;
        opt_values.fval = en;
        if n_iter == 1
            state = "init";
        elseif n_iter < options.max_iter
            state = "iter";
        else
            state = "done";
        end
        stop = options.output_fcn(xn, opt_values, state);
        if stop
            exitflag = -1;
            break;
        end
    end
    if options.display == "iter"
        fprintf("#iter=%4d\t#f(x)=%12.8f\n", n_iter, en);
    end
end

%% postprocessing
x = xn;
fval = options.energy(x);
if n_iter == options.max_iter
    exitflag = 0;
    output.message = sprintf("Exceed Max Iterations.\n");
    if options.display == "notify"
        fprintf("HiOSD does not converge. " + output.message);
    end
end
output.iterations = n_iter;
output.v = vn;

if options.display == "final"
    fprintf("#iter=%4d\t#f(x)=%12.8f\n", n_iter, fval);
end

end
