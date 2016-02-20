function I_b_cell = compute_histogram_bins(im,num_bins)
% Following the paper from Arbelaez et al. this function compute the
% histogram matrices to leverage on the powerful integral image
% computation.
% Let im denote the rotated intensity image and let I_b(i,j) be:
% 1 if im(i,j) falls in histogram bin b,
% 0 otherwise.
%
%   Input:  the image and the number of requested bins
%   Output: a cell where each element is one of these histogram matrix I_b


rows=size(im,1);
cols=size(im,2);
I_b_cell=cell(1,num_bins);
[I_b_cell{:}] = deal(zeros(rows,cols));

[N,edges]=histcounts(im,num_bins);
%[N,edges]=imhist(im,num_bins); %imhist uses a special internal structure to divide the bins that
%doesn't apply well for this task.
%disp(N);

% Let im denote the rotated intensity image and let I_b(x, y) be 1 if im(x,y)
% falls in histogram bin b and 0 otherwise.
for n=1:num_bins
    I_b=I_b_cell{1,n};
    %filling the I_b matrix
    for i=1:rows
        for j=1:cols
            %n+1 -> n  histcounts -> imhist
            if im(i,j) <= edges(n+1) && im(i,j) > edges(n)
                I_b(i,j)=1;
            end
        end
    end
    %saving the matrix in the cell
    I_b_cell{1,n}=I_b;
end

end