% Self-implemented color correction (works)
clear; close all;
%import basis and weights
site = 'recon5/';
img = 'img2';

% iroi = [330 700 260 480];
% x_l = 330; x_r = 700; y_u = 260; y_d = 480;
% iroi = [390 680 380 550]; %eiffel
% x_l = 390; x_r = 680; y_u = 380; y_d = 550;
% iroi = [440 570 185 300]; %taj
% x_l = 440; x_r = 570; y_u = 185; y_d = 300;
iroi = [390 600 375 740]; %sphinx
x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);

height = y_d - y_u; width = x_r - x_l;

srcImg = imread(strcat('../exports/',site,img,'/SourceImage0.bmp'));
tgtImg = imread(strcat('../exports/',site,img,'/TargetImage0.bmp'));

%check target is correct
imshow(tgtImg);
figure;

ANN = csvread('../colorExperiment/annCplt4.csv');

ANN_x = ANN(:,1:4:end);
ANN_y = ANN(:,2:4:end);

colorCorr = zeros(height*width, 3);
temp = srcImg;
i = 1;
for x = x_l:x_r-1
    for y = y_u:y_d-1
        x_ = uint32(ANN_x(y,x))+1;
        y_ = uint32(ANN_y(y,x))+1;
        colorCorr(i,:) = double(tgtImg(y_,x_,:));
        i= i+1;
        temp(y,x,:) = tgtImg(y_,x_,:);
    end
end

imshow(temp);

% C1 = colorCorr(:,1);
% C2 = colorCorr(:,2);
% C3 = colorCorr(:,3);
% 
% C = uint8(colorCorr);%cat(2,C1,C2,C3);

C = temp(y_u:y_d-1,x_l:x_r-1,:);%this is ok
C1 = C(:,:,1); 
C1 = C1(:);
C2 = C(:,:,2); 
C2 = C2(:);
C3 = C(:,:,3); 
C3 = C3(:);
C = [C3 C2 C1];

C = reshapeColor(C,iroi);
recon1 = srcImg;
recon1(y_u:y_d-1,x_l:x_r-1,:) = C;
figure;

Cor = csvread('../colorExperiment/colorCorr.csv');
Cor = reshapeColor(Cor,iroi);
recon = srcImg;
recon(y_u:y_d-1,x_l:x_r-1,:) = Cor;
imshowpair(recon1, recon, 'montage')
title('comparing reconstructions from calculated and exported colorcorrections');
figure;

B1 = csvread('../colorExperiment/basis1.csv');
B2 = csvread('../colorExperiment/basis2.csv');
B3 = csvread('../colorExperiment/basis3.csv');

W1 = csvread('../colorExperiment/W1.csv');
W2 = csvread('../colorExperiment/W2.csv');
W3 = csvread('../colorExperiment/W3.csv');

C2 = predict(C2, W2, B2);
C3 = predict(C3, W1, B1);
C1 = predict(C1, W3, B3);

colorCorr = uint8(cat(2,C3,C2,C1));
tmp = srcImg;
tmp(y_u:y_d-1,x_l:x_r-1,:) = reshapeColor(colorCorr,iroi);
imshowpair(imread('../colorExperiment/CompletedImage1.bmp'),tmp, 'montage');
title('completed images');

actualColor = csvread('../colorExperiment/color4.csv');

