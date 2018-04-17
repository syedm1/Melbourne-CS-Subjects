%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Optimization of image compare, overlap       %
%           refers window overlap. Range in [0,1).       %
%           sr_size is the what times search size of     %
%           window, search shape values [s]: square or   %
%           [f]: flat.                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = image_compare_optimized(img_a, img_b, overlap, sr_size, sr_shape)

% read image
img_a = imread(img_a);
mat_a = mean(img_a, 3);
[a_X,a_Y] = size(mat_a);
img_b = imread(img_b);
mat_b = mean(img_b, 3);
[b_X,b_Y] = size(mat_b);

res = [];
% decide window size 
wsize = round( min(a_X, a_Y) / 5 );
% compute shift size by overlap
shift = floor( wsize * (1 - overlap));
% image comparation
for i = 0 : floor((a_X - wsize)/shift) - 1
    for j = 0 : floor((a_Y - wsize)/shift) - 1
        xgrid = 1 + i * shift;
        ygrid = 1 + j * shift;
        % find correspond points of two images
        [px,py] = corr_search(mat_a, mat_b, wsize, xgrid, ygrid, sr_size, sr_shape);
        res = [res;xgrid,ygrid,px,py]
    end
end

% draw the corresponding points
imshow(img_a)
hold on
plot(res(:,2),res(:,1),'+')
plot(res(:,4),res(:,3),'.')

end


function [px,py] = corr_search(mat_a, mat_b, wsize, xgrid, ygrid, sr_size, sr_shape)

% pattern (window)
pat_left = xgrid;
pat_right = xgrid + wsize - 1;
pat_top = ygrid;
pat_bottom = ygrid + wsize - 1;
pattern = mat_a(pat_left:pat_right, pat_top:pat_bottom);

% search region
extend = floor(wsize * (sr_size - 1)/2);
[b_X,b_Y] = size(mat_b);
search_left = max(1, pat_left - extend + 1);
search_right = min(b_X, pat_right + extend);
% search region shape
if sr_shape == 's' % square
    search_top = max(1, pat_top - extend + 1);
    search_bottom = min(b_Y, pat_bottom + extend);
elseif sr_shape == 'f' % flat
    search_top = pat_top
    sear_bottom = pat_bottom
end
search_region = mat_b(search_left:search_right, search_top:search_bottom);

% find the max cross correlation position
cross_corr = my_norm_xcorr2(search_region, pattern);
[rel_x,rel_y] = find(cross_corr == max(max(cross_corr)));
% if several maxium, use the top left one
px = rel_x(1) + search_left - 1;
py = rel_y(1) + search_top - 1;

end


