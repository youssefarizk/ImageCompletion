clear; close all;

numAngles = 90;
numScales = 256;
startScale = 0.33; endScale = 3.00;
x_l = 330; x_r = 700; y_u = 260; y_d = 480;
fileName = '../exports/milan/img1/ann4.csv';

ANN = csvread(fileName);

%separating into 4 degrees of freedom
ANN_x = ANN(:,1:4:end);
ANN_y = ANN(:,2:4:end);
ANN_s = round(ANN(:,3:4:end)); %rounding the
ANN_r = ANN(:,4:4:end);

[img_y, img_x] = size(ANN_x);

threshList = 1.0:0.05:3.0;
rslt_good = zeros(4,length(threshList));
idx = 1;

for thresh = threshList
    
    tmp_x = ANN_x(y_u:y_d,x_l:x_r);
    tmp_y = ANN_y(y_u:y_d,x_l:x_r);
    tmp_s = ANN_s(y_u:y_d,x_l:x_r);
    tmp_r = ANN_r(y_u:y_d,x_l:x_r);
    
    [x_,y_,s,r] = findClusters(tmp_x,tmp_y,tmp_s,tmp_r,thresh); % boundary point count
    rslt_good(:,idx) = [x_,y_,s,r]';
    idx = idx + 1;
    
end

fileName = '../exports/milan/img2/ann4.csv';

ANN = csvread(fileName);

%separating into 4 degrees of freedom
ANN_x = ANN(:,1:4:end);
ANN_y = ANN(:,2:4:end);
ANN_s = round(ANN(:,3:4:end)); %rounding the
ANN_r = ANN(:,4:4:end);

[img_y, img_x] = size(ANN_x);
rslt_medium = zeros(4,length(threshList));
idx = 1;

for thresh = threshList
    
    tmp_x = ANN_x(y_u:y_d,x_l:x_r);
    tmp_y = ANN_y(y_u:y_d,x_l:x_r);
    tmp_s = ANN_s(y_u:y_d,x_l:x_r);
    tmp_r = ANN_r(y_u:y_d,x_l:x_r);
    
    [x_,y_,s,r] = findClusters(tmp_x,tmp_y,tmp_s,tmp_r,thresh); % boundary point count
    rslt_medium(:,idx) = [x_,y_,s,r]';
    idx = idx + 1;
    
end

fileName = '../exports/milan/img3/ann4.csv';

ANN = csvread(fileName);

%separating into 4 degrees of freedom
ANN_x = ANN(:,1:4:end);
ANN_y = ANN(:,2:4:end);
ANN_s = round(ANN(:,3:4:end)); %rounding the
ANN_r = ANN(:,4:4:end);

[img_y, img_x] = size(ANN_x);

rslt_bad = zeros(4,length(threshList));
idx = 1;

for thresh = threshList
    
    tmp_x = ANN_x(y_u:y_d,x_l:x_r);
    tmp_y = ANN_y(y_u:y_d,x_l:x_r);
    tmp_s = ANN_s(y_u:y_d,x_l:x_r);
    tmp_r = ANN_r(y_u:y_d,x_l:x_r);
    
    [x_,y_,s,r] = findClusters(tmp_x,tmp_y,tmp_s,tmp_r,thresh); % boundary point count
    rslt_bad(:,idx) = [x_,y_,s,r]';
    idx = idx + 1;
    
end

figure;
subplot(2,2,1);
plot(threshList,rslt_good(1,:)); hold on;
plot(threshList,rslt_medium(1,:)); hold on;
plot(threshList,rslt_bad(1,:))
legend('good','medium','bad');
title('X Clusters')

subplot(2,2,2);
plot(threshList,rslt_good(2,:)); hold on;
plot(threshList,rslt_medium(2,:)); hold on;
plot(threshList,rslt_bad(2,:))
legend('good','medium','bad');
title('Y Clusters')

subplot(2,2,3);
plot(threshList,rslt_good(3,:)); hold on;
plot(threshList,rslt_medium(3,:)); hold on;
plot(threshList,rslt_bad(3,:))
legend('good','medium','bad');
title('S Clusters')

subplot(2,2,4);
plot(threshList,rslt_good(4,:)); hold on;
plot(threshList,rslt_medium(4,:)); hold on;
plot(threshList,rslt_bad(4,:))
legend('good','medium','bad');
title('R Clusters')

print('../../report/testing/clustervar_milan','-depsc');

