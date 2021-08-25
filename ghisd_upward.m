function [solution, relation] =  ghisd_upward(grad, x0, v0, k, options)
% process params
if ~exist('options','var')
    options = [];
end
if ~isfield(options,'k_max')
    options.k_max = 1;
end
if ~isfield(options,'perturb_eps')
    options.perturb_eps = 1e-3;
end
stack(1,:) = {x0, k+1, v0};
relation = {};
solution(1,:) =x0;
while size(stack, 1) > 0
    [x0, m ,v0] = stack{end,:};
    stack(end,:) = [];
    if m < options.k_max
        stack(end+1,:) = {x0, m+1, v0};
    end
    try
        x1 = x0 + options.perturb_eps*v0(:,m);
        vm = v0(:,1:m);
        [xs, ~, ~, ~, n_iter] = hiosd(grad, x1, vm, m, options);
        x_new = xs(n_iter+1, :)';
        relation(end+1,:) = {x0, x_new};
        find_new = true;
        for j=1:size(solution,1)
            %  https://stackoverflow.com/questions/28975822/matlab-equivalent-for-numpy-allclose
            if all(abs(x_new-solution(j,:)) <= 1e-8 + 1e-5*abs(solution(j,:)))
                find_new = false;
                break;
            end
        end
        if find_new
            solution(end+1,:) = x_new;
            if m < options.k_max
                v_new = generate_v(grad, x_new, options.k_max, options);
                stack(end+1,:) = {x_new, m+1, v_new};
            end
        end
    catch ME
        if ME.identifier == "HiOSD:ExceedMaxIter"
            fprintf('Searching for %dth saddle fails!\n', m);
        else
            rethrow(ME);
        end
    end
end
end
