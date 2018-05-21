%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Create a calibration model use a set of calibration     %
%           images                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fitfunx, fitfuny, fitfunz] = calibration_model()
%% input all calibration images
real_dot = [];
left_dot = [];
right_dot = [];
for i = 0:5
    dis_z = 1900 + i * 20;
    left_img = ['Resources/cal_image_left_', num2str(dis_z), '.tiff'];
    right_img = ['Resources/cal_image_right_', num2str(dis_z), '.tiff'];
    real_dot = [real_dot; build_dot(dis_z)];
    left_dot = [left_dot; dot_detect(left_img)];
    right_dot = [right_dot; dot_detect(right_img)];
end

%% build fit dunctions
ly = left_dot(:,1);
lx = left_dot(:,2);
ry = right_dot(:,1);
rx = right_dot(:,2);
realy = real_dot(:,1);
realx = real_dot(:,2);
realz = real_dot(:,3);
capture = [lx,ly,rx,ry];

fitfunx = myfun(capture, realx);
fitfuny = myfun(capture, realy);
fitfunz = myfun(capture, realz);
end

%% compute dots positions in real space
function real = build_dot(real_z)
for j = 1:17
    for i = 1:21
        index = 21*(j-1)+i;
        real(index,:) = [j*50,-500+i*50,real_z];
    end
end
end

%% output the calibration model 
function func = myfun(capture, real)
fitfun = polyfitn(capture, real, 3);
sx     = (polyn2sym(fitfun));
func   = matlabFunction(sx);
end
