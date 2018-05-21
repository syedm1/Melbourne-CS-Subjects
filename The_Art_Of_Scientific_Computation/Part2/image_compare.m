%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Compare two images, split one image to several windows, %
%           search more similar part in the other corresponding     %
%           image                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = image_compare(img_a, img_b)
%% input images
img_a = imread(img_a);
A = rgb2gray(img_a);
img_b = imread(img_b);
B = rgb2gray(img_b);
[Y,X] = size(B);

%% image comparasion
% store the result
diff = A.*0;
res = [];
% split the larger side length to 10
wsize = round( max(X, Y) / 10);
for i = 0 : ceil(X/wsize) - 1
    for j = 0 : ceil(Y/wsize) - 1
        xgrid = 1 + i * wsize;
        ygrid = 1 + j * wsize;
        % find correspond points of two images
        [dx,dy] = corr_search(A, B, wsize, xgrid, ygrid);
        res = [res;xgrid,ygrid,xgrid+dx,ygrid+dy];
        diff(ygrid:(ygrid+wsize),xgrid:(xgrid+wsize)) = sqrt(dx*dx+dy*dy);
    end
end

%% show
ssize = 10*wsize;
diff(diff>ssize) = ssize;
surf(diff)
axis image
shading interp
colorbar
hold on
end


function [dx,dy] = corr_search(mat_a, mat_b, wsize, xgrid, ygrid)
%% pattern (window)
[Y,X] = size(mat_a);
pat_left = xgrid;
pat_right = min(X,xgrid + wsize - 1);
pat_top = ygrid;
pat_bottom = min(Y,ygrid + wsize - 1);
pattern = mat_a(pat_top:pat_bottom, pat_left:pat_right);

%% search region: 3x window size square
sr_left = max(1, pat_left - wsize + 1);
sr_right = min(X, pat_right + wsize);
sr_top = max(1, pat_top - wsize + 1);
sr_bottom = min(Y, pat_bottom + wsize);
search_region = mat_b(sr_top:sr_bottom, sr_left:sr_right);

%% find the max cross correlation position
cross_corr = my_norm_xcorr2(search_region, pattern);
[rel_y,rel_x] = find(cross_corr == max(cross_corr(:)));
if isempty(rel_x)
    dx = 1000;
    dy = 1000;
else
    dx = rel_x(1) + sr_left - pat_left-1;
    dy = rel_y(1) + sr_top - pat_top-1;
end
end

%% 2d cross correlation
function mat_r = my_norm_xcorr2(mat_A, mat_t)
[Ay, Ax] = size(mat_A);
[ty,tx] = size(mat_t);
% Change - Compute the cross power spectrum
Ga = fft2(mat_A);
Gb = fft2(mat_t, Ay, Ax);
mat_r = real(ifft2((Ga.*conj(Gb))./abs(Ga.*conj(Gb))));
end

