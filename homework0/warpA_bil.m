function warp_im = warpA_bil( im, A, out_size )
% warpA is an affine warping function using bilinear sampling
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
descord = [X'; Y'; ones(1,prod(out_size))]; 

% original cordinates
A_inv = inv(A);
oricord = A_inv*descord;

% ensure not cross the border
ind = oricord(1,:) >= 1 & oricord(2,:) >= 1 & oricord(1,:) <= im_width & oricord(2,:) <= im_height;

% adjust the cordinates to expanded image
oriX = oricord(1,ind);
oriY = oricord(2,ind);

preX = floor(oriX);
postX= ceil(oriX);

delta = oriY - floor(oriY);

% biliner interpolation
leftUpValue = im(sub2ind(size(im),floor(oriY),preX));
leftDownValue = im(sub2ind(size(im),ceil(oriY),preX));
leftValue = leftUpValue.*(1-delta)+delta.*leftDownValue;


rightUpValue = im(sub2ind(size(im),floor(oriY),postX));
rightDownValue = im(sub2ind(size(im),ceil(oriY),postX));
rightValue = rightUpValue.*(1-delta) + delta.*rightDownValue;

delta = oriX - floor(oriX);
value = leftValue.*(1-delta) + rightValue.*delta;

% get the result
warp_im(sub2ind(out_size,Y(ind),X(ind)))=value;
end