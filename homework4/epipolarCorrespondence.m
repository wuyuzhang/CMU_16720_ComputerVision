function [x2, y2] = epipolarCorrespondence(im1, im2, F, x1, y1)
% this function is used to compute location of image1's x,y in image2
% im1 and im2 are two images
% F is the fundamental matrix
% x1 and y1 are coordinate of one point in image1

% compute the epipolar line
p1 = [x1; y1; 1];
line1 = F*p1;
scale = sqrt(line1(1)^2 + line1(2)^2);
line1 = line1/scale;

% find approximate point
line2=[-line1(2),line1(1),line1(2)*x1-line1(1)*y1]';
proj=round(cross(line1,line2));  

% preparation for computing difference
windowsize=10;
paraSize = 2*windowsize+1;
mask1 = double(im1((y1-windowsize):(y1+windowsize), (x1-windowsize):(x1+windowsize)));
minerror=1000;
sigma = 3;
weight = fspecial('gaussian', [paraSize paraSize], sigma);

% compute the difference and find the most probable point
for j = proj(2)-20:proj(2)+20 
    mask2 = double(im2(j-windowsize:j+windowsize,proj(1)-windowsize:proj(1)+windowsize));
    distance = mask1 - mask2;
    error = norm(weight .* distance); 
    if error<minerror
        minerror=error;
        x2=proj(1);
        y2=j;
    end
end

end