function H2to1 = computeH(p1,p2)
% Input:
% p1 points in image1
% p2 points in image2
% both are 2*n matrix
% Output:
% H2to1 3*3 matrix mapping points p2 to points p1

p1 = p1';
p2 = p2';

% add ones to the last column
P1 = [p1,ones(length(p1),1)];
P2 = [p2,ones(length(p2),1)];

% row of A corresponding to x coordinates
L1 = [-P2,zeros(length(p1),3),bsxfun(@times,P1(:,1),P2)];
% row of A corresponding to y coordinates
L2 = [zeros(length(p1),3),-P2,bsxfun(@times,P1(:,2),P2)];

% Singular Value Decomposition
A = [L1;L2];
W = A' * A;
W = W / max(W(:));
[U,D,V] = svd(W);
% H2to1 is the eigenvecotr
H2to1 = U(:,end);
H2to1 = reshape(H2to1,3,3);
H2to1 = H2to1';

end