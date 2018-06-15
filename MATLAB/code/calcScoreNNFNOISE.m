clear; close all;

numAngles = 90;
numScales = 256;
startScale = 0.33; endScale = 3.00;
x_l = 330; x_r = 700; y_u = 260; y_d = 480;
x_l = 390; x_r = 680; y_u = 380; y_d = 550;
x_l = 440; x_r = 650; y_u = 230; y_d = 410;
x_l = 440; x_r = 570; y_u = 185; y_d = 300;

files = ["img1","img2","img3","img4","img5"];

for img=files
    
    fileName = strcat('/Users/YoussefRizk/Desktop/OneDrive/PRINCE_v2.0/PRINCE/exports/taj_mahal/',img,'/ann4.csv');
    
    ANN = csvread(fileName);
    
    %separating into 4 degrees of freedom
    ANN_x = ANN(:,1:4:end);
    ANN_y = ANN(:,2:4:end);
    ANN_s = round(ANN(:,3:4:end)); %rounding the
    ANN_r = ANN(:,4:4:end);
    
    [img_y, img_x] = size(ANN_x);

    tmp_x = ANN_x(y_u:y_d,x_l:x_r);
    tmp_y = ANN_y(y_u:y_d,x_l:x_r);
    tmp_s = ANN_s(y_u:y_d,x_l:x_r);
    tmp_r = ANN_r(y_u:y_d,x_l:x_r);
    
    [x_,y_,s,r] = findClusters(tmp_x,tmp_y,tmp_s,tmp_r,1.2); % boundary point count
    
    fprintf('Average: %0.5f\n', (x_+y_+s+r)/4);
end

