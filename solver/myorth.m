function v = myorth(v, orth_scheme)
    switch orth_scheme
    case "mgs"
        v = mgs1(v);
    case "qr"
        [v, ~] = qr(v, 0);
    otherwise
        errID = "MYORTH:UnknownOrthScheme";
        msgtext = "myorth receive wrong orth_scheme";
        ME = MException(errID,msgtext);
        throw(ME);
    end
end