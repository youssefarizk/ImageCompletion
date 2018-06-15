% works well as a post-processing quality metric as the better the
% reconstruction, the smaller the homography distortion or error

clear;
close all;

src = imread('../assets/img1/SourceImage0.bmp');

imgA = csvread('../assets/img1/color4.csv');
imgB = csvread('../assets/img2/color4.csv');

iroi = [330 700 260 480];
x_l = 330; x_r = 700; y_u = 260; y_d = 480;

cntrl = src(y_u:y_d-1,x_l:x_r-1,:);

imgA = reshapeColor(imgA,iroi);
imgB = reshapeColor(imgB,iroi);

[i wim] = homography(imgB,cntrl);

src(y_u:y_d-1,x_l:x_r-1,:) = wim;

imshow(src);