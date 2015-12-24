I1 = imread('C:\Users\Maria\Documents\GitHub\ADIP\images\101087_larger.jpg');
[hog1, visualization] = extractHOGFeatures(I1,'CellSize',[32 32]);
subplot(1,2,1);
imshow(I1);
subplot(1,2,2);
plot(visualization,XY);
