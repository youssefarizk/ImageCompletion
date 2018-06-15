function colorCorr = colorCorrection(site, img, iroi, colorCorr)

C1 = colorCorr(:,1);
C2 = colorCorr(:,2);
C3 = colorCorr(:,3);

B1 = csvread(strcat('../exports/',site,img,'/basis1.csv'));
B2 = csvread(strcat('../exports/',site,img,'/basis2.csv'));
B3 = csvread(strcat('../exports/',site,img,'/basis3.csv'));

W1 = csvread(strcat('../exports/',site,img,'/W1.csv'));
W2 = csvread(strcat('../exports/',site,img,'/W2.csv'));
W3 = csvread(strcat('../exports/',site,img,'/W3.csv'));

C1 = predict(C1, W3, B3);
C2 = predict(C2, W2, B2);
C3 = predict(C3, W1, B1);

colorCorr = cat(2,C3,C2,C1);
colorCorr = reshapeColor(colorCorr,iroi);

end