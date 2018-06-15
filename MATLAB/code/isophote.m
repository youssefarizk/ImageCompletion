function [ I, theta ] = isophote( L, alpha )
    L = double(L)/255; theta=zeros(size(L));
    [Lx,Ly] = gradient(L);
    I = sqrt(Lx.^2+Ly.^2);
    I = I./max(max(I));
    T = I>=alpha;
    theta(T) = atan(Ly(T)./Lx(T));
    I(I<alpha)=0;
end