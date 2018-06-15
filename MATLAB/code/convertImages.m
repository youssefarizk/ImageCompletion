for i=[1 2 3 7]
    A = imread(sprintf('../../report/implementation/tgt_01_0%d.jpg', i));
    imshow(A);
    print(sprintf('../../report/implementation/tgt_01_0%d',i),'-dpng');
end
