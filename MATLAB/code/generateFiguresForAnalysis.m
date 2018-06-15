clear;
close all;

%% Initializations

site = 'milan/';
img1 = 'img1';
img2 = 'img3';

% Loading Relevant Images
srcImg = imread(strcat('../exports/',site,img1,'/SourceImage0.bmp'));
exemplar1 = imread(strcat('../exports/',site,img1,'/TargetImage0.bmp'));
exemplar2 = imread(strcat('../exports/',site,img2,'/TargetImage0.bmp'));

% Setting ROI
iroi = [330 700 260 480]; %milan
% iroi = [390 680 380 550]; %eifel
% iroi = [440 650 230 410]; % sphinx
x_l = 330; x_r = 700; y_u = 260; y_d = 480;
% % x_l = 390; x_r = 680; y_u = 380; y_d = 550;
% x_l = 440; x_r = 650; y_u = 230; y_d = 410;

% Color Correction Matrices
colorCorr1 = csvread(strcat('../exports/',site,img1,'/color4.csv'));
colorCorr1 = reshapeColor(colorCorr1, iroi);

colorCorr2 = csvread(strcat('../exports/',site,img2,'/color4.csv'));
colorCorr2 = reshapeColor(colorCorr2, iroi);

% Probability Matrices
P1 = csvread(strcat('../exports/',site,img1,'/prob4.csv'));
P1 = P1(1:end-1);
P1 = reshapeProb(P1,iroi);

P2 = csvread(strcat('../exports/',site,img2,'/prob4.csv'));
P2 = P2(1:end-1);
P2 = reshapeProb(P2,iroi);

recon1 = srcImg;
recon2 = srcImg;

% recon1
for x=x_l:x_r-1
    for y= y_u:y_d-1
        if P1(y-y_u+1,x-x_l+1) < 0.8
            recon1(y,x,:) = colorCorr1(y-y_u+1,x-x_l+1,:);
        end
    end
end

imshow(recon1)