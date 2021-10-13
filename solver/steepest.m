function [x, fval, exitflag, output] = steepest(func, x0, options, varargin)
% STEEPEST Steepest descent, abandoned for now
if ~exist('options','var')
    options = [];
end
if ~isfield(options,'max_iter')
    max_iter = 1e4;
else
    max_iter = options.max_iter;
end
if ~isfield(options,'stepsize')
    stepsize = 1e-3;
else
    stepsize = options.stepsize;
end
if ~isfield(options,'x_tol')
    x_tol = 1e-6;
else
    x_tol = options.x_tol;
end
if ~isfield(options,'f_tol')
    f_tol = 1e-6;
else
    f_tol = options.f_tol;
end
if ~isfield(options,'g_tol')
    g_tol = 1e-6;
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
grad = @derivative;
n_iter = 0;
xk = x0;
f0 = func(x0);
if ~isempty(plot_fcn)
    opt_values.n_iter = n_iter;
    plot_fcn(f0, opt_values);
end
while n_iter < max_iter
    gk = -grad(xk);
    if norm(gk, Inf) < g_tol
    	output.message = sprintf("Meet First-Order Optimality Tolerance.\n");
        break;
    end
    xkp1 = xk + stepsize*gk;
    xkm1 = xk;
    xk = xkp1;
    n_iter = n_iter + 1;
    if norm(xkm1-xk) < x_tol*(1+norm(xkm1))
    	output.message = sprintf("Meet Step Tolerance.\n");
        break;
    end
    fkm1 = func(xkm1);
    fk = func(xk);
    if abs(fkm1-fk) < f_tol*(1+fkm1)
    	output.message = sprintf("Meet Function Tolerance.\n");
        break;
    end
    if ~isempty(plot_fcn)
        opt_values.n_iter = n_iter;
        plot_fcn(fk, opt_values);
    end
end
x = xk;
fval = func(xk);
if n_iter == max_iter
    exitflag = 0;
    output.message = sprintf("Exceed Max Iterations.\n");
    fprintf(output.message);
else
    exitflag = 1;
end
output.iterations = n_iter;
end
