function [img1_transparant,img2_transparant] = detectTransparent(img1, img2)

load ('mug_points.mat');

% extract p1 and p2 from pts

H2to1 = computeH(p1,p2);
% get height and width of two images
height1=size(img1,1);
width1=size(img1,2);
height2=size(img2,1);
width2=size(img2,2);
% right-up corner of warped image
rightUpCorner=(H2to1*[width2;1;1]);
rightUpCorner=rightUpCorner./rightUpCorner(3);
% right-down corner of warped image
rightDownCorner=(H2to1*[width2;height2;1]);
rightDownCorner=rightDownCorner./rightDownCorner(3);
% left-up corner of warped image
leftUpCorner=(H2to1*[1;1;1]);
leftUpCorner=leftUpCorner./leftUpCorner(3);
% left-down corner of warped image
leftDownCorner=(H2to1*[1;height2;1]);
leftDownCorner=leftDownCorner./leftDownCorner(3);
% width and height of the final image
maxwidth=max([rightUpCorner(1),rightDownCorner(1),width1]);
minwidth=min([leftUpCorner(1),leftDownCorner(1),0]);
width=maxwidth-minwidth;
maxheight=max([leftDownCorner(2),rightDownCorner(2),height1]);
minheight=min([rightUpCorner(2),leftUpCorner(2),0]);
height=maxheight-minheight;

% scale
scale=1280/width;
out_size = round(scale*[height,width]);
% Define a function to create an affine scaling matrix
Scalef = @(s)([ s 0 0; 
                0 s 0;
                0 0 1]);
Transf = @(tx,ty)([1 0 tx; 
                   0 1 ty;
                   0 0 1]);
% Finally get the M
M = Transf(-scale*minwidth,-scale*minheight)*Scalef(scale);

warp_img1=warpH(img1, M, out_size,0);
warp_img2=warpH(img2, M*H2to1, out_size,0);

% calculate mask
mask = zeros(size(warp_img1,1), size(warp_img1,2));
mask(~(warp_img1(:,:,1)==0 & warp_img1(:,:,2)==0 &warp_img1(:,:,3)==0))=1;
left=round(scale*width1);
mask = bsxfun(@times,mask,[linspace(1,0,left) zeros(1,size(warp_img2,2)-left)]);
temp=warp_img2(:,:,1)==0 & warp_img2(:,:,2)==0 &warp_img2(:,:,3)==0;
se = strel('disk',20);   
temp=imdilate(temp,se);
mask(mask~=0&temp)=1;

%get panoImage
panoImg=uint8(bsxfun(@times,mask,double(warp_img1))+bsxfun(@times,(1-mask),double(warp_img2)));

%find mug
Img_mug =panoImg-warp_img2;

%make image fluent
im_gray=rgb2gray(Img_mug);
sigma = 2;
gausFilter = fspecial('gaussian',[6 6],sigma);
im_gray=imfilter(im_gray,gausFilter,'replicate');

%paint gray
index_transparant = find(im_gray>20);
secImg_R = warp_img1(:,:,1);
secImg_G = warp_img1(:,:,2);
secImg_B = warp_img1(:,:,3);
secImg_R(index_transparant) = 150;
secImg_G(index_transparant) = 150;
secImg_B(index_transparant) = 150;
warp_img1_gray(:,:,1)=secImg_R;
warp_img1_gray(:,:,2)=secImg_G;
warp_img1_gray(:,:,3)=secImg_B;

%get the result
M_inv = inv(M);
out_size = size(img1);
img1_transparant = warpH(warp_img1_gray, M_inv, out_size,0);

%find mug
sec2Img =panoImg-warp_img1;

%make image fluent
im_gray=rgb2gray(sec2Img);
sigma = 2;
gausFilter = fspecial('gaussian',[6 6],sigma);
im_gray=imfilter(im_gray,gausFilter,'replicate');

%paint gray
index_transparant = find(im_gray>20);
secImg_R = warp_img2(:,:,1);
secImg_G = warp_img2(:,:,2);
secImg_B = warp_img2(:,:,3);
secImg_R(index_transparant) = 150;
secImg_G(index_transparant) = 150;
secImg_B(index_transparant) = 150;
warp_img2_gray(:,:,1)=secImg_R;
warp_img2_gray(:,:,2)=secImg_G;
warp_img2_gray(:,:,3)=secImg_B;

%get the result
out_size = size(img2);
img2_transparant = warpH(warp_img2_gray, inv(M*H2to1), out_size,0);

end
