function recon = recon_final(iroi, srcImg,colorCorr)

recon = srcImg;

x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);
width = x_r - x_l;
height = y_d - y_u;

colorCorr1 = colorCorr(:,1); colorCorr1 = reshape(colorCorr1,[height, width]);
colorCorr2 = colorCorr(:,2); colorCorr2 = reshape(colorCorr2,[height, width]);
colorCorr3 = colorCorr(:,3); colorCorr3 = reshape(colorCorr3,[height, width]);
colorCorr = cat(3,colorCorr3,colorCorr2,colorCorr1);

recon(y_u:y_d-1,x_l:x_r-1,:) = colorCorr;

end