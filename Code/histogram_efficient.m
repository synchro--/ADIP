% Code implementing basic idea of the Arbelaez's algorithm

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
num_bins=24;
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


% EFFICIENT COMPUTATION
% 1.Rotate the intensity image of a certain angle
% 2.Approximate the circle with a rectangle
% 3.Consider 2 different rectangles (upper part/lower part)
% 4.Compute the integral image of the rotated image
% 5.Compute the histogram of each halves of the rectangle using the sum of
%   over the region with the integral image, as stated in the paper:
%   J(P)+J(S)-J(Q)-J(R)
% 6.Compute the difference between the histograms of the upper/lower part
%   of the rectangle
% 7.Rotate the image back
% 8.Repeat the previous points for all the bins (not clear how to do with matlab functions?)

im=imrotate(im,-45);
rows=size(im,1);
cols=size(im,2);
%we process each histogram bin separately
I_b_cell=compute_histogram_bins(im,num_bins);
save('var.mat'); 

%%
load('var.mat');

% Histograms of the central part (without taking into account the 5 pixels
% borders)
for r=5:rows-5
    tic
    %fprintf(' raw= %d',r)
    for c=5:cols-5
        
        % Oriented rotated histogram
        % fprintf('col= %d  \n',c)
        
        
        for n=1:num_bins
            
            %I_b=(I_b_cell(n,:,:));
            %I_b=reshape(I_b,size(im,1),size(im,2));
            
            %computing the integral image, choose one of the two
            %if we use cumsum then we have to pad with 0s the last row and
            %column
            %J=integralImage(I_b_cell{1,n});
            J=cumsum(double(I_b_cell{1,n}),2);
            J(:,cols+1)=0;
            J(rows+1,:)=0;

            
            %Define rectangular region as [startingRow, startingColumn, endingRow, endingColumn].
            [sR sC eR eC] = deal(r-4,c-4,r,c+5);
            regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC);
            up_hist(n)=regionSum;
            
            [sR sC eR eC] = deal(r+1,c-4,r+5,c+5);
            regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC);
            down_hist(n)=regionSum;
            
        end
        
        
        gradient_magnitude_x=up_hist-down_hist;
        
        % using this instead of a for loop change the results (don't know
        % why). And decrease the time 5 seconds
        %sum_val_x=sum((up_hist-down_hist).^2./(up_hist+down_hist));
        %gradient_magnitude_x=0.5*sum_val_x;
        
        %         % Oriented Histogram in Y
        %         new_im_left=im(r-4:r+5,c-4:c); % cut the image in order to have the left part
        %         [counts_y,~]=imhist(new_im_left,num_bins);
        %         %counts_y(counts_y==0)=1;
        %         left_hist= counts_y;
        %         new_im_right=im(r-4:r+5,c+1:c+5); % cut the image in order to have the right part
        %         [counts_y,~]=imhist(new_im_right,num_bins);
        %         right_hist=counts_y;
        % %         counts_y(counts_y==0)=1;
        %         sum_val_y= sum((left_hist-right_hist).^2./(left_hist+right_hist));
        %         gradient_magnitude_y=0.5*sum_val_y;
        
        % Max val of both
        %  gradient_dens_max(r,c)=max(gradient_magnitude_x, gradient_magnitude_y);
        gradient_dens_x(r,c)=sum(gradient_magnitude_x);
        %   gradient_dens_y(r,c)=gradient_magnitude_y;
        
        
    end
    toc
end

im=imrotate(im,45);


% gauss=fspecial('gaussian',8,1); %% Initialized a gaussian filter with sigma=0.5 * block width.

% final=imrotate(gradient_dens_x,-45)
% final=imcrop(final) % you have to manually crop the image
% imshow(uint8(final));
% title('Gradient Density in 45�')

% Show gradients
figure(1)
subplot(1,3,1)
imshow(uint8(gradient_dens_x));
title('Gradient Density in X ')
subplot(1,3,2)
imshow(uint8(gradient_dens_y));
title('Gradient Density in Y')

subplot(1,3,3)
imshow(uint8(gradient_dens_max));
title('Gradient Density in X and Y')
filtered=sgolayfilt(gradient_dens_max,2,7)

figure(2)
subplot(1,2,1)
gradient_dens_max(gradient_dens_max<10)=0;
imshow(uint8(gradient_dens_max));
title('filtered val<10')
subplot(1,2,2)
gradient_dens_max(gradient_dens_max<20)=0;
imshow(uint8(gradient_dens_max));
title('filtered val<20')

figure(3)
subplot(1,2,1)
gradient_dens_max(gradient_dens_max<25)=0;
imshow(uint8(gradient_dens_max));
title('filtered val<25')
subplot(1,2,2)
imshow(uint8(filtered));
title('filtered image\_sgolayfilt')

toc