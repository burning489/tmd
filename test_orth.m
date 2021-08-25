function test_orth(v)
fileID = fopen('./mgs.txt','a');
for i = 1:size(v,2)
    for j = i+1:size(v,2)
        fprintf(fileID, '%8.6f ', dot(v(:,i), v(:,j)));
    end
end
fprintf(fileID, '\n');
fclose(fileID);
end