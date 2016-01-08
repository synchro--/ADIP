

tic
%Initial conditions
%in this way is independent from the OS and the current file system 
%pwd specify the current directory and filesep is '\' on windows and '/' on Linux 
%has to be run inside ADIP directory
root_path = pwd;
path_im=[root_path filesep 'Images' filesep]; 
image = 'im_larger.jpg'; % image has to be inside Images folder
im=imread([path_im image]);
%  im=imrotate(im,45);% for the gradient in the 45 direction. It gives worst
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

% Getting each I_b
[I_b_cell,edges]=compute_histogram_bins(im,num_bins); % size(I_b_cell) = 1x20, % size(edges)= 1x21
% Integral images of each bin
J=cell(1,num_bins);
for i=1:num_bins
    J{1,i}=integralImage(I_b_cell{1,i}); % J-> cell of size= 1 x number of(integral images) = 1 x num_bins
    % J(i)= one image
end
% Histograms of the central part (without taking into account the 5 pixels
% borders)
for r=5:rows-5
    for c=5:cols-5
        % Check bin to which (r,c) belongs 
        for i=1:length(edges)-1
           if im(r,c)>edges(i) && im(r,c)<=edges(i+1)
               bin_val=i;
%                str=num2str(bin_val)
%                fprintf(str)
%                fprintf('\n')
           end
        end
        
%         % Upper rectangle
%         [uL_1 uR_1 lL_1 lR_1]=deal([r-4,c-4],[r-4, c+5],[r,c-4],[r,c+5]);
%         rect_1=[uL_1 uR_1 lL_1 lR_1];
        [sR_1 sC_1 eR_1 eC_1] = deal(r-4,c-4,r,c+5);
        regionSum_1 = J(eR_1+1,eC_1+1) - J(eR_1+1,sC_1) - J(sR_1,eC_1+1) + J(sR_1,sC_1);
        
%         % Lower rectangle 
%         [uL_2 uR_2 lL_2 lR_2]=deal([r,c-4],[r, c+5],[r+5,c-4],[r+5,c+5]);
%         rect_2=[uL_2 uR_2 lL_2 lR_2];
        [sR_2 sC_2 eR_2 eC_2] = deal(r+1,c-4,r+5,c+5);
        regionSum_2 = J(eR_2+1,eC_2+1) - J(eR_2+1,sC_2) - J(sR_2,eC_2+1) + J(sR_2,sC_2);
        
        
%         % This is not necessary... 
%         bins_1=[];
%         for l=1:length(rect_1)
%            for i=1:length(edges)-1
%                if im(rect_1(l))>edges(i) && im(rect_1(l))<=edges(i+1)
%                    bins_1(l)=i; % bins_1: bins in which each point of rect_1 falls
%                end
%            end
%         end
%         bins_2=[];
%         for l=1:length(rect_2)
%             for i=1:length(edges)-1
%                if im(rect_2(l))>edges(i) && im(rect_2(l))<=edges(i+1)
%                    bins_2(l)=i;% bins_2: bins in which each point of rect_2 falls
%                end
%            end
%         end
        
%         [J_uL_1,J_uR_1,J_lL_1,J_lR_1]=deal(J{1,bin_val},J{1,bins_1(2)},J{1,bins_1(3)},J{1,bins_1(4)});
%         [J_uL_2,J_uR_2,J_lL_2,J_lR_2]=deal(J{1,bins_2(1)},J{1,bins_2(2)},J{1,bins_2(3)},J{1,bins_2(4)});
%         h_b_1=J_uL_1(uL)+J{1,bins_1(2)}-J{1,bins_1(3)}-J{1,bins_1(4)}; % energy of (r,c)
%         h_b_2=J{1,bins_2(1)}+J{1,bins_2(2)}-J{1,bins_2(3)}-J{1,bins_2(4)};
        
%         J_b=J{1,bin_val};
%         h_b_1=J_b(uL_1(1,1),uL_1(1,2))+J_b(uR_1(1,1),uR_1(1,2))-J_b(lL_1(1,1),lL_1(1,2))-J_b(lR_1(1,1),lR_1(1,2))
%         h_b_2=J_b(uL_2(1,1),uL_2(1,2))+J_b(uR_2(1,1),uR_2(1,2))-J_b(lL_2(1,1),lL_2(1,2))-J_b(lR_2(1,1),lR_2(1,2))
        sum_val_x=(regionSum_1-regionSum_2).^2./(regionSum_1+regionSum_2);
        gradient_magnitude_x=0.5*sum_val_x;
        
        
        % Max val of both
%         gradient_dens_max(r,c)=max(gradient_magnitude_x, gradient_magnitude_y);
        gradient_dens_max(r,c)=gradient_magnitude_x;
%         gradient_dens_x(r,c)=gradient_magnitude_x;
%         gradient_dens_y(r,c)=gradient_magnitude_y;
%           % For 45º degrees: 
%           gradient_dens_max(r,c)=gradient_magnitude_x;
    end
end

imshow(uint8(gradient_dens_max))
toc
