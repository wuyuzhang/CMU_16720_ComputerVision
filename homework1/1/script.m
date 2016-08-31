close all;
clear all;
clc;

%%
% Read in the image
im = imread('curiosity.jpg');

im_R = im(:,:,1);
im_G = im(:,:,2);
im_B = im(:,:,3);

figure(1);

H = [1,0,0;
    0,2,0;
    0,0,1];
warp_im_R = warpImage( im_R, H );
warp_im_G = warpImage( im_G, H );
warp_im_B = warpImage( im_B, H);

im_mix = im;
im_mix(:,:,[1,3]) = 0;
im_mix(:,:,1) = warp_im_R;
im_mix(:,:,2) = warp_im_G;
im_mix(:,:,3) = warp_im_B;
% out_size = size(im);
% im = warpH(im,H,out_size);

imshow(im_mix);
imwrite(im_mix,'QX1_1.jpg');

