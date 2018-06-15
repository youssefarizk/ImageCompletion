function rslt = predict(data,W,basis)

basisMat = basisMatrix(data,basis);
rslt = basisMat*W;

end