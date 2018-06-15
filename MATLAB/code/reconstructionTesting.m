clear;
close all;

addpath('../assets/');

%% Initializations
site = 'milan/';
img = 'img5';
showFigure = true;
showFigureLast = true;
srcImg = imread(strcat('../exports/',site,img,'/SourceImage0.bmp'));
tgtImg = imread(strcat('../exports/',site,img,'/TargetImage0.bmp'));

iroi = [330 700 260 480];
x_l = 330; x_r = 700; y_u = 260; y_d = 480;
% iroi = [440 650 230 410]; % sphinx
% x_l = 440; x_r = 650; y_u = 230; y_d = 410;
% iroi = [440 570 185 300]; %taj
% x_l = 440; x_r = 570; y_u = 185; y_d = 300;
% iroi = [390 680 380 550]; %eiffel
% x_l = 390; x_r = 680; y_u = 380; y_d = 550;

%% Un-color Corrected, Uninterpolated Reconstruction

ANN = csvread(strcat('../exports/',site,img,'/ann4.csv'));

%separating into 4 degrees of freedom
ANN_x = ANN(:,1:4:end);
ANN_y = ANN(:,2:4:end);
ANN_s = round(ANN(:,3:4:end)); %rounding the
ANN_r = ANN(:,4:4:end);

recon = recon_noColor(iroi, srcImg, tgtImg, ANN_x, ANN_y);
if showFigure
    figure;
    imshow(recon);
end

%% Interpolated, non-color corrected Reconstruction

ANN = csvread(strcat('../exports/',site,img,'/annCplt4.csv'));

%separating into 4 degrees of freedom
ANN_x = ANN(:,1:4:end);
ANN_y = ANN(:,2:4:end);
ANN_s = round(ANN(:,3:4:end)); %rounding the
ANN_r = ANN(:,4:4:end);

recon = recon_intrpl(iroi, srcImg, tgtImg, ANN_x, ANN_y);
if showFigure
    figure;
    imshow(recon);
end

%% Interpolated, color corrected Reconstruction

colorCorr = csvread(strcat('../exports/',site,img,'/color4.csv'));
prob = csvread(strcat('../exports/',site,img,'/pMat4.csv'));

% recon = recon_final(iroi, srcImg, colorCorr);
% if showFigure
%     figure;
%     imshow(recon);
% end

colorCorr = reshapeColor(colorCorr,iroi);

recon = srcImg;

for x=x_l:x_r-1
    for y=y_u:y_d-1
        if prob(y,x) < 0.8*255
            recon(y,x,:) = colorCorr(y-y_u+1,x-x_l+1,:);
        end
    end
end


if showFigureLast
    figure;
    A = imread(strcat('../exports/',site,img,'/CompletedImage1.bmp'));
    imshowpair(recon,A,'diff');
end

%% Probablility Matrix
%
% P = csvread(strcat('../assets/',img,'/prob4.csv')); P = P(1:end-1);
% normalP = csvread(strcat('../assets/',img,'/normal_prob4.csv')); normalP = normalP(1:end-1);
%
% width = x_r - x_l;
% height = y_d - y_u;
%
% P = reshape(P,[height, width]);
% normalP = reshape(normalP,[height, width]);