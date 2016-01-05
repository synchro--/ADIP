% Code implementing basic idea of the Arbelaez's algorithm 
function [gradient_dens_max]= get_gradient_density(im,debug)


% Authors: Ali Alessio Salman, Maria Silos

tic
%Initial conditions
%in this way is independent from the OS and the current file system 
%pwd specify the current directory and filesep is '\' on windows and '/' on Linux 
%has to be run inside ADIP directory
root_path = pwd;
path_im=[root_path filesep 'Images' filesep]; 
image = im;
im=imread([path_im image]);
%  im=imrotate(im,45);% for the gradient in the 45ï¿½ direction. It gives worst
% results and same efficiency
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
      % Oriented Histogram in X
      % fprintf('raw= %d',r)
      % fprintf('col= %d  \n',c)
        new_im_up=im(r-4:r,c-4:c+5); % cut the image in order to have the upper part
        [counts_x,~]=imhist(new_im_up,num_bins);
        counts_x(counts_x==0)=1; 
        up_hist= counts_x;
        new_im_down=im(r+1:r+5,c-4:c+5); % cut the image in order to have the lower part
        [counts_x,~]=imhist(new_im_down,num_bins);
        down_hist=counts_x;
%         counts_x(counts_x==0)=1; 
        % using this instead of a for loop change the results (don't know
        % why). And decrease the time 5 seconds
        sum_val_x=sum((up_hist-down_hist).^2./(up_hist+down_hist));
        gradient_magnitude_x=0.5*sum_val_x;
        
        % Oriented Histogram in Y
        new_im_left=im(r-4:r+5,c-4:c); % cut the image in order to have the left part
        [counts_y,~]=imhist(new_im_left,num_bins);
        counts_y(counts_y==0)=1; 
        left_hist= counts_y;
        new_im_right=im(r-4:r+5,c+1:c+5); % cut the image in order to have the right part
        [counts_y,~]=imhist(new_im_right,num_bins);
        right_hist=counts_y;
%         counts_y(counts_y==0)=1;
        sum_val_y= sum((left_hist-right_hist).^2./(left_hist+right_hist));
        gradient_magnitude_y=0.5*sum_val_y;
        
        % Max val of both
        gradient_dens_max(r,c)=max(gradient_magnitude_x, gradient_magnitude_y);
        gradient_dens_x(r,c)=gradient_magnitude_x;
        gradient_dens_y(r,c)=gradient_magnitude_y;
%           % For 45º degrees: 
%           gradient_dens_max(r,c)=gradient_magnitude_x;
    end
end

% % For 45º degrees:
% gradient_dens_max(gradient_dens_max==1)=0;
% % gauss=fspecial('gaussian',8,1); %% Initialized a gaussian filter with sigma=0.5 * block width.
% final=imrotate(gradient_dens_max,-45,'crop');
% % final=imcrop(final) % you have to manually crop the image 
% imshow(uint8(final));
% title('Gradient Density in 45')


if debug
    % Show gradients
    figure(1)
    subplot(1,3,1)
    imshow(uint8(gradient_dens_y));
    title('Gradient Density in Y')
    subplot(1,3,2)
    imshow(uint8(gradient_dens_x));
    title('Gradient Density in X ')
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
    title('filtered image_sgolayfilt')
    
end
gradient_dens_max(gradient_dens_max<20)=0;

toc
end
