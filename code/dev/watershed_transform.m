function segmented = watershed_transform(img_orig,grad)
% Compute the watershed transform of the input image.
% Developed following the theory of the book from Gonzalez: "Digital Image Processing"
%
% Author: Ali Alessio Salman, Marìa Silos Viu

tic

grad_orig=grad; %saved to be compared with the final result later

%Thresholding
% thresh=7;
% grad(grad<thresh)=0;

%%%%FILTERING%%%%
%to further remove noise we filter the image
%laplacian filter
%h2 = fspecial('laplacian');
%grad=imfilter(grad,h2);

%gaussian filter
% h2 = fspecial('gaussian', 3, 2) ;
% gauss=imfilter(grad,h2);
% borders=grad-gauss;
% %enhancement
% grad=grad+0.3*(borders);


% %median filter
% for i=1:3
% grad= medfilt2(grad, [5 5]);
% end

%sgolay filter
%grad=sgolayfilt(grad,2,7);


% im = max(max(im))-im;           % We will work with a negative image
% so cells are dark (minima)

%   Get some useful parameters of the image
imin = min(min(grad));
imax = max(max(grad));
[imheight, imwidth] = size(grad);

raws=size(grad,1);
cols=size(grad,2);
%   Initializes the catchment basins
CB  = bwlabel(grad < imin+1);   % C[min+1] = T[min+1]

%threshold = threshold + 120;

% Initializing dam vector
dam = zeros(size(CB));

%setting the threshold after which no more CB can be added
threshold = graythresh(uint8(grad));

for n=imin+1:imax+1;
    
    %   Labels the new basements (to get the set Q)
    Q  = bwlabel(grad <= n);
    NQ = max(max(Q));
    
    %   For each element q in Q
    for q=1:NQ;
        % Find how many (if any) connected components of CB are intersected
        newq  = (Q==q) & (CB > 0);
        nqint = get_number_list(CB(newq)); % intersecting regions
        
        % Different scenarios are treated now:
        %
        % 1) q does not intersect C[n-1]:
        %   a new catchment basin is found so add it to CB
        if(length(nqint)==0),
            if(min(min(grad(Q==q))) < threshold),
                CBnplus1 = CB + (max(max(CB))+1)*(Q==q);
            end;
            % 2) q intersects one and only one region in C[n-1]:
            %   grow CB with the new points found in q
        elseif(length(nqint)==1),
            CBnplus1 = CB + nqint*((Q==q) & (CB==0));
            % 3) q intersects more than one region in C[n-1]:
            %   two catchment basins merge, a ridge must be found
        else
            [CBnplus1, tdam] = grow_regions_inside_Q(CB, Q==q);
            dam = dam | tdam; % we add the new dam (tdam) drawn
        end;
        CB = CBnplus1;
    end;
    
    %     CB_2=remove_small_regions(CB,20)
    figure(6);
    %         subplot(2,1,2)
    %         imshow(Q);
    %         imshow(uint8(grad));
    %         subplot(2,1,1)
    imshow(1+CB, jet(max(max(CB))+1));
    title(sprintf('Level %d between %d and %d (%d regions)', ...
        n, imin,floor(imax+1), max(max(CB))));
    pause(1e-3);
end;

%close(fig6);

figure(),
subplot(1,2,1)
imshow(uint8(img_orig))
title('Original Image')
subplot(1,2,2)
imshow(uint8(medfilt2(grad_orig,[5 5])))
title('Contours, Median filter')

%subplot(1,2,1)
figure()
imshow(CB, jet(max(max(CB))));

figure()
%subplot(1,2,2)
segmented=ones(size(CB));
segmented(dam>0)=0;
%imshow(segmented);
%title('Segmented Image')
toc
end