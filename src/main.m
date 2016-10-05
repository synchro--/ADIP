%%% MAIN FUNCTION %%%
% 1. computes the normal histogram
% 2. computes the oriented histograms
% 3. merges the 3 gradients
% 4. plot the gradient of oriented histograms
% 5. compute the watershed transform of this HOG
% 6. plot the segmented image.
%
% Author: Ali Alessio Salman

clc
clear all
close all

img_name = 'im_larger.jpg';
orientations = [45 135];

tic

%compute the gradients according to all orientations
[img_orig,norm_grad]=compute_norm_histogram(img_name);
grad45=compute_oriented_hist(img_name,orientations(1)); 
grad135=compute_oriented_hist(img_name,orientations(2)); 

%%
%Merging the gradients and plot the final image with countours
%run only this section to test different filters, see merge_grad_func
close all
final_grad=merge_grad_func(norm_grad,grad45,grad135);


%% %%%%%% WATERSHED TRANSFORM %%%%%%%%%%%

segmented=watershed_transform(img_orig,final_grad);
figure(101);
imshow(segmented);
title('Segmented Image')