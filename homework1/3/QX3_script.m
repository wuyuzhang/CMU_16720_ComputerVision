close all;
clear all;
clc;
%%
img1=imread('building1.jpg');
img2=imread('building2.jpg');

load('building.mat')
pts=[p1;p2];
[H2to1, panoImg] = q2_5(img1, img2, pts);
imshow(panoImg);
% imwrite(panoImg,'building12.jpg');