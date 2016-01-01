% Code implementing basic idea of the Arbelaez's algorithm 

% Authors: Alessio Salman, María Silos

clc
clear all
close all

tic
%Initial conditions
%in this way is independent from the OS and the current file system 
%pwd specify the current directory and filesep is '\' on windows and '/' on Linux 
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

rows=size(im,1);
cols=size(im,2);
up_hist=[]; % Basic Matrix assignment of Upper Histogram
down_hist=[]; % Basic Matrix assignment of Lower Histogram
left_hist=[];
right_hist=[];
gradient_dens_x=zeros(rows,cols); % black image
gradient_dens_y=zeros(rows,cols);

% Histograms of the central part (without taking into account the 5 pixels
% borders)
for r=5:rows-5
    for c=5:cols-5
%         % Oriented Histogram in X
        fprintf('raw= %d',r)
        fprintf('col= %d  \n',c)
        new_im_up=im(r-4:r,c-4:c+5); % cut the image in order to have the upper part
        [counts_x,~]=imhist(new_im_up,num_bins);
        counts_x(counts_x==0)=1; 
        up_hist= counts_x;
        new_im_down=im(r+1:r+5,c-4:c+5); % cut the image in order to have the lower part
        [counts_x,~]=imhist(new_im_down,num_bins);
        down_hist=counts_x;
%         counts_x(counts_x==0)=1; 
        sum_val_x=0;
        for i=1:length(counts_x)
            sum_val_x= sum_val_x+(up_hist(i)-down_hist(i))^2/(up_hist(i)+down_hist(i));
        end
        gradient_magnitude_x=0.5*sum_val_x;
        
        % Oriented Histogram in Y
        new_im_left=im(r-4:r+5,c-4:c); % cut the image in order to have the upper part
        [counts_y,~]=imhist(new_im_left,num_bins);
        counts_y(counts_y==0)=1; 
        left_hist= counts_y;
        new_im_right=im(r-4:r+5,c+1:c+5); % cut the image in order to have the lower part
        [counts_y,~]=imhist(new_im_right,num_bins);
        right_hist=counts_y;
%         counts_y(counts_y==0)=1;
        sum_val_y=0;
        for j=1:length(counts_y)
            sum_val_y= sum_val_y+(left_hist(i)-right_hist(i))^2/(left_hist(i)+right_hist(i));
        end
        gradient_magnitude_y=0.5*sum_val_y;
        % Max val of both
        gradient_dens_sum(r,c)=gradient_magnitude_x + gradient_magnitude_y;
        gradient_dens_max(r,c)=max(gradient_magnitude_x, gradient_magnitude_y);

    end
end

% gauss=fspecial('gaussian',8,1); %% Initialized a gaussian filter with sigma=0.5 * block width.

% % Remove redundant pixels in an image.
gradient_dens_sum(gradient_dens_sum<10)=0;
gradient_dens_max(gradient_dens_max<10)=0;

% sgolayfilt(gradient_dens,2)
% Show gradient
figure
subplot(1,3,1)
imshow(uint8(gradient_dens_sum));
title('gradient density with sum')
filtered=sgolayfilt(gradient_dens_max,2,7)
subplot(1,3,2)
imshow(uint8(gradient_dens_max));
title('gradient density with max')
subplot(1,3,3)
imshow(uint8(gradient_dens_max));
title('filtered image')
toc