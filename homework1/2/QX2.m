close all;
clear all;
clc;
%%
img1=imread('taj1.jpg');
img2=imread('taj2.jpg');

load('taj_points.mat');
pts=[p1;p2];
[H2to1, panoImg] = blending(img1, img2, pts);
imshow(panoImg);
imwrite(panoImg,'blending.jpg');