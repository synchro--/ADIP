%%% MAIN FUNCTION %%%
% 1. computes the normal histogram
% 2. computes the oriented histograms
% 3. merges the 3 gradients
% 4. plot

clc
clear all
close all

img_name = 'im_larger.jpg';
orientations = [45 125];

tic
%call
norm_grad=compute_norm_histogram(img_name);
grad45=compute_oriented_hist(img_name,orientations(1)); 
grad125=compute_oriented_hist(img_name,orientations(2)); 

%%
%Merging the gradients and plot the final image with countours
%run only this section to test different filters, see merge_grad_func
close all
final_grad=merge_grad_func(norm_grad,grad45,grad125);