%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:	create a 3D reconstruction of the test image pairs      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = test_scan1(img_a, img_b, fx, fy, fz)
%% compare two images
fprintf("Image comparing...\n ");
left_dot = dot_detect(img_a);
right_dot = dot_detect(img_b);
cmp = [left_dot(:,2),left_dot(:,1),right_dot(:,2),right_dot(:,1)];
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
surf(reshape(res(:,7),[13,9]),reshape(res(:,5),[13,9]),reshape(res(:,6),[13,9]))
xlabel('z [mm]')
ylabel('y [mm]')
zlabel('x [mm]')
axis equal
axis([0,2000, -500,500, 0,800]);
grid on

