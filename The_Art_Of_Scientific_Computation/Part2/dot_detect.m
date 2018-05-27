%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Detect all dots on a calibration plate and sort them    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dots = dot_detect(img_t)
%% read image
img = imread(img_t);
mat_img = rgb2gray(img);
[X,Y] = size(mat_img);

%% create a Gaussian template¡£
u = [-2:2];
v = [-2:2];
[U,V] = meshgrid(u,v);
mat_gauss = exp(-(U.^2+V.^2)./2/3^2);
% draw the gaussian template
% [U,V] = meshgrid(u,v);
% mat_gauss = exp(-(U.^2+V.^2)./2/3^2);
% surf(mat_gauss), shading flat
% hold on

%% cross correlation
cross_corr = xcorr2(mat_img, mat_gauss);
% local max cross correlation position
dots = local_max(cross_corr,50);
% dots = order_dots(dots,21,17);
dots = order_dots(dots,13,9);

% draw the point in the picture
% imshow(img)
% hold on
% plot(dots(:,2),dots(:,1),'+','Markersize',10)
% % draw line to check the point order
% plot(dots(:,2),dots(:,1))
end


%% find all local maximum dotsm, level is the local range
function res = local_max(mat_a, level)
res = [];
[X,Y] = size(mat_a);
x = 1+level;
while x < X-level
    y = 1+level;
    while y < Y-level
        if mat_a(x,y) > 0
            local_maxx = max(max(mat_a(x-level:x+level,y-level:y+level)));
            if mat_a(x,y) == local_maxx 
                res = [res;x,y];
                % if find one local max, set positions around it to 0
                mat_a(x-level:x+level,y-level:y+level) = 0;
            end
        end
        y = y + 1;
    end
    x = x + 1;
end
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