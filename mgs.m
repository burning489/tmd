function q = mgs(v)
% MGS Modified Gram Schmidt Process.
x = v;
q = v;
for i = 1:size(q,2)
    q(:,i) = x(:,i)/norm(x(:,i));
    for j = i+1:size(q,2)
        x(:,j) = x(:,j) - dot(q(:,i), x(:,j))*q(:,i);
    end
end
end