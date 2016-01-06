%testing the count of the histogram, it's exactly the same
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
image = 'im_small.jpg';
im=imread([path_im image]);

num_bins=20;
neighbors=5; % Number of neighbouring pixels

% Convert RGB image to grayscale
if size(im,3)==3
    im=rgb2gray(im);
end

figure(100);
imshow(im);

up_hist=[]; % Basic Matrix assignment of Upper Histogram
down_hist=[]; % Basic Matrix assignment of Lower Histogram
left_hist=[];
right_hist=[];

border_rows=5;
border_cols=5;
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


%computing the integral image, choose one of the two
%if we use cumsum then we have to pad with 0s the last row and
%column

%initialize the cell that will contain all the integral images
J_cell=cell(1,num_bins);
[J_cell{:}] = deal(zeros(rows,cols));

for n=1:num_bins
    J_cell{1,n} = integralImage(I_b_cell{1,n});
end

tic

%%


% Histograms of the central part (without taking into account the 5 pixels
% borders)


%tmp_hist=TEST_HIST{1,1}; %1 x num_bins matrix
tmp_hist=[];

%computing the histogram using the integral image
for n=1:num_bins
    
    %retrieving the proper integral image according to the bin we
    %are processing
    J=J_cell{1,n};
    
    
    %the integralimage based sum region takes just 10^-5 sec
    %Define rectangular region as [startingRow, startingColumn, endingRow, endingColumn].
    
    %UPPER PART
    [sR sC eR eC] = deal(1,1,rows,cols);
    regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC);
    up_hist(n)=regionSum;

end


%***+ CHECKING WITH MATLAB FUNCTIONS *****

[counts,edges]=histcounts(im,num_bins);

% %should print a '1' for each correct integralImage ==> they are all '1'
% so it computes correct 

% for i=1:num_bins
%     a=I_b_cell{1,n};
%     b=integralImage(a);
%     c=J_cell{1,n};
%     isequal(b,c);
% end