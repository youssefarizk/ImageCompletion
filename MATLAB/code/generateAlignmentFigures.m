clear;
close all;

%% Initializations

% site = 'taj_mahal/';
img1 = 'img1';
% img2 = 'img2';

keySet = {'milan/','eiffel/','sphinx/','taj_mahal/'};
valueSet = {[330 700 260 480], [390 680 380 550], [440 650 230 410], [440 570 185 300]};
roi = containers.Map(keySet,valueSet);

valueSet = {'img5', 'img3', 'img2', 'img2'};
img = containers.Map(keySet,valueSet);
siteList = ["milan/","eiffel/","sphinx/","taj_mahal/"];

for site=siteList
    
    site1 = site;
    site = char(site);
    img2 = img(site);
    
    % Loading Relevant Images
    srcImg = imread(strcat('../exports/',site,img1,'/SourceImage0.bmp'));
    exemplar1 = imread(strcat('../exports/',site,img1,'/TargetImage0.bmp'));
    exemplar2 = imread(strcat('../exports/',site,img2,'/TargetImage0.bmp'));
    completion = imread(strcat('../exports/',site,img2,'/CompletedImage1.bmp'));
    
    % Setting ROI
    % iroi = [330 700 260 480]; %milan
    % x_l = 330; x_r = 700; y_u = 260; y_d = 480;
    % iroi = [390 680 380 550]; %eiffel
    % x_l = 390; x_r = 680; y_u = 380; y_d = 550;
    % iroi = [440 650 230 410]; %sphinx
    % x_l = 440; x_r = 650; y_u = 230; y_d = 410;
    % iroi = [440 570 185 300]; %taj
    % x_l = 440; x_r = 570; y_u = 185; y_d = 300;
    
    iroi = roi(site);
    x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);
    
    % Interpolated Nearest Neighbour Fields;
    
    ANN1 = csvread(strcat('../exports/',site,img1,'/annCplt4.csv'));
    
    ANN1_x = ANN1(:,1:4:end);
    ANN1_y = ANN1(:,2:4:end);
    ANN1_s = ANN1(:,3:4:end);
    ANN1_r = ANN1(:,4:4:end);
    
    ANN2 = csvread(strcat('../exports/',site,img2,'/annCplt4.csv'));
    
    ANN2_x = ANN2(:,1:4:end);
    ANN2_y = ANN2(:,2:4:end);
    ANN2_s = ANN2(:,3:4:end);
    ANN2_r = ANN2(:,4:4:end);
    
    ANN12 = csvread(strcat('../exports/',site,img1,'_',img2,'/annCplt4.csv'));
    
    ANN12_x = ANN12(:,1:4:end);
    ANN12_y = ANN12(:,2:4:end);
    ANN12_s = ANN12(:,3:4:end);
    ANN12_r = ANN12(:,4:4:end);
    
    % Color Correction Matrices
    colorCorr1 = csvread(strcat('../exports/',site,img1,'/color4.csv'));
    colorCorr1 = reshapeColor(colorCorr1, iroi);
    
    colorCorr2 = csvread(strcat('../exports/',site,img2,'/color4.csv'));
    colorCorr2 = reshapeColor(colorCorr2, iroi);
    
    pMat1 = csvread(strcat('../exports/',site,img1,'/pmat4.csv'));
    pMat2 = csvread(strcat('../exports/',site,img2,'/pmat4.csv'));
    
    %% Obtain final, color-corrected reconstructions
    
    recon1 = srcImg;
    fromSrc1 = ones(size(srcImg,1),size(srcImg,2));
    
    for x=x_l:x_r-1
        for y=y_u:y_d-1
            if pMat1(y,x) < 0.8*255
                recon1(y,x,:) = colorCorr1(y-y_u+1,x-x_l+1,:);
                fromSrc1(y,x) = 0;
            end
        end
    end
    
    colorCorr1 = recon1(y_u:y_d-1,x_l:x_r-1,:);
    fromSrc1 = fromSrc1(y_u:y_d-1,x_l:x_r-1);
    
    recon2 = srcImg;
    fromSrc2 = ones(size(srcImg,1),size(srcImg,2));
    
    for x=x_l:x_r-1
        for y=y_u:y_d-1
            if pMat2(y,x) < 0.8*255
                recon2(y,x,:) = colorCorr2(y-y_u+1,x-x_l+1,:);
                fromSrc2(y,x) = 0;
            end
        end
    end
    
    colorCorr2 = recon2(y_u:y_d-1,x_l:x_r-1,:);
    fromSrc2 = fromSrc2(y_u:y_d-1,x_l:x_r-1);
%     figure;
%     imshowpair(recon1,recon2,'montage');
    % imshow(recon1);
    
    
    %% Color correction of nearest neighbour
    
    x_offset = x_l - 1;
    y_offset = y_u - 1;
    
    height = y_d - y_u; width = x_r - x_l;
    
    colorCorr = zeros(height*width, 3);
    i=1;
    
    for x = x_l:x_r-1
        for y = y_u:y_d-1
            
            x_ = round(ANN1_x(y,x))+1;
            y_ = round(ANN1_y(y,x))+1;
            x_new = round(ANN12_x(y_,x_))+1;
            y_new = round(ANN12_y(y_,x_))+1;
            
            colorCorr(i,:) = exemplar2(y_new,x_new,:)+1;
            i=i+1;
            
            %         if inROI(y_new,x_new,1) == 1
            %             y_n = inROI(y_new,x_new,2); x_n = inROI(y_new,x_new,3);
            %             srcImg(y,x,:) = colorCorr2(y_n-y_offset,x_n - x_offset,:);
            %         else
            %             srcImg(y,x,:) = exemplar2(y_new,x_new,:);
            %         end
            
        end
    end
    
    colorCorr = colorCorrection(site, img2, iroi, colorCorr);
    figure;
    test = srcImg;
    test(y_u:y_d-1,x_l:x_r-1,:) = colorCorr;
    imshow(test);
    
    outputName = sprintf('../../report/testing/reconstruction/color_corr_innf_%s',site(1:end-1));
    print(outputName,'-depsc')
    print(outputName,'-djpeg')
    
end