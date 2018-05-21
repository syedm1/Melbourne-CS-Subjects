%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:	create a 3D reconstruction of the test image pairs      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = test_scan(img_a, img_b, fx, fy, fz)
%% compare two images
fprintf("Image comparing...\n ");
cmp = image_compare_optimized(img_a,img_b,0,5,'s');
size(cmp)
fprintf("Image comparing done!\n ");

%% init calibrate model (it may take a long time, so we make it parameters)
fprintf("Calibration model initializing...\n ");
% [fx, fy, fz] = calibration_model();
fprintf("Calibration model initialize done!\n ");

%% create a 3D reconstruction
[X,Y] = size(cmp)
res = [];
for i = 1:X
    realx = fx(cmp(i,1),cmp(i,2),cmp(i,3),cmp(i,4));
    realy = fy(cmp(i,1),cmp(i,2),cmp(i,3),cmp(i,4));
    realz = fz(cmp(i,1),cmp(i,2),cmp(i,3),cmp(i,4));
    res = [res;cmp(i,:),realx,realy,realz];
end

%% Plot
figure;
plot3(res(:,7),res(:,5),res(:,6),'o')
hold on
fsize = [38,51];
surf(reshape(res(:,7),fsize),reshape(res(:,5),fsize),reshape(res(:,6),fsize))
xlabel('z [mm]')
ylabel('y [mm]')
zlabel('x [mm]')
axis equal
% axis([0,2300, -800,800, -200,1000]);
grid on

