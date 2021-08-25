function [x, fval, exitflag, output] = model(grad, x0, options, varargin)
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

while n_iter < options.max_iter
    gn = fn;
    if norm(gn, Inf) < options.g_tol
        output.message = sprintf("Meet First-Order Optimality Tolerance.\n");
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
        break;
    end
    if en > 1e3
        output.message = sprintf("Function value exceeds 1e3.\n");
        break;
    end
    if abs(en-enm1) < options.f_tol*(1+enm1)
        output.message = sprintf("Meet Energy Function Tolerance.\n");
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

x = xn;
fval = options.energy(x);
if n_iter == options.max_iter
    exitflag = 0;
    output.message = sprintf("Exceed Max Iterations.\n");
    if options.display == "notify"
        fprintf("HiOSD does not converge. " + output.message);
    end
else
    exitflag = 1;
end
output.iterations = n_iter;
output.v = vn;

if options.display == "final"
    fprintf("#iter=%4d\t#f(x)=%12.8f\n", n_iter, fval);
end

end
