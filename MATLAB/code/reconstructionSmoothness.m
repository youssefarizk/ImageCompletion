clear;
close all;

%% Initializations

site = 'milan/';
img1 = 'img1';
img2 = 'img2';

% Loading Relevant Images
srcImg = imread(strcat('../exports/',site,img1,'/SourceImage0.bmp'));
exemplar1 = imread(strcat('../exports/',site,img1,'/TargetImage0.bmp'));
exemplar2 = imread(strcat('../exports/',site,img2,'/TargetImage0.bmp'));
completion = imread(strcat('../exports/',site,img2,'/CompletedImage1.bmp'));

% Setting ROI
iroi = [330 700 260 480]; %milan
x_l = 330; x_r = 700; y_u = 260; y_d = 480;
% iroi = [390 680 380 550]; %eiffel
% x_l = 390; x_r = 680; y_u = 380; y_d = 550;
% iroi = [440 650 230 410]; %sphinx
% x_l = 440; x_r = 650; y_u = 230; y_d = 410;
% iroi = [440 570 185 300]; %sphinx
% x_l = 440; x_r = 570; y_u = 185; y_d = 300;

height = y_d - y_u;
width = x_r - x_l;


% Interpolated Nearest Neighbour Fields;

ANN1 = csvread(strcat('../exports/',site,img1,'/annCplt4.csv'));

ANN1_x = ANN1(:,1:4:end);
ANN1_y = ANN1(:,2:4:end);
ANN1_s = round(ANN1(:,3:4:end));
ANN1_r = ANN1(:,4:4:end);

ANN2 = csvread(strcat('../exports/',site,img2,'/annCplt4.csv'));

ANN2_x = ANN2(:,1:4:end);
ANN2_y = ANN2(:,2:4:end);
ANN2_s = round(ANN2(:,3:4:end));
ANN2_r = ANN2(:,4:4:end);

ANN12 = csvread(strcat('../exports/',site,img1,'_',img2,'/ann4.csv'));

ANN12_x = ANN12(:,1:4:end);
ANN12_y = ANN12(:,2:4:end);
ANN12_s = round(ANN12(:,3:4:end));
ANN12_r = ANN12(:,4:4:end);

%% Visualization

numAngles = 90;
numScales = 256;
startScale = 0.33; endScale = 3.00;

a = log(startScale); b = log(endScale);

scaleTbl = exp(a + (b-a)*1.0*[0:numScales-1]/numScales);

[img_y, img_x] = size(ANN1_x);

tmp_x = ANN1_x/img_x * 256; %R
tmp_y = ANN1_y/img_y * 256; %G
tmp_s = zeros(img_y, img_x); %B
for i = 1:img_y
    tmp_s(i,:) = scaleTbl(ANN1_s(i,:)+1)/endScale * 256;
end

imRange = [1 256];

rgbImage = cat(3,tmp_x,tmp_y,tmp_s);
rgbImage = double(rgbImage)/256;

imshow(rgbImage)

figure;

tmp_x = ANN2_x/img_x * 256; %R
tmp_y = ANN2_y/img_y * 256; %G
tmp_s = zeros(img_y, img_x); %B
for i = 1:img_y
    tmp_s(i,:) = scaleTbl(ANN2_s(i,:)+1)/endScale * 256;
end

imRange = [1 256];

rgbImage = cat(3,tmp_x,tmp_y,tmp_s);
rgbImage = double(rgbImage)/256;

imshow(rgbImage)

%% New ANN based on nearest neighbours of img1 in img2

% experiment (delete after)

for x = 1:img_x
    for y = 1:img_y
        x_ = round(ANN2_x(y,x))+1;
        y_ = round(ANN2_y(y,x))+1;
        exemplar2(y_,x_,:) = zeros(1,1,3);
    end
end

% for x = 1:size(exemplar1,2)
%     for y = 1:size(exemplar1,1)
%         x_ = round(ANN12_x(y,x))+1;
%         y_ = round(ANN12_y(y,x))+1;
%         exemplar2(y_,x_,:) = [255 255 0];
%     end
% end

figure; imshow(exemplar2);

% reverse relation ship (x_,y_) -> (x,y)
inROI = ones(size(exemplar2,1),size(exemplar2,2),2);

for x = 1:img_x
    for y = 1:img_y
        x_ = round(ANN2_x(y,x))+1;
        y_ = round(ANN2_y(y,x))+1;
        inROI(y_,x_,1) = y; inROI(y_,x_,2) = x;
    end
end

ANN_new = zeros(height, width, 4);

for x = x_l:x_r-1
    for y=y_u:y_d-1
        
        x_ = round(ANN1_x(y,x))+1;
        y_ = round(ANN1_y(y,x))+1;
        x_new = round(ANN12_x(y_,x_))+1; 
        y_new = round(ANN12_y(y_,x_))+1;
        
        x_ = inROI(y_new,x_new,2);
        y_ = inROI(y_new,x_new,1);
        
        ANN_new(y,x,1) = ANN2_x(y_,x_);
        ANN_new(y,x,2) = ANN2_y(y_,x_);
        ANN_new(y,x,3) = ANN2_s(y_,x_);
        ANN_new(y,x,4) = ANN2_r(y_,x_);
         
    end
end

ANN_new_x = ANN_new(:,:,1);
ANN_new_y = ANN_new(:,:,2);
ANN_new_s = ANN_new(:,:,3);
ANN_new_r = ANN_new(:,:,4);

figure;

tmp_x = ANN_new_x/img_x * 256; %R
tmp_y = ANN_new_y/img_y * 256; %G
tmp_s = zeros(img_y, img_x); %B
for i = 1:img_y
    tmp_s(i,:) = scaleTbl(ANN_new_s(i,:)+1)/endScale * 256;
end

imRange = [1 256];

rgbImage1 = cat(3,tmp_x,tmp_y,tmp_s);
rgbImage1 = double(rgbImage1)/256;
imshow(rgbImage1)
