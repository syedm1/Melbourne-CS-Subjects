%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Detect dots on a calibration plate on a sub-pixel level %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dots = subpixel_dot_detect(img_t)
%% read image
img = imread(img_t);
mat_img = rgb2gray(img);
[X,Y] = size(mat_img);

%% create a Gaussian template¡£
u = [-1:1];
v = [-1:1];
[U,V] = meshgrid(u,v);
mat_gauss = exp(-(U.^2+V.^2)./2/3^2);

%% cross correlation
cross_corr = xcorr2(mat_img, mat_gauss);
% local max cross correlation position
dots = local_max(cross_corr,mat_gauss,3);
% dots = order_dots(dots,21,17);
size(dots)
dots = order_dots(dots,13,9);

% draw the point in the picture
% imshow(img)
% hold on
% plot(dots(:,2),dots(:,1),'+','Markersize',2)
end


%% find all local maximum dotsm, level is the local range
function res = local_max(cross_corr, mat_gauss, level)
    res = [];
    max_v = max(cross_corr(:));
    while max_v > 0
        [peak_y,peak_x] = find(cross_corr == max_v);
        y = peak_y(1);
        x = peak_x(1);
        lock_peak = cross_corr(y-level:y+level+1,x-level:x+level+1);
        % draw
        % surf(lock_peak)
        % hold on 
        % pause(5)
        [dy,dx] = sub_pixel_peak(lock_peak);
        res = [res;y+dy,x+dx];
        cross_corr(y-50:y+50,x-50:x+50) = 0;
        max_v = max(cross_corr(:));
    end
end

%% find sub-pixel peak
function [dy,dx] = sub_pixel_peak(A) 
    [Y,X] = size(A);
    S = sum(A(:));
    S_Y = 0;
    for i = 1:X
        S_Y = S_Y + i*sum(A(i,:));
    end
    dy = S_Y/S;
    S_X = 0;
    for i = 1:Y
        S_X = S_X + i*sum(A(:,i));
    end
    dx = S_X/S;
end

%% order the dots
function res = order_dots(dots, n, m)
    res = dots;
    for i=1:m
        for j=1:n
            st = (i-1)*n+1;
            en = i*n;
            res(st:en,:) = sortrows(dots(st:en,:),2);
        end
    end
end