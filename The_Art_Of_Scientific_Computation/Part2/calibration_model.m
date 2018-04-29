%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fitfunx, fitfuny, fitfunz] = calibration_model()

% inpupt all data
real_dot = [];
left_dot = [];
right_dot = [];
for i = 0:1
    dis_z = 1900 + i * 20;
    left_img = ['Resources/cal_image_left_', num2str(dis_z), '.tiff'];
    right_img = ['Resources/cal_image_right_', num2str(dis_z), '.tiff'];
    real_dot = [real_dot; build_dot(dis_z)];
    left_dot = [left_dot; dot_detect(left_img)];
    right_dot = [right_dot; dot_detect(right_img)];
end
% build fit dunctions
lx = left_dot(:,1);
ly = left_dot(:,2);
rx = right_dot(:,1);
ry = right_dot(:,2);
realx = real_dot(:,1);
realy = real_dot(:,2);
realz = real_dot(:,3);
capture = [lx,ly,rx,ry]

fitfunx = myfun(capture, realx);
fitfuny = myfun(capture, realy);
fitfunz = myfun(capture, realz);

end

% build dot in real space
function real = build_dot(real_z)
for j = 1:17
    for i = 1:21
        index = 21*(j-1)+i;
        real(index,:) = [j*50,-500+i*50,real_z];
    end
end
end

function func = myfun(capture, real)
fitfun = polyfitn(capture, real, 3);
sx     = (polyn2sym(fitfun));
func   = matlabFunction(sx);
end
