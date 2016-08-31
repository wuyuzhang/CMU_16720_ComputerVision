function warp_im = warpA(im, A, out_size)
% warpA is an affine warping function using nearest sampling
% im is the original gray image
% A is the affine transformation matrix
% out_size is the size of output image

% height is the number of rows in image
% width is the number of columns in image
[im_height, im_width] = size(im);
out_height = out_size(1);
out_width  = out_size(2);
warp_im = zeros(out_size);
[X, Y] = meshgrid(1:out_width,1:out_height);
X=X(:);
Y=Y(:);

% destination cordinates
des_cord = [X'; Y'; ones(1,prod(out_size))]; 

% original cordinates
A_inv = inv(A);
ori_cord = round(A_inv * des_cord);

%ensure not cross the border
ind = ori_cord(1,:) >= 1 & ori_cord(2,:) >= 1 & ori_cord(1,:) <= im_width & ori_cord(2,:) <= im_height;

%get the result
warp_im(sub2ind(out_size,Y(ind),X(ind)))=im(sub2ind(size(im),ori_cord(2,ind),ori_cord(1,ind)));
end