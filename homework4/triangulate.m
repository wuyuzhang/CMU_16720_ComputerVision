function P = triangulate(M1, p1, M2, p2)
% this function is uesd to achieve a set of 3D coordinates using 2D points
% M1 and M2 are camera matrix
% p1 and p2 are 2D coordinates

% homogenous form
p1 = [ p1'; ones(1, size(p1, 1))];
p2 = [ p2'; ones(1, size(p2, 1))];
P = zeros(4, size(p1,2));

% calculation for each point
for i = 1: size(p1, 2)
    p = p1(:,i);
    q = p2(:,i);
    p = [0, p(3), -p(2);
        -p(3), 0, p(1);
        p(2), -p(1), 0];
    q = [0, q(3), -q(2);
        -q(3), 0, q(1);
        q(2), -q(1), 0];
    T = [p*M1; q*M2];
    [~, ~, D] = svd(T);
    d = D(:, end);
    P(:, i) = d/d(4);
end

P = P';
P = P(:, 1:3);
end

