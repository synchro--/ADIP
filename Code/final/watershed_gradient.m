tic
close all
clc
figure(1)
clf

threshold = 200;
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
norm_grad=compute_norm_histogram(img_name);
grad45=compute_oriented_hist(img_name,orientations(1)); 
grad125=compute_oriented_hist(img_name,orientations(2)); 
close all
grad=merge_grad_func(norm_grad,grad45,grad125);
%%%%%%%%%%%%%%%%%%%




grad= medfilt2(grad, [3 3]);

% im = max(max(im))-im;           % We will work with a negative image
                                % so cells are dark (minima)

%   Get some useful parameters of the image
imin = min(min(im));
imax = max(max(im));
[imheight, imwidth] = size(grad);

raws=size(grad,1);
cols=size(grad,2);
%   Initializes the catchment basins
CB  = bwlabel(grad < imin+1);   % C[min+1] = T[min+1]

% Stablishing a neighbourhood of 20 pixels in which there will only be one
% seed 
% J=integralImage(CB);
% for r=10:raws-10
%     for c=10:cols-10
%         if CB(r,c)>0,
%             [sR sC eR eC] = deal(r-9,c-9,r+10,c+10);
%             regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC);
%             if regionSum~=CB(r,c)
%                 for i=-9:1:10
%                     for j=-9:1:10
%                         if CB(r+i,c+j)>0
%                             CB(r+i,c+j)=0;
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end

% Initializing dam vector
dam = zeros(size(CB));

for n=imin+1:imax+1;
    
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
subplot(1,3,1)
imshow(uint8(im))
title('Original Image')
subplot(1,3,2)
imshow(uint8(grad))
title('Contours')
subplot(1,3,3)
white1=ones(size(CB));
white1(dam>0)=0;
imshow(white1)
title('Segmented Image')
toc
