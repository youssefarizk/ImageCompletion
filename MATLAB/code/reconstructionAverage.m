clear;
close all;

%% Initializations

keySet = {'milan/','eiffel/','sphinx/','taj_mahal/','recon1/','recon2/','recon3/','recon4/','recon5/','recon6/'};
valueSet = {[330 700 260 480],[390 680 380 550],[440 650 230 410],[440 570 185 300],[430 725 280 625],[360 670 310 630],[350 690 330 640],[335 620 170 710],[390 600 375 740],[250 475 240 790]};
roi = containers.Map(keySet,valueSet);

valueSet = {'img1','img1','img1','img1','img1', 'img1', 'img1', 'img4', 'img1', 'img2'};
img_1 = containers.Map(keySet,valueSet);

valueSet = {'img5','img3','img2','img2','img2', 'img2', 'img2', 'img1', 'img2', 'img1'};
img_2 = containers.Map(keySet,valueSet);
siteList = ["milan/","eiffel/","sphinx/","taj_mahal/","recon1/","recon2/","recon3/","recon4/","recon5/","recon6/"];

for site=siteList
    
    site = char(site);
    img1 = img_1(site);
    img2 = img_2(site);
    iroi = roi(site);
    x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);
    height = y_d-y_u; width = x_r-x_l;
    % Loading Relevant Images
    srcImg = imread(strcat('../exports/',site,img1,'/SourceImage0.bmp'));
    exemplar1 = imread(strcat('../exports/',site,img1,'/TargetImage0.bmp'));
    exemplar2 = imread(strcat('../exports/',site,img2,'/TargetImage0.bmp'));
    completion = imread(strcat('../exports/',site,img2,'/CompletedImage1.bmp'));
    
    
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
    % figure;
    % imshowpair(recon1,recon2,'montage');
    % tic
    A = (recon1/2+recon2/2);
    % toc
    % figure;
    % imshow((recon1/2+recon2/2))
    
    imwrite(A,sprintf('../../report/testing/reconstruction/average_%s.png',site(1:end-1)))
    % print(strcat('../../report/recon/',site(1:end-1),'_average'),'-depsc')
    
end