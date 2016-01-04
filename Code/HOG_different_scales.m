% Code implementing basic idea of the Arbelaez's algorithm 
% Authors: Alessio Salman, María Silos
tic 

clc
clear all
close all

debug=0; % debug = 1 if you want to observe the filtered images
image='im.jpg';
image_larger= 'im_larger.jpg';
image_smaller='im_small.jpg';

gradient_dens=[];

gradient_dens_small= get_gradient_density(image_smaller,debug);
gradient_dens_normal= get_gradient_density(image,debug);
gradient_dens_larger= get_gradient_density(image_larger,debug);

figure
subplot(1,3,1)
imshow(uint8(gradient_dens_small));
title('Gradient Density s=0.5')
subplot(1,3,2)
imshow(uint8(gradient_dens_normal));
title('Gradient Density s=1')
subplot(1,3,3)
imshow(uint8(gradient_dens_larger));
title('Gradient Density s=2')

toc
