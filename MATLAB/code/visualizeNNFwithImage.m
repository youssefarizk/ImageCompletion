clear;
close all;

addpath('../assets/');

A = imread('output_Color4.bmp');
B = imread('output_Color4_medium.bmp');
C = imread('NNF_Init4.bmp');
D = imread('NNF_Init4_medium.bmp');
E = imread('NNF_Intrpl_4.bmp');
F = imread('NNF_Intrpl_4_medium.bmp');

figure;

subplot(3,2,1);
imshow(A)
subplot(3,2,2);
imshow(B)
subplot(3,2,3);
imshow(C)
subplot(3,2,4);
imshow(D)
subplot(3,2,5);
imshow(E)
subplot(3,2,6);
imshow(F)

print('../output/image_ann_annCplt','-depsc');

%Averaging Result

G = A/2 + B/2;
figure; 
imshow(G);
print('../output/reconstruction_average','-depsc');