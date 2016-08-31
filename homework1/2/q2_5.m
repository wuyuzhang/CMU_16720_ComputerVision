function [H2to1,panoImg] = q2_5(img1, img2, pts)

% extract p1 and p2 from pts
p1=pts(1:2,:);
p2=pts(3:4,:);
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

% get warped images
img1 = double(img1);
img2 = double(img2);
warp_img1 = warpH(img1, M, out_size, [0 0 0]);
warp_img2 = warpH(img2, M*H2to1, out_size,[0 0 0]);

%image blending
%first use the blending method listed
mask = zeros(size(img1,1),size(img1,2));
mask(1,:) = 1; mask(end,:) = 1; mask(:,1) = 1; mask(:,end) = 1;
mask = bwdist(mask, 'city');
mask = mask/max(mask(:)); 
%warp mask using M
mask = warpH(mask,M,out_size,0);

%get the R,G,B values of warped img1 and img2
warp_im1_R = warp_img1(:,:,1);
warp_im1_G = warp_img1(:,:,2);
warp_im1_B = warp_img1(:,:,3);
warp_im2_R = warp_img2(:,:,1); 
warp_im2_G = warp_img2(:,:,2);
warp_im2_B = warp_img2(:,:,3);

%find the overlap area of img1 and warped img2
ind1 = warp_im1_R~=0 & warp_im1_G~=0 & warp_im1_B~=0; 
mask_img1 = zeros(size(warp_img1,1),size(warp_img1,2));
mask_img1(ind1) = 1;

ind2 = warp_im2_R~=0 & warp_im2_G~=0 & warp_im2_B~=0; 
mask_img2 = zeros(size(warp_img2,1),size(warp_img2,2));
mask_img2(ind2) = 1;

mask_overlap = mask_img1 & mask_img2;
ind_lap = mask_overlap == 1;

%Create a mask of panoImg
mask_pano = ones(size(warp_img1,1),size(warp_img1,2));
mask_pano(ind_lap) = mask(ind_lap);
mask2_only = bitxor(mask_overlap, mask_img2);
mask1_only = bitxor(mask_overlap, mask_img1);
ind_img1 = mask1_only ~=0;
ind_img2 = mask2_only ~= 0;
mask_pano(ind_img1) = 1;
mask_pano(ind_img2) = 0;

%Create panorama image: mask_pano.*img1+ (1-mask_pano).*warpedImg
panoImg_R = mask_pano.*warp_im1_R + (warp_im2_R-mask_pano.*warp_im2_R);
panoImg_G = mask_pano.*warp_im1_G + (warp_im2_G-mask_pano.*warp_im2_G);
panoImg_B = mask_pano.*warp_im1_B + (warp_im2_B-mask_pano.*warp_im2_B);
panoImg_R_medfilt =medfilt2(panoImg_R,[2,2]);
panoImg_G_medfilt =medfilt2(panoImg_G,[2,2]);
panoImg_B_medfilt =medfilt2(panoImg_B,[2,2]);
panoImg(:,:,1)=panoImg_R_medfilt;
panoImg(:,:,2)=panoImg_G_medfilt;
panoImg(:,:,3)=panoImg_B_medfilt;

panoImg = uint8(panoImg);

end