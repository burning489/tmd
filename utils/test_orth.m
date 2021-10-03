function test_orth(v)
% TEST_ORTH Test orthogonality of vectors in v.
% v: (n,k) double
%    A basis of unstable subspace.
if size(v, 2) == 1
    return
end
global root_path runid
fileID = fopen(sprintf(root_path+"/results/run%03d/orth.txt", runid), "a");
for i = 1:size(v,2)
    for j = i+1:size(v,2)
        fprintf(fileID, '%8.6f ', dot(v(:,i), v(:,j)));
    end
end
fprintf(fileID, '\n');
fclose(fileID);
end