clear;
close all;

keySet = {'recon1/','recon2/','recon3/','recon4/','recon5/','recon6/'};
valueSet = {[430 725 280 625],[360 670 310 630],[350 690 330 640],[335 620 170 710],[390 600 375 740],[250 475 240 790]};
roi = containers.Map(keySet,valueSet);

fullList = ["img1","img2","img3","img4","img5","img6","img7","img8","img9","img10"];
valueSet = {fullList,fullList,["img1","img2","img3","img4","img5","img10"],...
    ["img1","img2","img4","img5","img10"],["img1","img2","img3","img6","img7"],fullList};

candSet = containers.Map(keySet,valueSet);

%% Initializations
for rec=['1','2','3','4','5','6'];
    
    site = strcat('recon',rec,'/');
    candidates = candSet(site);
    
    iroi = roi(site);
    x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);
    
    scores = zeros(4,length(candidates));
    idx = 1;
    
    for candidate=candidates
        
        candidate =char(candidate);
        
        ANN = csvread(sprintf('../exports/%s/%s/ann4.csv',site(1:end-1),candidate));
        
        %separating into 4 degrees of freedom
        ANN_x = ANN(:,1:4:end);
        ANN_y = ANN(:,2:4:end);
        ANN_s = round(ANN(:,3:4:end)); %rounding the
        ANN_r = ANN(:,4:4:end);
        
        tmp_x = ANN_x(y_u:y_d,x_l:x_r);
        tmp_y = ANN_y(y_u:y_d,x_l:x_r);
        tmp_s = ANN_s(y_u:y_d,x_l:x_r);
        tmp_r = ANN_r(y_u:y_d,x_l:x_r);
        
        [x_,y_,s,r] = findClusters(tmp_x,tmp_y,tmp_s,tmp_r,1.2); % boundary point count
        scores(:,idx) = [x_,y_,s,r]';
        idx = idx + 1;
        
    end
    
    scores = mean(scores,1);
    sortedScores = sort(scores);
    I1 = find(scores==sortedScores(1));
    I2 = find(scores==sortedScores(2));
    
    best1 = candidates(I1);
    best2 = candidates(I2);
    
    fprintf('Best two images for recon%s are %s and %s\n', rec,best1, best2);
    
end