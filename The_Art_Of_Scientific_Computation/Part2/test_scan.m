%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = test_scan(img_a, img_b, fx,fy,fz)

% compare two images
fprintf("Image comparing...\n ");
cmp = image_compare(img_a, img_b);
fprintf("Image comparing done!\n ")

% init calibrate model
fprintf("Calibration model initializing...\n ")
% [fx, fy, fz] = calibration_model();
fprintf("Calibration model initialize done!\n ")

% remove any spurious vectors
img_cmp = cmp(find(abs(cmp(:,2)-cmp(:,4))<50 ...
                     & abs(cmp(:,1)-cmp(:,3))<50),:)

[X,Y] = size(img_cmp);
res = []
for i = 1:X
    realx = fx(img_cmp(i,1),img_cmp(i,2),img_cmp(i,3),img_cmp(i,4));
    realy = fy(img_cmp(i,1),img_cmp(i,2),img_cmp(i,3),img_cmp(i,4));
    realz = fz(img_cmp(i,1),img_cmp(i,2),img_cmp(i,3),img_cmp(i,4));
    res = [res;img_cmp(i,:),realx,realy,realz];
end

