function test_ascent(func, x, v)
    for i=1:size(v,2)
        fprintf("#%d eigenvector:\n", i);
        vi = v(:,i);
        for l=logspace(-4,2,7)
            fprintf("%f\t", func(x+l*vi)-func(x));
        end
        fprintf("\n");
        for l=logspace(-4,2,7)
            fprintf("%f\t", func(x-l*vi)-func(x));
        end
        fprintf("\n");
    end
end