function I_b_array = compute_histogram_bins(im,num_bins)
rows=size(im,1);
cols=size(im,2);
I_b_array=zeros(num_bins,rows,cols);

[N,edges]=histcounts(im,num_bins);
disp(N);

for n=1:num_bins
    for i=1:rows
        for j=1:cols
            
%             if n == 1
%                 if im(i,j) < edges(n)
%                     I_b_array(n,i,j)=1;
%                 end
%             else
                if im(i,j) < edges(n+1) && im(i,j) > edges(n)
                    I_b_array(n,i,j)=1;
                end
%             end
        end
    end
end
end