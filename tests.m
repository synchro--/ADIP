% I=my_image;
clc
figure(1),imshow(uint8(I))

level_thr=graythresh(I);

% this part is not working... it doesn't get to convert the image into BW.
% What is happening?????????????????????????????????????????????
BW=im2bw(I,0.4);
figure(2), imshow(uint8(BW)); title('output im2bw')

% if we delete this part the watershed will be implemented inside the
% contour 
% but we want background= white and image=black
% C=~BW;
% figure(5), imshow(C); title('output C=~BW')

% Distance transform D --> distance from every pixel to the nearest
% nonzero-valued pixel. The - sign
D=-bwdist(BW); 

% Background pixels and the extended maxima pixels are forced to be the
% only local minima in the image
D(BW)=-Inf;

% L: label matrix that contains positive integers corresponding to the
% locations of each catchment basins
L=watershed(D);
white1=ones(size(L));
white1(L==0)=0;

str=sprintf('output watershed, L (level= %0.2f)',level_thr);
figure(3),imshow(white1),title(str)

str=sprintf('Segmented image');
I(L==0)=0;
figure(4),imshow(I),title(str)