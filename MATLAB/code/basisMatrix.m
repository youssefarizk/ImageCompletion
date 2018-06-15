function basisMat = basisMatrix(data,basis)

p = size(data,1);
ncpts = 11;
basisMat = zeros(p,ncpts);

for i=1:p
    for j=1:ncpts
%         cast(data(i,1),'int32')+1
        basisMat(i,j) = basis(cast(data(i,1),'int32')+1,j);
    end
end


end
