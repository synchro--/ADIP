load rotate125.mat
load rotate45.mat
load xy.mat

%%%%%%post-processing each gradient alone here%%%%%
%median filtering 
r45=medfilt2(r45,[3 3]);
r125=medfilt2(r125,[3 3]);
gmax=medfilt2(gmax,[3 3]);



%r125 r45 gmax 
diff45=(size(r45,1)-size(gmax,1))/2;
diff125=(size(r125,1)-size(gmax,1))/2;
%setting the same size and merge the gradients
rows=size(r45,1);
cols=size(r45,2); 
grad45=r45(diff45:rows-(diff45+1) , diff45:cols-(diff45+1));


rows=size(r125,1);
cols=size(r125,2); 
grad125=r125(diff125:rows-(diff125+1) , diff125:cols-(diff125+1));

tmp=max(grad45,grad125);
final_grad=max(gmax,tmp);
figure()
imshow(uint8(final_grad));

%%%%final post-processing %%%%%
sgo_grad=sgolayfilt(final_grad,2,7);
median_grad=medfilt2(final_grad,[3 3]);


figure()
imshow(uint8(sgo_grad));
title('median');

figure()
imshow(uint8(median_grad));
title('sgolay filter');