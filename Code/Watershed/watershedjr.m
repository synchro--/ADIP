clc
figure(1)
clf

nhood = strel([1 1 1; 1 1 1; 1 1 1]);
%
%   Read the image and prepare it to be a seed
%
imorig = imread('images/cells_filter.jpg');   % Read the image
im = imorig(:,:,3);             % Blue channel
% Crop it, useful for debugging purporses
im = im(180:350, 1040:1350);

im = max(max(im))-im;           % We will work with a negative image
                                % so cells are dark (minima)

%   Get some useful parameters of the image
imin = min(min(im));
imax = max(max(im));
[imheight, imwidth] = size(im);

%   Initializes the catchment basins
CB = bwlabel(im < imin+1);   % C[min+1] = T[min+1], we have a label for each connected components, labels are numbers 1s,2s, and so on


for n=imin+1:imax;
    tic
    %   Labels the new basements (to get the set Q)
    Q  = bwlabel(im <= n);
    NQ = max(max(Q)); %number of connected component i.e. the cardinality

    %   For each element q in Q
    for q=1:NQ;
        % Find how many (if any) connected components of CB are intersected
        newq  = (Q==q) & (CB > 0); %intersection between the 2 matrixes
        nqint = get_number_list(CB(newq)); %taking the label of the connected component in common
    
        % Different scenarios are treated now:
        %
        % 1) q does not intersect C[n-1]:
        %   a new catchment basin is found so add it to CB
        if(length(nqint)==0),
            CBnplus1 = CB + (max(max(CB))+1)*(Q==q);
            %We add to the matrix a new connected component labeled with a
            %new label=max+1, according to the stage we are processing
            
        % 2) q intersects one and only one region in C[n-1]:
        %   grow CB with the new points found in q
        elseif(length(nqint)==1),
            CBnplus1 = CB + nqint*((Q==q) & (CB==0));
            %nqint is there to have the right label
            %(Q==q) & CB==0 is the component that
            %isn't already present in CB, we put inside only that one not
            %other numbers! 
            
            
        % 3) q intersects more than one region in C[n-1]:
        %   two catchment basins merge, a ridge must be found
        else
            [CBnplus1, dam] = grow_regions_inside_Q(CB, Q==q);
        end;
        
        CB = CBnplus1; %C[n] = C[n+1]
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



