close all;
clear;

actualColor = csvread('../assets/colorExperiment/color65.csv');
tgt = imread('../assets/colorExperiment/TargetImage0.bmp');
ANN = csvread('../assets/colorExperiment/annCplt4.csv');

iroi = [330 700 260 480];
x_l = 330; x_r = 700; y_u = 260; y_d = 480;

%separating into 4 degrees of freedom
ANN_x = ANN(:,1:4:end);
ANN_y = ANN(:,2:4:end);
ANN_s = round(ANN(:,3:4:end)); %rounding the
ANN_r = ANN(:,4:4:end);

colorCorr = zeros(size(actualColor));
i = 1;
for x=x_l:x_r-1
    for y=y_u:y_d-1
        x_ = round(ANN_x(y,x));
        y_ = round(ANN_y(y,x));
        colorCorr(i,:) = tgt(y_,x_,:);
        i=i+1;
    end
end


colorCorr = reshapeColor(colorCorr,iroi);
imshow(uint8(colorCorr))
