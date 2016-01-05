clc
clear all
close all

% Reading Image
root_path = pwd;
path_im=[root_path filesep 'images' filesep];
image = 'maria_2.jpg';
im=imread([path_im image]);


I = rgb2gray(im);
% figure(1),imshow(I)

% text(330,501,'Original Image','FontSize',12,'HorizontalAlignment','right')


% % Creating gradient (countour detection)
%  hy = fspecial('sobel');
%  hx = hy';
%  Iy = imfilter(double(I), hy, 'replicate');
%  Ix = imfilter(double(I), hx, 'replicate');
%  gradmag = sqrt(Ix.^2 + Iy.^2);
%  figure
%  imshow(gradmag,[]), title('Gradient magnitude (gradmag)')
%
%  L= watershed(gradmag);
% %  Lrgb = label2rgb(L)
%  figure, imshow(L)





% tophat: for the subtraction of an opened image from the original. It
% removes all features smaller than the structuring element. It's basically
% removing noise
I1= imtophat(I,strel('disk',10));
figure(2),imshow(I1),title('imtophat output')

% imadjust for histogram stretching
I2= imadjust(I1);
figure(3), imshow(I2), title('output imadjust')

% geting a threshold level to convert our image into Black and White
level_thr=graythresh(I2);

level= [0.02,0.1,level_thr]
level_i=level(1);
BW=im2bw(I2,level_i);
figure(4), imshow(BW); title('output im2bw')

% but we want background= white and image=black
C=~BW;
figure(5), imshow(C); title('output C=~BW')

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

str=sprintf('output watershed, L (level= %0.2f)',level_i);
imshow(white1),title(str)


Wi=label2rgb(L,'hot','w'); % hot colormap
% figure(6), imshow(Wi); title('output WS + label2rgb')
im1=I;
im1(L==0)=0; % L==0 --> ridge lines
% im=imclose(im)
figure(7), imshow(im1); title('im')
% L2=remove_small_regions(L,60);
% im2=I;
% im2(L2==0)=0
% figure(8), imshow(im2); title('im removed small regions')