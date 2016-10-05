function final_grad = merging_gradient(gmax,r45,r125)
% Merges the gradients that are given as input taking into account all the
% differences in size and cropping those in a symmetric way to make them all
% match.
% Output: final_grad - single image where the edges according to all the gradient
% in input are enhanced.
%
% Author: Ali Alessio Salman

% load and save if you want to speed up the computation on the same image
% load rotate125.mat
% load rotate45.mat
% load xy.mat

%%%%%%post-processing each gradient alone here%%%%%
%median filtering
% r45=medfilt2(r45,[3 3]);
% r125=medfilt2(r125,[3 3]);
% gmax=medfilt2(gmax,[3 3]);

%sgolay filtering
% r45=sgolayfilt(r45,3,7);
% r125=sgolayfilt(r125,3,7);
% gmax=sgolayfilt(gmax,3,7);

%threshold filtering
thresh=8;
r45(r45<thresh)=0;
r125(r125<thresh)=0;
gmax(gmax<thresh)=0;


%r125 r45 gmax
%difference between the image divided by 2
diff45_row=(size(r45,1)-size(gmax,1))/2;
diff45_col=(size(r45,2)-size(gmax,2))/2;
diff125_row=(size(r125,1)-size(gmax,1))/2;
diff125_col=(size(r125,2)-size(gmax,2))/2;

%setting the same size and merge the gradients
rows=size(r45,1);
cols=size(r45,2);
grad45=r45(diff45_row:rows-(diff45_row+1) , diff45_col:cols-(diff45_col+1));

rows=size(r125,1);
cols=size(r125,2);
grad125=r125(diff125_row:rows-(diff125_row+1) , diff125_col:cols-(diff125_col+1));

tmp=max(grad45,grad125);
final_grad=max(gmax,tmp);
figure();
imshow(uint8(final_grad)),title('Oriented Gradient');

% uncomment if you wanna try some post-processing on the resulting gradient
% before computing the watershed transform (see main.m)

% %%%%final post-processing %%%%%
% sgo_grad=sgolayfilt(final_grad,2,7);
% median_grad=medfilt2(final_grad,[3 3]);
% median_grad(median_grad<thresh)=0;


% figure(1)
% imshow(uint8(median_grad));
% title('Median filter');

% figure(2)
% imshow(uint8(sgo_grad));
% title('Sgolay filter');