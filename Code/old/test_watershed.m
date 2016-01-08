% I: countour image



level_thr=graythresh(uint8(I));


 % this part is not working... it doesn't get to convert the image into BW.
% What is happening?????????????????????????????????????????????
BW=im2bw(uint8(I),level_thr);
figure(2), imshow(BW); title('output im2bw')

% if we delete this part the watershed will be implemented inside the
% contour 
% but we want background= white and image=black
  C=BW;
% figure(5), imshow(C); title('output C=~BW')

% Distance transform D --> distance from every pixel to the nearest
% nonzero-valued pixel. The - sign
D=-bwdist(C); 

% Background pixels and the extended maxima pixels are forced to be the
% only local minima in the image
D(C)=-Inf;


%%%%%%%%%%% WATERSHED
% Converting image into 3d
I2 = double(I);
y = imagesc(I2);% gives 2D image
z = mesh(I);

L=watershed(y)




%%%%%%%%% output: L --> L= watershed(D)

white1=ones(size(L));
white1(L==0)=0;

str=sprintf('output watershed, L (level= %0.2f)',level_thr);
figure,imshow(white1),title(str)
im=rgb2gray(im);
str=sprintf('Segmented image');

im(L==0)=0;
figure,imshow(uint8(im)),title(str)

