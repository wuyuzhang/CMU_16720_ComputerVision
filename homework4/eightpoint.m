function F = eightpoint(pts1, pts2, M)
% this function is used to compute F
% F is the fundamental matrix
% pts1 and pts2 are corresponding coordinates in the two images
% M is a scale parameter

% normalize the two coordinates
norm1 = pts1 ./ M;
norm2 = pts2 ./ M;

% find coordinaing points
x1 = norm1(:,1);
y1 = norm1(:,2);
x2 = norm2(:,1);
y2 = norm2(:,2);
[n,~] = size(pts1);

% organize the coefficient matrix
coff = [x1 .* x2, x1 .* y2, x1, y1 .* x2, y1 .* y2, y1, x2, y2, ones(n,1)];

% compute F using SVD
[~,~,d] = svd(coff);
F = [d(1,9),d(2,9),d(3,9);
    d(4,9),d(5,9),d(6,9);
    d(7,9),d(8,9),d(9,9)];


 % call refineF function
 F = refineF(F, norm1, norm2);

% normalize F
m = [1/M,0,0;
    0,1/M,0;
    0,0,1];
F = m' * F * m;

end

