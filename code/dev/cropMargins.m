function cropped=cropMargins(im)
I1=im;
sizeI = size(I1);
zeros = floor((sizeI(2) -  min(sum(any(I1))))/2);
I2 = I1(:, zeros : sizeI(2)-zeros, :);
nonZero = sum(any(I1,2));

sizeI2 = size(I2);
zerosRows = floor((sizeI(1) -  min(sum(any(I2, 2))))/2);
cropped = I2(zerosRows : sizeI2(1)-zerosRows, :, :);
end