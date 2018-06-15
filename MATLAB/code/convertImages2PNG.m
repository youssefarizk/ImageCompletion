keySet = {'milan/','eiffel/','sphinx/','taj_mahal/','recon1/','recon2/','recon3/','recon4/','recon5/','recon6/'};

valueSet = {'img1','img1','img1','img1','img1', 'img1', 'img1', 'img4', 'img1', 'img2'};
img_1 = containers.Map(keySet,valueSet);

valueSet = {'img5','img3','img2','img2','img2', 'img2', 'img2', 'img1', 'img2', 'img1'};
img_2 = containers.Map(keySet,valueSet);
siteList = ["milan/","eiffel/","sphinx/","taj_mahal/","recon1/","recon2/","recon3/","recon4/","recon5/","recon6/"];

for site=siteList
   site = char(site);
   img1 = img_1(site);
   img2 = img_2(site);
   
   imwrite(imread(strcat('../exports/',site,img1,'/SourceImage0.bmp')),sprintf('../../report/testing/reconstruction/SourceImage-%s-%s.png',site(1:end-1),img1));
%    imwrite(imread(strcat('../exports/',site,img2,'/SourceImage0.bmp')),sprintf('../../report/testing/reconstruction/CompletedImage-%s-%s.png',site(1:end-1),img2));
    
end