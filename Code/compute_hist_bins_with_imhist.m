function I_b_cell = compute_histogram_bins(im,num_bins)
rows=size(im,1);
cols=size(im,2);
I_b_cell=cell(1,24);
[I_b_cell{:}] = deal(zeros(rows,cols));

[N,edges]=imhist(im,num_bins);
disp(N);

% Let im denote the rotated intensity image and let I_b(x, y) be 1 if im(x, y)
% falls in histogram bin b and 0 otherwise. 
for n=1:num_bins-1
    I_b=I_b_cell{1,n};
    disp(edges(n+1));
    disp(edges(n));
    %filling the I_b matrix
    for i=1:rows
        for j=1:cols

                if im(i,j) <= edges(n+1) && im(i,j) > edges(n)
                    I_b(i,j)=1;
                end            
        end
    end
    %saving the matrix in the cell
    I_b_cell{1,n}=I_b;
end
end