%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Multipass image comparation: recersively call image     %
%           comparation function of part of the whole image         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function diff = image_compare_multipass(img_a, img_b)
%% input images
img_a = imread(img_a);
A = rgb2gray(img_a);
img_b = imread(img_b);
B = rgb2gray(img_b);
[Y,X] = size(B);

%% image comparasion
% store the result
diff = A.*0;
% init window size
wsize = 128;
% recersive level
level = 2;
for i = 0 : ceil(X/wsize) - 1
    for j = 0 : ceil(Y/wsize) - 1
        xgrid = 1 + i * wsize;
        ygrid = 1 + j * wsize;
        % find correspond points of two images
        diff = img_cmp(A, B, wsize, xgrid, ygrid, 0, 0, diff, 2);
    end
end

%% show
ssize = 3*wsize/2^level;
diff(diff>ssize) = ssize;
surf(diff)
axis image
shading interp
colorbar
hold on
end

%% recursive compare function
function diff = img_cmp(A, B, wsize, xgrid, ygrid, dpx, dpy, diff, level)
%% pattern (window)
[Y,X] = size(A);
pat_left = xgrid;
pat_right = min(X,xgrid + wsize - 1);
pat_top = ygrid;
pat_bottom = min(Y,ygrid + wsize - 1);
pattern = A(pat_top:pat_bottom, pat_left:pat_right);

%% search region: 3x window size square
sr_left = max(1, pat_left - wsize + 1 + dpx);
sr_right = min(X, pat_right + wsize + dpx);
sr_top = max(1, pat_top - wsize + 1 + dpy);
sr_bottom = min(Y, pat_bottom + wsize + dpy);
% if search region out of bound completely, stop
if sr_left > X | sr_top > Y
    diff(pat_top:pat_bottom,pat_left:pat_right) = sqrt(2000000);
    return
end
search_region = B(sr_top:sr_bottom, sr_left:sr_right);

% find the max cross correlation position
cross_corr = my_norm_xcorr2(search_region, pattern);
[rel_y,rel_x] = find(cross_corr == max(cross_corr(:)));
% can not find a cross corr result in big picture
if isempty(rel_x) & level > 1
    dx = 0;
    dy = 0;
elseif isempty(rel_x) & level == 1
        dx = 1000;
        dy = 1000;
else
    dx = rel_x(1) + sr_left - pat_left-1;
    dy = rel_y(1) + sr_top - pat_top-1;
end
diff(pat_top:pat_bottom,pat_left:pat_right) = sqrt(dx*dx+dy*dy);
% if level == 1, stop recursive
if level == 1
    return
else
    wsize = wsize / 2;
end

%% recursively call image compare
level = level-1;
xgrid1 = pat_left;
xgrid2 = pat_left+wsize;
ygrid1 = pat_top;
ygrid2 = pat_top+wsize;
diff = img_cmp(A, B, wsize, xgrid1, ygrid1, dx, dy, diff, level);
if xgrid2 < X
    diff = img_cmp(A, B, wsize, xgrid2, ygrid1, dx, dy, diff, level);
end
if ygrid2 < Y
    diff = img_cmp(A, B, wsize, xgrid1, ygrid2, dx, dy, diff, level);
end
if xgrid2 < X & ygrid2 < Y
    diff = img_cmp(A, B, wsize, xgrid2, ygrid2, dx, dy, diff, level);
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