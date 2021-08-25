function test_energy(x, v)
figure;
L = 0.5;
t = -L:1e-2:L;
if size(v,2) > 1
    [xx, yy] = meshgrid(t, t);
    Z = zeros(size(xx));
    for i=1:length(t)
        for j=1:length(t)
            Z(i,j) =  energy(x + xx(i,j)*v(:,1) + yy(i,j)*v(:,2));
        end
    end
    surf(xx, yy, Z);
else
    y = zeros(size(t));
    for i=1:length(t)
        y(i) = energy(x + t(i)*v);
    end
    plot(t,y);
end
end


