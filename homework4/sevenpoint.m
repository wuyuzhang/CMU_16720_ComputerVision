function F = sevenpoint(pts1, pts2, M)
% this function is used to compute F with only 7 corresponding points
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

% compute F using SVD and solving the determinant equation
[~,~,d] = svd(coff);
F1 = [d(1,9),d(2,9),d(3,9);
    d(4,9),d(5,9),d(6,9);
    d(7,9),d(8,9),d(9,9)];
F2 = [d(1,8),d(2,8),d(3,8);
    d(4,8),d(5,8),d(6,8);
    d(7,8),d(8,8),d(9,8)];
syms numta
a = solve(det(numta*F1+(1-numta)*F2 == 0));
a = double(a);

% since F may have three answers
F = cell(1,3);
for i = 1:3
    F{i} = a(i)*F1 + (1 - a(i))*F2;
end

% normalize F
m = [1/M,0,0;
    0,1/M,0;
    0,0,1];
for i = 1:3
    F{i} = m' * F{i} * m;
end

end

