for c = 2
    b = (-3-c)/2;
    t = -1.5:0.01:1.5;
    f = @(x) x.^6 + b*x.^4 + c*x.^2;
    plot(t,f(t));
    hold on
end