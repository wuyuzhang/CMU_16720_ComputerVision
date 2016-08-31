close all;
clear all;
clc;
%%
img1=imread('mug1.jpg');
img2=imread('mug2.jpg');

load('mug_points.mat')
pts=[p1;p2];
[H2to1, panoImg] = q2_5(img1, img2, pts);
imshow(panoImg);
imwrite(panoImg,'mug12.jpg');