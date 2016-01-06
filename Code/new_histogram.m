% Code implementing basic idea of the Arbelaez's algorithm

% Authors: Ali Alessio Salman, Mar�a Silos

clc
clear all
close all

DEBUG=0;

%Initial conditions
%in this way is independent from the OS and the current file system
%pwd specify the current directory and filesep is '\' on windows and '/' on Linux
%has to be run inside ADIP directory
root_path = pwd;
path_im=[root_path filesep 'Images' filesep];
image = 'im_larger.jpg';
im=imread([path_im image]);

num_bins=64;
neighbors=5; % Number of neighbouring pixels

% Convert RGB image to grayscale
if size(im,3)==3
    im=rgb2gray(im);
end

%median filter, not sure if it's improving or not
%im=medfilt2(im,[3 3]); 


figure(100);
imshow(im);

up_hist=[]; % Basic Matrix assignment of Upper Histogram
down_hist=[]; % Basic Matrix assignment of Lower Histogram
left_hist=[];
right_hist=[];

border_rows=5;
border_cols=5;
%these variables are only for testing purposes on the histogram values
%less pixels > faster computation
test_rows=250;
test_cols=250;

rows=size(im,1);
cols=size(im,2);
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
% 8.Repeat the previous points for all the bins
% 9.Difference between histograms (how to proper do this?)

%im=imrotate(im,-45);
rows=size(im,1);
cols=size(im,2);
%we process each histogram bin separately
I_b_cell=compute_histogram_bins(im,num_bins);
%I_b_cell=compute_hist_bins_with_imhist(im,num_bins); 


%computing the integral image, choose one of the two
%if we use cumsum then we have to pad with 0s the last row and
%column

%initialize the cell that will contain all the integral images
J_cell=cell(1,num_bins);
[J_cell{:}] = deal(zeros(rows,cols));

tic 
for n=1:num_bins
    J_cell{1,n} = integralImage(I_b_cell{1,n});
end
toc


% %save('var.mat');
% 
% %****** TESTING VARIABLES ******%
% %variable for my histogram
% TEST_HIST=cell(test_rows - border_rows , test_cols - border_cols);
% [TEST_HIST{:}] = deal(zeros(1,num_bins));
% 
% %variable for matlab histogram function
% TEST_HIST2=cell(test_rows - border_rows , test_cols - border_cols);
% [TEST_HIST2{:}] = deal(zeros(1,num_bins));
% 
% if DEBUG == 1
%     rows=test_rows; 
%     cols=test_cols; 
% end

%%
%load('var.mat');

% Histograms of the central part (without taking into account the 5 pixels
% borders)

for r=5:rows-5
    
    %fprintf(' raw= %d',r)
    for c=5:cols-5
        % Oriented rotated histogram
        % fprintf('col= %d  \n',c)
        
        if DEBUG==1
            tmp_hist=TEST_HIST{r,c}; %1 x num_bins matrix
        end
        
        %computing the histogram using the integral image
        for n=1:num_bins
            
            %retrieving the proper integral image according to the bin we
            %are processing
            J=J_cell{1,n};
            
            
            %the integralimage based sum region takes just 10^-5 sec
            %Define rectangular region as [startingRow, startingColumn, endingRow, endingColumn].
            
            %******* X-AXIS *******%
            %UPPER PART
            [sR sC eR eC] = deal(r-4,c-4,r,c+5);
            regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC);
            up_hist(n)=regionSum;
            
            %saving to a variable for further comparison later
            tmp_hist(n)=up_hist(n);
            
            %LOWER PART
            [sR sC eR eC] = deal(r+1,c-4,r+5,c+5);
            regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC);
            down_hist(n)=regionSum;
            
            
            %******* Y-AXIS ******%
            %LEFT PART
            [sR sC eR eC] = deal(r-4,c-4,r+5,c);
            regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC);
            left_hist(n)=regionSum;
            
            %RIGHT PART
            [sR sC eR eC] = deal(r-4,c+1,r+5,c+5);
            regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC);
            right_hist(n)=regionSum;
            
        end
        
        
        %***+ CHECKING WITH MATLAB FUNCTIONS *****
        %upper part
        new_im_up=im(r-4:r,c-4:c+5); % cut the image in order to have the upper part
        [counts_x,~]=histcounts(new_im_up,num_bins);
        %fprintf('counts(n)= %d\n',counts_x(n));
        %fprintf('up_hist(n)= %d\n\n\n', up_hist(n));
        
        if DEBUG == 1
            %saving for further comparison later
            TEST_HIST{r,c}=tmp_hist;
            TEST_HIST2{r,c}=counts_x;
        end
        
        %this is crucial, but why exactly?
        up_hist(up_hist==0)=1;
        down_hist(down_hist==0)=1;
        left_hist(left_hist==0)=1;
        right_hist(right_hist==0)=1;
        
        %this is the same utilization of the histograms as seen before and
        %it works. However in the paper it seems we shouldn't use this but
        %it's not clear at all (see Appendix efficient computation)
        
        sum_val_x=sum((up_hist-down_hist).^2./(up_hist+down_hist));
        gradient_magnitude_x=0.5*sum_val_x;
        
        sum_val_y= sum((left_hist-right_hist).^2./(left_hist+right_hist));
        gradient_magnitude_y=0.5*sum_val_y;
        
        % Max val of both
        gradient_dens_x(r,c)=gradient_magnitude_x; %10^-5
        gradient_dens_y(r,c)=gradient_magnitude_y;
        gradient_dens_max(r,c)=max(gradient_magnitude_x, gradient_magnitude_y);
                
    end
    
    
end


%rotate the image back
%im=imrotate(im,45);

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
filtered=sgolayfilt(gradient_dens_max,2,7);

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

save('hist_comparison.mat');
toc