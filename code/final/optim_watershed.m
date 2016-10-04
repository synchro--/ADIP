tic
close all
clc
figure(1)
clf

nhood = strel([1 1 1; 1 1 1; 1 1 1]);
%
%   Read the image and prepare it to be a seed
%
% imorig = imread('Images/cells_filter.jpg');   % Read the image

% im = imorig(:,:,3);             % Blue channel
% Crop it, useful for debugging purporses
% im = im(180:350, 1040:1350); 
% grad=get_gradient_density(im,0);
%%%%%%%%%%%%%%%%%% new part
img_name = 'im_larger.jpg';

orientations = [45 125];
tic
%call
[imorig,norm_grad]=compute_norm_histogram(img_name);
grad45=compute_oriented_hist(img_name,orientations(1)); 
grad125=compute_oriented_hist(img_name,orientations(2));

%grad45=grad45;
close all
grad=merge_grad_func(norm_grad,grad45,grad125);


%%
%%%%FILTERING%%%% 
%to further remove noise we filter the image 
%laplacian filter
%h2 = fspecial('laplacian');

%gaussian filter
h2 = fspecial('gaussian', 3, 2) ;
gauss=imfilter(grad,h2);
borders=grad-gauss;
%enhancement 
grad=grad+0.8*(borders);
%grad=imfilter(grad,h2);

%median filter
grad= medfilt2(grad, [5 5]);


% loop only on the values actually present in the gradient
raws=size(grad,1);
cols=size(grad,2);
grad_array=grad(grad>0);
grad_array=unique(grad_array);
grad_sort=sort(grad_array);

%imin and imax are indexes of the array of the stages
imin = 1;
imax = length(grad_sort);
[imheight, imwidth] = size(grad);


stages=[];
stages(1)=1;
step=200;
counts=2;

for i=1:step:imax
    stages(1,counts)=grad_sort(i); 
    counts=counts+1;
end    

len=length(stages); 
stages(1,len+1)=max(max(grad_sort));

%stages(1,imax+2)=max(max(grad_sort)); 
imax=length(stages);


%   Initializes the catchment basins
CB  = bwlabel(grad < stages(imin));   % C[min+1] = T[min+1]

% Initializing dam vector
dam = zeros(size(CB));

%setting the threshold after which no more CB can be added
threshold = 80;

%  imin = min(min(grad));
%  imax = max(max(grad));

for index=imin:imax
%for n=imin+1:imax+1;
    n=stages(index);
    %disp(n);
    %   Labels the new basements (to get the set Q)
    Q  = bwlabel(grad <= n);
    NQ = max(max(Q));

    %   For each element q in Q
    for q=1:NQ;
        % Find how many (if any) connected components of CB are intersected
        newq  = (Q==q) & (CB > 0);         % x min x  de Q==q max... recortar CB y trabajar con un CB temporal
        nqint = get_number_list(CB(newq)); % intersecting regions
    
        % Different scenarios are treated now:
        %
        % 1) q does not intersect C[n-1]:
        %   a new catchment basin is found so add it to CB
        if(length(nqint)==0),
            if(min(min(grad(Q==q))) < threshold),
                CBnplus1 = CB + (max(max(CB))+1)*(Q==q); % cb crop
            end;
        % 2) q intersects one and only one region in C[n-1]:
        %   grow CB with the new points found in q
        elseif(length(nqint)==1),
            CBnplus1 = CB + nqint*((Q==q) & (CB==0));
        % 3) q intersects more than one region in C[n-1]:
        %   two catchment basins merge, a ridge must be found
        else
            [CBnplus1, tdam] = grow_regions_inside_Q2(CB, Q==q);
            dam = dam | tdam; % we add the new dam (tdam) drawn
        end;
        CB = CBnplus1;
    end;
    
%     CB_2=remove_small_regions(CB,20)
    figure(1)
%     subplot(2,1,2)
%     imshow(Q);
%     imshow(uint8(grad));
%     subplot(2,1,1)
    imshow(1+CB, jet(max(max(CB))+1));
    title(sprintf('Level %d between %d and %d (%d regions)', ...
                    n, imin, imax+1, max(max(CB))));
    pause(1e-3);
end;

figure(2),
subplot(1,2,1)
imshow(uint8(imorig))
title('Original Image')
subplot(1,2,2)
imshow(uint8(grad))
title('Contours, Median filter')

%subplot(1,2,1)
figure()
imshow(CB, jet(max(max(CB))));

figure()
%subplot(1,2,2)
white1=ones(size(CB));
white1(dam>0)=0;
imshow(white1)
title('Segmented Image')
toc
