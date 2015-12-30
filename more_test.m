

%Initial conditions
image = 'C:\Users\Maria\Documents\GitHub\ADIP\images\101087_larger.jpg';
im= imread(image);
num_bins=20;
neighbors=5; % Number of neighbouring pixels

% Convert RGB image to grayscale
if size(im,3)==3
    im=rgb2gray(im);
end

rows=size(im,1);
cols=size(im,2);
up_hist=im; % Basic Matrix assignment of Upper Histogram
down_hist=im; % Basic Matrix assignment of Lower Histogram

gradient_dens=zeros(rows,cols);

% Histograms of the central part (without taking into account the 5 pixels
% borders)

for r=5:rows-5 
    for c=5:cols-5
        fprintf('raw= %d',r)
        fprintf('col= %d  \n',c)
        new_im_up=im(r-4:r,c-4:c+5); % cut the image in order to have the upper part
        [counts,~]=imhist(new_im_up,num_bins);
        up_hist= counts;
        new_im_down=im(r+1:r+5,c-4:c+5); % cut the image in order to have the lower part
        [counts,~]=imhist(new_im_down,num_bins);
        down_hist=counts;
        sum_val=0;
        for i=1:length(counts)
            sum_val= sum_val+(up_hist(i)-down_hist(i))^2/(up_hist(i)+down_hist(i));
        end
        gradient_dens(r,c)=0.5*sum_val;
    end
end

gauss=fspecial('gaussian',8,1); %% Initialized a gaussian filter with sigma=0.5 * block width.    

% % Remove redundant pixels in an image. 
gradient_dens(gradient_dens<10)=0;

% Show gradient
figure
imshow(uint8(gradient_dens));
title('gradient density')
