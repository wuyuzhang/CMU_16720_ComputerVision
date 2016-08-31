% 
  im1=imread('taj1.jpg');
  im2=imread('taj2.jpg');
% 
% if 1
%     % Label points the first time...
%     [im1_points,im2_points] = ...
%         cpselect(im1,im2,'Wait',true);
%     
%     p1 = im1_points'; % Should be 2xN
%     p2 = im2_points';
%     
%     save building.mat p1 p2;
% end

load taj_points;




% load('mug_points.mat');
% H2to1 = computeH(p1,p2);
load('H2to1.mat');
figure(1);
imshow(im1);
hold on;

for i = 1:4
    x = p1(1,i);
    y = p1(2,i);
    plot(x,y,'r+','LineWidth',2);
end
hold on;
ones = [1,1,1,1];
p2 = [p2;ones];
p2to1 = H2to1 * p2;
for i = 1:4
    p2to1(1,i) = p2to1(1,i)/p2to1(3,i);
    p2to1(2,i) = p2to1(2,i)/p2to1(3,i);
end

for i = 1:4
    x = p2to1(1,i);
    y = p2to1(2,i);
    plot(x,y,'g+','LineWidth',2);
end
p2to1(3,:) = [];
parallax = p1 - p2to1;
error = 0;

for i = 1:4
    x = parallax(1,i);
    y = parallax(2,i);
    error = error+x^2+y^2;
end
error = sqrt(error)/4;





