function nrm = mynorm(x, norm_scheme)
switch norm_scheme
    case "Inf"
        nrm = norm(x, "Inf");
    case "1"
        nrm = norm(x,1)/length(x);
    case "2"
        nrm = norm(x)/sqrt(length(x));
    otherwise
        errID = "MYNORM:UnknownOrthScheme";
        msgtext = "mynorm receive wrong norm_scheme";
        ME = MException(errID,msgtext);
        throw(ME);
end
end