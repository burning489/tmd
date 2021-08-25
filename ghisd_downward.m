function [solution, relation] =  ghisd_downward(grad, x0, v0, k, options)
% process params
if ~exist('options','var')
    options = [];
end
if ~isfield(options,'k_min')
    options.k_min = 0;
end
if ~isfield(options,'perturb_eps')
    options.perturb_eps = 1e-3;
end
queue(1,:) = {x0, k-1, v0};
relation = {};
solution(1,:) =x0;
attempts = 0;
while size(queue, 1) > 0
    [x0, m ,v0] = queue{1,:};
    queue(1,:) = [];
    if m > options.k_min
        queue(end+1,:) = {x0, m-1, v0};
    end
    for i=1:size(v0,2)
        vm = v0(:,1:m+1);
        vm(:,min(i,m+1)) = [];
        x1 = x0 + options.perturb_eps*v0(:,i);
        try
            [xs, vn, ~, ~, n_iter] = hiosd(grad, x1, vm, m, options);
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
                if m > options.k_min
                    %                     use output
                    %                     queue(end+1,:) = {x_new, m-1, vn};
                    %                     generate new vn
                    %                     v_new = generate_v(grad, x_new, m, options);
                    queue(end+1,:) = {x_new, m-1, vn};
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
end
