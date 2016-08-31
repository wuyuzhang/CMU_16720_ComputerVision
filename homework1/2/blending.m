function [H2to1, panoImg] = blending(img1, img2, pts)

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

%get the warped image
img1=warpH(img1, M, out_size,0);
img2=warpH(img2, M*H2to1, out_size,0);

% calculate mask
mask = zeros(size(img1,1), size(img1,2));
mask(~(img1(:,:,1)==0 & img1(:,:,2)==0 &img1(:,:,3)==0))=1;
%make the value of the overlap increase linerly with the increase of the
%distance from the boundary
mask = bsxfun(@times,mask,[linspace(1,0,round(scale*width1)) zeros(1,size(img2,2)-round(scale*width1))]);
temp=img2(:,:,1)==0 & img2(:,:,2)==0 &img2(:,:,3)==0;
%use a model of morphology operation to make it fused(expansion)
se = strel('diamond',10);   
temp=imdilate(temp,se,'same');
mask(mask~=0&temp)=1;

panoImg=uint8(bsxfun(@times,mask,double(img1))+bsxfun(@times,(1-mask),double(img2)));

end
