%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Detect doc on a calibration plate            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dots = dot_detect(img_t)

% read image
img = imread(img_t);
mat_img = mean(img, 3);
[X,Y] = size(mat_img);

% create a Gaussian template
u = [-2:2];
v = [-2:2];
[U,V] = meshgrid(u,v);
mat_gauss = exp(-(U.^2+V.^2)./2/3^2);
% draw the gaussian template
% u = [-20:0.1:20];
% v = [-20:0.1:20];
% [U,V] = meshgrid(u,v);
% mat_gauss = exp(-(U.^2+V.^2)./2/3^2);
% surf(mat_gauss), shading flat
% hold on
%

cross_corr = xcorr2(mat_img, mat_gauss);
% local max cross correlation position
dots = local_max(cross_corr,50);
dots = order_dots(dots,13,9);

% draw the point in the picture
% imshow(img)
% hold on
% plot(dots(:,2),dots(:,1),'+','Markersize',10)
% draw line to check the point order
% plot(dots(:,2),dots(:,1))
end


% find all local maximum dots
% level is the local range
function res = local_max(mat_a, level)

t = 1;
res = [];
[X,Y] = size(mat_a);
for x = (1+level):(X-level)
    for y = (1+level):(Y-level)
        if mat_a(x,y) > 0
            local_maxx = max(max(mat_a(x-level:x+level,y-level:y+level)));
            if mat_a(x,y) == local_maxx 
                res = [res;x,y];
            end
        end
    end
end
end

% order the dots
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