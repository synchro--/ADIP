% using get_gradient_density output to implement watershed algorithm
clc
clear all
close all

tic
% Reading Image
root_path = pwd;
path_im=[root_path filesep 'Images' filesep];
image = 'im_larger.jpg';
im=imread([path_im image]);

I=get_gradient_density(image,0)
% I=get_gradient_density(image,0); % image is re-read inside

figure(1),imshow(uint8(I))

level_thr=graythresh(uint8(I));

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

% L: label matrix that contains positive integers corresponding to the
% locations of each catchment basins
L=watershed(D);
white1=ones(size(L));
white1(L==0)=0;

str=sprintf('output watershed, L (level= %0.2f)',level_thr);
figure,imshow(white1),title(str)
im=rgb2gray(im);
str=sprintf('Segmented image');

im(L==0)=0;
figure,imshow(uint8(im)),title(str)
toc