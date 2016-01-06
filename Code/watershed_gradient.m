clc
figure(1)
clf

% nhood = strel([1 1 1; 1 1 1; 1 1 1]);
%
%   Read the image and prepare it to be a seed
%
imorig = imread('Images/im_larger.jpg');   % Read the image
im=get_gradient_density(imorig, 0);
% im = imorig(:,:,3);  % Blue channel
% figure,imshow(im);
% Crop it, useful for debugging purporses
% im = im(180:350, 1040:1350);
% im = max(max(im))-im;           % We will work with a negative image
%                                 so cells are dark (minima)
%% (MARIA) I wanna try to use the gradient
figure,imshow(im)


%%
%   Get some useful parameters of the image
imin = min(min(im));
imax = max(max(im));
[imheight, imwidth] = size(im);

%   Initializes the catchment basins
CB = bwlabel(im < imin+1);   % C[min+1] = T[min+1]

for n=imin+1:imax; % trabajas un nivel por encima
    tic
    %   Labels the new basements (to get the set Q)
    Q  = bwlabel(im <= n); % matrix of 1s and 0s?? NO! as many labels as seeds
    NQ = max(max(Q)); % number of regions/connected componnents 

    %   For each element q in Q
    for q=1:NQ;
        % Find how many (if any) connected components of CB are
        % intersected/ touching each other?
        newq  = (Q==q) & (CB > 0);  % newq: intersection
        nqint = get_number_list(CB(newq)); % different values inside nqint
    
        % Different scenarios are treated now:
        %
        % 1) q does not intersect C[n-1]:
        %   a new catchment basin is found so add it to CB
        if(length(nqint)==0)
            CBnplus1 = CB + (max(max(CB))+1)*(Q==q);
        % 2) q intersects one and only one region in C[n-1]:
        %   grow CB with the new points found in q
        elseif(length(nqint)==1),
            CBnplus1 = CB + nqint*((Q==q) & (CB==0));
        % 3) q intersects more than one region in C[n-1]:
        %   two catchment basins merge, a ridge must be found
        else
            [CBnplus1, dam] = grow_regions_inside_Q2(CB, Q==q);
        end;
        CB = CBnplus1;
    end;
    toc
    
    figure(1)
    subplot(2,1,2)
    imshow(Q);
    subplot(2,1,1)
    imshow(1+CB, jet(max(max(CB))+1));
    title(sprintf('Level %d between %d and %d (%d regions)', ...
                    n, imin, imax+1, max(max(CB))));
    pause(1e-3);
end;