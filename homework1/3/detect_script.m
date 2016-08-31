close all;
clear all;
clc;
%%
img1=imread('mug1.jpg');
img2=imread('mug2.jpg');

load('mug_points.mat')
pts=[p1;p2];
[originTransparant1,originTransparant2] = detectTransparent(img1, img2);
figure(1);
imshow(originTransparant1);
% imwrite(originTransparant1,'img1_transparant.jpg');
hold on;

figure(2);
imshow(originTransparant2);
% imwrite(originTransparant2,'img2_transparant.jpg');
