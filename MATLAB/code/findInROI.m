function [found y_ x_] = findInROI(x,y,ANN,iroi)
%ANN is 3D array containing ANNx and ANNy
x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);

% concentratedANN = ANN(y_u:y_d-1,x_l:x_r-1,:);

for x=x_l:x_r-1
    for y=y_u:y_d-1
        B = ANN(y,x,:);
        if B()
    end
end

end