%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Optimization of image compare, overlap refers window    %
%           overlap. Range in [0,1), sr_size is the what times      %
%           search size of window, search shape values [s]: square  %
%           or [f]: flat.                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = image_compare_optimized(img_a, img_b, overlap, sr_size, sr_shape)
%% input images
img_a = imread(img_a);
A = rgb2gray(img_a);
img_b = imread(img_b);
B = rgb2gray(img_b);
[Y,X] = size(B);

%% image comparation
res = [];
diff = A.*0;
% decide window size 
wsize = round( max(X, Y) / 50 );
% compute shift size by overlap
shift = ceil( wsize * (1 - overlap));
ceil((X-wsize)/shift)
ceil((Y-wsize)/shift)
for i = 0 : ceil((X-wsize)/shift)
    for j = 0 : ceil((Y-wsize)/shift)
        xgrid = 1 + i * shift;
        ygrid = 1 + j * shift;
        % find correspond points of two images
        [dx,dy] = corr_search(A, B, wsize, xgrid, ygrid, sr_size, sr_shape);
        res = [res;xgrid,ygrid,xgrid+dx,ygrid+dy];
        diff(ygrid:(ygrid+wsize),xgrid:(xgrid+wsize)) = sqrt(dx*dx+dy*dy);
    end
end

%% draw the corresponding points
diff(diff>3*wsize) = 3*wsize;
surf(diff)
axis image
shading interp
colorbar
hold on
end


%% optimized compare, two options (ovarlap and search region shape)
function [dx,dy] = corr_search(A, B, wsize, xgrid, ygrid, sr_size, sr_shape)
%% pattern (window)
[Y,X] = size(B);
pat_left = xgrid;
pat_right = min(X,xgrid + wsize - 1);
pat_top = ygrid;
pat_bottom = min(Y,ygrid + wsize - 1);
pattern = A(pat_top:pat_bottom, pat_left:pat_right);

%% search region
extend = floor(wsize * (sr_size - 1)/2);
sr_left = max(1, pat_left - extend + 1);
sr_right = min(X, pat_right + extend);
% search region shape
if sr_shape == 's' % square
    sr_top = max(1, pat_top - extend + 1);
    sr_bottom = min(Y, pat_bottom + extend);
elseif sr_shape == 'f' % flat
    sr_top = pat_top;
    sr_bottom = pat_bottom;
end
search_region = B(sr_top:sr_bottom, sr_left:sr_right);

%% find the max cross correlation position
cross_corr = normxcorr2(pattern, search_region);
[rel_y,rel_x] = find(cross_corr == max(cross_corr(:)));
if isempty(rel_x)
    dx = 0;
    dy = 0;
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