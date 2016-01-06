
clc
clear all
close all

image = ['images' filesep 'im_larger.jpg'];
im= imread(image);

% Option 1
% feature = hog_feature_vector(im);


% Option 2
[hog1, visualization] = extractHOGFeatures(im,'CellSize',[16 16]);
subplot(1,2,1);
imshow(im);
subplot(1,2,2);
plot(visualization);

%%
clc
close all
ret=get_gradient_density('im_larger.jpg',1); 
