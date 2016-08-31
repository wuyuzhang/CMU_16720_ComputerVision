close all;
clear all;
clc;

%%
im1=imread('taj1.jpg');
im2=imread('taj2.jpg');

load p.mat;
H2to1 = computeH(p1,p2);
figure(1);
imshow(im1);
hold on;

for i = 1:7
    x = p1(1,i);
    y = p1(2,i);
    plot(x,y,'r+');
end
ones = [1,1,1,1,1,1,1];
p2 = [p2;ones];
p2to1 = H2to1 * p2;
for i = 1:7
    p2to1(1,i) = p2to1(1,i)/p2to1(3,i);
    p2to1(2,i) = p2to1(2,i)/p2to1(3,i);
end
for i = 1:7
    x = p2to1(1,i);
    y = p2to1(2,i);
    plot(x,y,'g+');
end
save q2_3.mat H2to1 p1 p2 p2to1;




