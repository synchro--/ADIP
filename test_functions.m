
% Authors: Ali Alessio Salman, Mar�a Silos

clc
clear all
close all

tic
%Initial conditions
%in this way is independent from the OS and the current file system
%pwd specify the current directory and filesep is '\' on windows and '/' on Linux
%has to be run inside ADIP directory
root_path = pwd;
path_im=[root_path filesep 'Images' filesep];
image = 'im_larger.jpg';
im=imread([path_im image]);
num_bins=20;
neighbors=5; % Number of neighbouring pixels

% Convert RGB image to grayscale
if size(im,3)==3
    im=rgb2gray(im);
end

array=compute_histogram_bins(im, num_bins);
counter=0;
for i=1:num_bins 
    a=array{1,i};
    b=sum(a); 
    tot(i)=sum(b); 
end


[N,edges]=histcounts(im,num_bins); 
[counts,X]=imhist(im,num_bins); 
disp(tot); %should be the number of pixel of the image