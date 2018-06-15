% Usage: selectPatch(colorCorr,colorCorr1,src_Gy,src_Gx,patchPosition, method)
%
% colorCorr: Color-corrected NN reconstruction using img1&img2
% colorCorr1: Color-corrected reconstruction using img1
% src_Gy: Directional derivative y of source image
% src_Gx: Directional derivative x of source image
% patchPosition: List of vertices
% method:

function [from1,usePatch] = selectPatch(colorCorr,colorCorr1,src_Gy,src_Gx,src,patchPosition, iroi, method)

%iroi
x_l = iroi(1);
x_r = iroi(2);
y_u = iroi(3);
y_d = iroi(4);

%select the patch
x_left = patchPosition(1);
x_right = patchPosition(2);
y_up = patchPosition(3);
y_down = patchPosition(4);

%expanding colorCorrection
colorC = src;
colorC1 = src;
colorC(y_u:y_d-1,x_l:x_r-1,:) = colorCorr;
colorC1(y_u:y_d-1,x_l:x_r-1,:) = colorCorr1;
colorCorr = colorC;
colorCorr1 = colorC1;

offset = 5; % to ensure gradient is smooth over ROI

colorPatch = zeros(size(src_Gy,1),size(src_Gy,2),3);
colorPatch(y_up-offset:y_down-1+offset,x_left-offset:x_right+offset-1,:) = ...
    colorCorr(y_up-offset:y_down-1+offset,x_left-offset:x_right+offset-1,:);

colorPatch1 = zeros(size(src_Gy,1),size(src_Gy,2),3);
colorPatch1(y_up-offset:y_down-1+offset,x_left-offset:x_right+offset-1,:) = ...
    colorCorr1(y_up-offset:y_down-1+offset,x_left-offset:x_right+offset-1,:);

%method specific process
switch method
    case 'isophotes'
        
        [patch_Gy, patch_Gx] = imgradient(rgb2gray(uint8(colorPatch)),'sobel');
        patch_Gy = -patch_Gy;
        [patch1_Gy, patch1_Gx] = imgradientxy(rgb2gray(uint8(colorPatch1)));
        patch1_Gy = -patch1_Gy;
        %         figure; imshowpair(patch_Gy, patch_Gx, 'montage')
        
        y_diff = sum(abs(patch_Gx(y_up:y_down-1,x_left+1) - src_Gx(y_up:y_down-1,x_left-1))).^2;
        
        x_diff = sum(abs(patch_Gy(y_up+1,x_left:x_right-1) - src_Gy(y_up-1,x_left:x_right-1))).^2;
        
        patchScore = sqrt(x_diff + y_diff);
        
        y_diff1 = sum(abs(patch1_Gx(y_up:y_down-1,x_left+1) - src_Gx(y_up:y_down-1,x_left-1))).^2;
        
        x_diff1 = sum(abs(patch1_Gy(y_up+1,x_left:x_right-1) - src_Gy(y_up-1,x_left:x_right-1))).^2;
        
        patchScore1 = sqrt(x_diff1 + y_diff1);
        
        if patchScore1 < patchScore
            usePatch = colorPatch1;
            from1 = true;
        else
%                         usePatch = zeros(size(colorPatch));
            usePatch = colorPatch;
            from1 = false;
        end
end

