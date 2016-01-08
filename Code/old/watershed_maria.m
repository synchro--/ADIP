% grad= get_gradient_density('im_larger.jpg',0)
% grad= medfilt2(grad, [5 5])


% grad=uint8(grad);
figure, imshow(grad);
min_val= min(grad(:));
max_val= max(grad(:));
grey_levels=[min_val:1:max_val]




% % I=get_gradient_density(image,0); % image is re-read inside
% 
% figure(1),imshow(uint8(I))
% 
level_thr=graythresh(grad);
BW=im2bw(grad,level_thr);
>>>>>>> 2334a9a6ec987559e1287b1464cbaeb3912d0e02
%  BW=medfilt2(BW, [5 5])
figure(2), imshow(BW); title('output im2bw')


% % if we delete this part the watershed will be implemented inside the
% % contour 
% % but we want background= white and image=black
C=BW; % we want our cuntour to be the background.. so now the contours are white and the rest black
D=-bwdist(C);
max_val_D=max(D(:));
min_val_grad=min_val; 
thr=112; % maximum was 115, so we are taking a few seeds. 79 for im_larger if thr=110
[seed_r,seed_c]=find(D>thr&im==min_val); % locations of the seeds which are far enough and have minimum intensity value
% seeds: vector of positions of seeds

D(C)=-Inf; % BG PIXELS AND THE EXTENDED MAXIMA PIXELS ARE FORCED TO BE THE ONLY LOCAL MINIMA OF THE IMAGE
L=watershed(D);

% %%%%%%%%%%%%%%% WATERSHED
% for int_level=min_val:max_val % goes layer by layer through the topographic image along all the intensity values
%     cojo un vector con todos los valores
%     seeds(int_level)
%     
%     
%     
% end

white1=ones(size(grad));
white1(L==0)=0;
imshow(uint8(white1))


