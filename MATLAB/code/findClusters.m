%Function detects number of border points

function [x_,y_,s,r] = findClusters(ANN_x, ANN_y, ANN_s, ANN_r, threshold)

    [img_y, img_x] = size(ANN_x);
    dy = [-1 -1 0 1 1 1 0 -1]; %starting up and going counter clockwise
    dx = [0 1 1 1 0 -1 -1 -1];
    
    %% Initialization
    tmp_x = padarray(ANN_x,[1 1],'replicate');
    tmp_y = padarray(ANN_y,[1 1],'replicate');
    tmp_s = padarray(ANN_s,[1 1],'replicate');
    tmp_r = padarray(ANN_r,[1 1],'replicate');
    
    borderPoints_x = 0;
    borderPoints_y = 0;
    borderPoints_s = 0;
    borderPoints_r = 0;
     
    %% Neighbour Search
    for x = (1:img_x) + 1
        for y = (1:img_y) + 1   
           for i = 1:8
               center = tmp_x(y,x);
               neighbour = tmp_x(y+dy(i),x+dx(i));
               if (neighbour/center > threshold) || (center/neighbour > threshold)
                   borderPoints_x = borderPoints_x + 1;
                   break;
               end   
           end    
        end
    end
    x_ = borderPoints_x/img_x/img_y;
    
    for x = (1:img_x) + 1
        for y = (1:img_y) + 1   
           for i = 1:8
               center = tmp_y(y,x);
               neighbour = tmp_y(y+dy(i),x+dx(i));
               if (neighbour/center > threshold) || (center/neighbour > threshold)
                   borderPoints_y = borderPoints_y + 1;
                   break;
               end   
           end    
        end
    end
    y_ = borderPoints_y/img_x/img_y;
    
    for x = (1:img_x) + 1
        for y = (1:img_y) + 1   
           for i = 1:8
               center = tmp_s(y,x);
               neighbour = tmp_s(y+dy(i),x+dx(i));
               if (neighbour/center > threshold) || (center/neighbour > threshold)
                   borderPoints_s = borderPoints_s + 1;
                   break;
               end   
           end    
        end
    end
    s = borderPoints_s/img_x/img_y;
    
    for x = (1:img_x) + 1
        for y = (1:img_y) + 1   
           for i = 1:8
               center = tmp_r(y,x);
               neighbour = tmp_r(y+dy(i),x+dx(i));
               if (neighbour/center > threshold) || (center/neighbour > threshold)
                   borderPoints_r = borderPoints_r + 1;
                   break;
               end   
           end    
        end
    end
    r = borderPoints_r/img_x/img_y;
    
    
    
end