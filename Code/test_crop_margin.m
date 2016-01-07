im=imread('images/im_larger.jpg'); 
im=imrotate(im,-45);
im=imrotate(im,45);

tic
cropped=cropMargins(im);
toc
figure();
imshow(cropped); 