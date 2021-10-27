function print_norm(x)
    fprintf("1-norm:%f\n2-norm:%f\nInf-norm:%f\n", ...
    norm(x,1)/length(x), norm(x)/sqrt(length(x)), norm(x,Inf));
end
