function q = mgs2(v, k, eps)
% MGS2 Modified Gram Schmidt Process for LOBPSD and LOBPCG.
x = v;
q = v;
ind = 1:k;

% orthogonalize w.r.t vn
for i=1:k
    for j=k+1:size(x,2)
        x(:,j) = x(:,j) - dot(q(:,i),x(:,j))*q(:,i);
    end
end

% modified Gram-Schmidt with threshold
for i=k+1:size(x,2)
    if norm(x(:,i))/norm(v(:,i)) > eps
        ind(end+1) = i;
        q(:,i) = x(:,i)/norm(x(:,i));
        for j=i+1:size(x, 2)
            x(:,j) = x(:,j) - dot(q(:,i),x(:,j))*q(:,i);
        end
    end
end

q = q(:, ind);

end
