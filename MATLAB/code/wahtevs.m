co = csvread('../exports/recon5/img2/color4.csv');
iroi = [390 600 375 740]; 
x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);
co = reshapeColor(co,iroi);
imshow(uint8(co))