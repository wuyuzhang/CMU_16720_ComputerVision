
load('some_corresp.mat');
load('intrinsics.mat');
im1 = imread('im1.png');
im2 = imread('im2.png');

[m,n,z] = size(im1);
M = max(m,n);

% call eightpoint method
F = eightpoint(pts1,pts2,M);

% call essentialMatrix method
E = essentialMatrix(F,K1,K2);

% call camera2 method
M2s = camera2(E);

% check the right M2
M1 = [1 0 0 0; 0 1 0 0; 0 0 1 0];
for i = 1:4
    P = triangulate(K1*M1, pts1, K2*M2s(:,:,i), pts2);
    if all(P(:,3) > 0)
        sprintf('correct M2 is: %d\n', i)
        Pcorrect = P;
        M2 = M2s(:,:,i);
        break;
    end
end
p1 = pts1;
p2 = pts2;
P = Pcorrect;
save('q2_5.mat', 'M2', 'p1', 'p2', 'P');

