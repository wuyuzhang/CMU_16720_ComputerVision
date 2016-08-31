function warp_im = warpImage(inputImage, H)
% warpA is an affine warping function using nearest sampling
% im is the original gray image
% A is the affine transformation matrix
% out_size is the size of output image

% height is the number of rows in image
% width is the number of columns in image
[im_height, im_width] = size(inputImage);
out_size = [size(inputImage,1) size(inputImage,2)];
out_height = im_height;
out_width  = im_width;
warp_im = zeros(out_size);
[X, Y] = meshgrid(1:out_width,1:out_height);
X=X(:);
Y=Y(:);

% destination cordinates
des_cord = [X'; Y'; ones(1,prod(out_size))]; 

% original cordinates
H_inv = inv(H);
ori_cord = round(H_inv * des_cord);

%ensure not cross the border
ind = find(ori_cord(1,:) >= 1 & ori_cord(2,:) >= 1 & ori_cord(1,:) <= im_width & ori_cord(2,:) <= im_height);

%get the result
warp_im(ind)=inputImage(sub2ind(size(inputImage),ori_cord(2,ind),ori_cord(1,ind)));
end