clear;
close all;

reconstruction = imread('../exports/milan/img1/CompletedImage1.bmp');

threshList = [0.1719];

% [edges,thresh] = edge(rgb2gray(reconstruction), 'Canny');

offset = 2;

x_l = 330; x_r = 700; y_u = 260; y_d = 480;

small_x_l = x_l + offset;
small_x_r = x_r - offset;
small_y_u = y_u + offset;
small_y_d = y_d - offset;

big_x_l = x_l - offset;
big_x_r = x_r + offset;
big_y_u = y_u - offset;
big_y_d = y_d + offset;

for thresh=threshList
    
    %debuggin line
    
   big_edge = edge(rgb2gray(reconstruction(big_y_u:big_y_d,big_x_l:big_x_r,:)), 'Canny',thresh);
   small_edge = edge(rgb2gray(reconstruction(small_y_u:small_y_d,small_x_l:small_x_r,:)), 'Canny',thresh);
   normal_edge = edge(rgb2gray(reconstruction(y_u:y_d,x_l:x_r,:)), 'Canny',thresh);
   
   big_dense = (sum(sum(big_edge)) - sum(sum(normal_edge)))/...
       (size(big_edge,1)*size(big_edge,2) - size(normal_edge,1)*size(normal_edge,2));
   small_dense = (sum(sum(normal_edge)) - sum(sum(small_edge)))/...
       (size(normal_edge,1)*size(normal_edge,2) - size(small_edge,1)*size(small_edge,2));
   
   ratio = small_dense/big_dense
   
end
   
