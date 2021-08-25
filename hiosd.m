function [xs, vn, f_norms, directions, n_iter] =  hiosd(grad, x0, v0, k, options)
% process params
if ~exist('options','var')
    options = [];
end
if ~isfield(options,'beta')
    options.beta = 1e-4;
end
if ~isfield(options,'gamma')
    options.gamma = 1e-4;
end
if ~isfield(options,'tau')
    options.tau = 0.5;
end
if ~isfield(options,'l')
    options.l = 1e-4;
end
if ~isfield(options,'max_iter')
    options.max_iter = 1e3;
end
if ~isfield(options,'tol')
    options.tol = 1e-3;
end
if ~isfield(options,'x_tol')
    options.x_tol = 1e-5;
end
if ~isfield(options,'step_eps')
    options.step_eps = 1e-7;
end
if ~isfield(options,'l_eps')
    options.l_eps = 1e-6;
end
if ~isfield(options,'scheme')
    %     scheme1 -- Euler scheme
    %     scheme2 -- BB method
    options.scheme = 1;
end
% check call back function
if ~isfield(options,'call_back')
    bcall_back = false;
else
    bcall_back = true;
end

% L2 norm of derivative at each iteration
f_norms = zeros(options.max_iter+1, 1);
% solution at each iteration
xs = zeros(options.max_iter+1, length(x0));
xs(1,:) = x0;
% descent directions
directions = zeros(options.max_iter, length(x0));

% first iteration
n_iter = 1;
xn = x0;
vn = v0;
fn = grad(xn);
f_norms(1) = norm(fn);

% translate
gn = -fn;
for i=1:k
    vni = vn(:,i);
    gn = gn + 2*dot(vni,fn)*vni;
end
directions(1,:) = gn;
xnp1 = xn + options.beta*gn;

% rotate
vnp1 = zeros(size(vn));
dn = zeros(size(vn));
for i=1:k
    vni = vn(:,i);
    uni = dimer(grad, xnp1, options.l, vni, options);
    dni = -uni + dot(vni,uni)*vni;
    for j=1:i-1
        vnj = vn(:,j);
        dni = dni + 2*dot(uni,vnj)*vnj;
    end
    vnp1(:,i) = vni + options.gamma*dni;
    vnp1 = mgs(vnp1);
    dn(:,i) = dni;
end

% shrink dimer
l = shrink(options.l, options.beta, options);

% update
xnm1 = xn;
xn = xnp1;
vnm1 = vn;
vn = vnp1;
dnm1 = dn;
gnm1 = gn;
fn = grad(xn);
f_norm = norm(fn);
f_norms(2) = f_norm;
xs(2,:) = xn;
stop_advance = false;

% iterations
while f_norm > options.tol && n_iter < options.max_iter
    n_iter = n_iter + 1;
    [xnp1, gn, beta] = translate(xn, xnm1, vn, fn, gnm1, options);
    directions(n_iter,:) = gn;
    [vnp1, dn] = rotate(grad, xnp1, vn, vnm1, dnm1, l, options);
    %     test_orth(vnp1);
    l = shrink(l, beta, options);
    fn = grad(xnp1);
    f_norm = norm(fn);
    f_norms(n_iter+1) = f_norm;
    xs(n_iter+1,:) = xnp1;
%     if energy(xnp1) - energy(xn) < 0
%         pause;
%     end
    xnm1 = xn;
    xn = xnp1;
    vnm1 = vn;
    vn = vnp1;
    dnm1 = dn;
    gnm1 = gn;
    if norm(xn-xnm1)/norm(xnm1) < options.x_tol
        stop_advance = true;
        break;
    end
end

if n_iter == options.max_iter
    if bcall_back
        options.call_back(xs, vn, f_norms, directions, n_iter);
    end
    %     disp('Exceed Max Iter!');
    errID = 'HiOSD:ExceedMaxIter';
    msgtext = 'HiOSD does not converge in max_iter iterations';
    ME = MException(errID,msgtext);
    throw(ME);
else
    if stop_advance
        fprintf('Stopped in advance!\n');
    end
    fprintf('Find an index-%d saddle point!\n', k);
    if bcall_back
        options.call_back(xs, vn, f_norms, directions, n_iter);
    end
end

end

function [xnp1, gn, beta] = translate(xn, xnm1, vn, fn, gnm1, options)
% Translation step in each iteration, moves x in direction gn.
% Step size is chosen by BB2 step.
gn = -fn;
k = size(vn, 2);
for i=1:k
    vni = vn(:,i);
    gn = gn + 2*dot(vni,fn)*vni;
end
if options.scheme == 1
    beta = options.beta;
elseif options.scheme == 2
    dx = xn-xnm1;
    dg = gn-gnm1;
    beta = min(abs(dot(dx, dg))/(abs(dot(dg, dg))+options.step_eps), options.tau/norm(gn));
end
xnp1 = xn + beta*gn;
end

function [vnp1, dn] = rotate(grad, xnp1, vn, vnm1, dnm1, l, options)
% Rotation step in each iteration, adjust Rayleigh vectors w.r.t. xnp1.
vnp1 = zeros(size(vn));
dn = zeros(size(vnm1));
k = size(vn, 2);
for i=1:k
    vni = vn(:,i);
    uni = dimer(grad, xnp1, l, vni, options);
    dni = -uni + dot(vni,uni)*vni;
    for j=1:i-1
        vnj = vn(:,j);
        dni = dni + 2*dot(vnj,uni)*vnj;
    end
    dn(:,i) = dni;
    if options.scheme == 1
        gamma = options.gamma;
    elseif options.scheme ==2
        dvi = vni - vnm1(:,i);
        dni = dni - dnm1(:,i);
        gamma = abs(dot(dvi,dni))/(abs(dot(dni,dni)) + options.step_eps);
    end
    vnp1(:,i) = vni + gamma*dni;
    vnp1 = mgs(vnp1);
end
end

function lnp1 = shrink(ln, betan, options)
% Shrink dimer.
lnp1 = max(ln/(1+betan), options.l_eps);
end

function test_orth(v)
fileID = fopen('./mgs.txt','a');
for i = 1:size(v,2)
    for j = i+1:size(v,2)
        fprintf(fileID, '%8.6f ', dot(v(:,i), v(:,j)));
    end
end
fprintf(fileID, '\n');
fclose(fileID);
end