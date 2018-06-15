function recon = recon_noColor(iroi, srcImg, tgtImg, ANN_x, ANN_y)

recon = srcImg;

x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);

for x=x_l:x_r
    for y=y_u:y_d
        
        x_ = round(ANN_x(y,x));
        y_ = round(ANN_y(y,x));
        
        recon(y,x,:) = tgtImg(y_,x_,:);
        
    end
end

end