
path=[pwd filesep 'Images' filesep 'maria_2.jpg'];
rgb=imread(path);
%rgb = imread('pears.png');
I = rgb2gray(rgb);
subplot(341);imshow(I),title('input image');
I_binary= im2bw(I,graythresh(I));
subplot(342);imshow(I_binary,[]), title('binary of input image)')
% I_watershed=watershed(I)
% figure, imshow(I_watershed), title('Watershed transform of original image')
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
%gradmag = sqrt(Ix.^2 + Iy.^2);
Im=double(I);
[ix,iy]=gradient(Im);
gradmag = sqrt(ix.*ix+iy.*iy);
gradmag = uint8(gradmag);
subplot(3,4,11);imshow(gradmag),title('gradmag');
% figure;imshow(gradmag,[]), title('Gradient magnitude (gradmag)')

% L_watershed_gradmag = watershed(gradmag);
% %L = label2rgb(L);
% figure, imshow(L_watershed_gradmag), title('Watershed transform of gradient magnitude')
% %RigionMin = imregionalmin(L_watershed_gradmag);
% RigionMin = imregionalmin(I);%??????? regionalmin
% figure;imshow(RigionMin ,[]), title('region minima')
% 
% RigionMin_modified=bwareaopen(RigionMin, 20);
% figure;imshow(RigionMin ,[]), title('modified region minima')
% 
% externalMakers=watershed(RigionMin);
% figure;imshow(externalMakers,[]), title('externalMakers')
%MakerImage = imimposemin(I_binary, RigionMin);
%figure;imshow(MakerImage,[]), title('MakerImage')


%% comput the background markers
% D = bwdist(RigionMin);
% %figure;imshow(D), title('D')
% DL = watershed(D);
% backMakers = DL == 0;
% figure;imshow(DL), title('Watershed ridge lines (bgm)')


%%
%Mark the Foreground Objects
se = strel('square', 3);
%Io = imopen(I, se);
%figure;imshow(Io), title('Opening (Io)')
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
%figure;imshow(Iobr), title('Opening-by-reconstruction (Iobr)')
%Ioc = imclose(Io, se);
% figure;imshow(Ioc), title('Opening-closing (Ioc)')
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
%???Calculate the regional maxima of Iobrcbr to obtain good foreground markers.
Iobrcbr = imcomplement(Iobrcbr);%Iobrcbr?????????????image??????????
subplot(343);imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')
%imreginalmax() ?????????8?????????????????1?????0
fgm = imregionalmin(Iobrcbr);
subplot(344);imshow(fgm), title('Regional minima of opening-closing by reconstruction (fgm)')
I2 = I;%(?????I?????????Iobrcbr?
I2(fgm) = 255;%??1???????255(regional minima?????)
%????I2????
subplot(345); imshow(I2), title('Regional minima  is tapped on original image (I2)')


%%---------------------?foreground Makers?? modify-------------------%%
%%-------------- ??????????-------------------------/
%?modified??fgb????????????modified???fgb?????????
se2 = strel(ones(2,2));
fgm2 = imopen(fgm, se2);
%fgm3 = imreconstruct(fgm2, fgm);  %??????Rigional minima?????
fgm3 = bwareaopen(fgm2, 5);
I3 = I;
I3(fgm3) = 255;% I3????????? regional minima,?????????? 

%subplot(346);imshow(fgm3);title('Modified regional maxima superimposed on original image (fgm4)')

%%
%Compute Background Markers
%bw1 = im2bw(Iobrcbr, graythresh(Iobrcbr));
bw1 = im2bw(I3, graythresh(I3)); %???(I2???????I)
%subplot(3,4,12);imshow(bw1),title('binary of I2')
D = bwdist(bw1);
DL = watershed(D);
bgm = DL == 0; %bgm????0????DL???0??????? bgm?1
fgm3(bgm)=255;
subplot(347); imshow(fgm3), title('bgm')
bw1(fgm3)=255;
subplot(346);imshow(bw1)

backMaker=watershed(im2bw(I2, graythresh(I2)));
subplot(348);imshow(backMaker),title('my_backMaker')
gradmag2 = imimposemin(gradmag,fgm|bgm);
gradmag2=uint8(gradmag2);
%subplot(3,4,12);imshow(gradmag2),title('gradmag2')
%gradmag2 = imimposemin(gradmag,fgm4);
subplot(3,4,12); imshow(gradmag2), title('gradmag2')
L = watershed(gradmag2);
subplot(349);imshow(label2rgb(L)),title('final result')
I4 = I;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm) = 255;
subplot(3,4,10);imshow(I4);title('Markers and object boundaries superimposed on original image (I4)')
% I5=I;
% I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;