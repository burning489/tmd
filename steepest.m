function [x, fval, exitflag, output] = steepest(func, x0, options, varargin)
if ~exist('options','var')
    options = [];
end
if ~isfield(options,'max_iter')
    options.max_iter = 1e4;
end
if ~isfield(options,'stepsize')
    options.stepsize = 1e-3;
end
if ~isfield(options,'x_tol')
    options.x_tol = 1e-6;
end
if ~isfield(options,'f_tol')
    options.f_tol = 1e-6;
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
grad = @derivative;
n_iter = 0;
xk = x0;
f0 = func(x0);
if ~isempty(options.plot_fcn)
    opt_values.n_iter = n_iter;
    options.plot_fcn(f0, opt_values);
end
while n_iter < options.max_iter
    gk = -grad(xk);
    if norm(gk, Inf) < options.g_tol
    	output.message = sprintf("Meet First-Order Optimality Tolerance.\n");
        break;
    end
    xkp1 = xk + options.stepsize*gk;
    xkm1 = xk;
    xk = xkp1;
    n_iter = n_iter + 1;
    if norm(xkm1-xk) < options.x_tol*(1+norm(xkm1))
    	output.message = sprintf("Meet Step Tolerance.\n");
        break;
    end
    fkm1 = func(xkm1);
    fk = func(xk);
    if abs(fkm1-fk) < options.f_tol*(1+fkm1)
    	output.message = sprintf("Meet Function Tolerance.\n");
        break;
    end
    if ~isempty(options.plot_fcn)
        opt_values.n_iter = n_iter;
        options.plot_fcn(fk, opt_values);
    end
end
x = xk;
fval = func(xk);
if n_iter == options.max_iter
    exitflag = 0;
    output.message = sprintf("Exceed Max Iterations.\n");
    fprintf(output.message);
else
    exitflag = 1;
end
output.iterations = n_iter;
end
