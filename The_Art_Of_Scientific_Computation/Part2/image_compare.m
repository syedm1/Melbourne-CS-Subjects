%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Compare two images, split one image to       %
%           several windows, search more similar part in %
%           the other corresponding image                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = image_compare(img_a, img_b)

% read image
img_a = imread(img_a);
mat_a = mean(img_a, 3);
img_b = imread(img_b);
mat_b = mean(img_b, 3);
[Y,X] = size(mat_b);

% store the result
mask_a = mat_a.*0;

res = [];
% split the larger side length to 10
wsize = round( max(X, Y) / 50);
for i = 0 : floor(X/wsize) - 1
    for j = 0 : floor(Y/wsize) - 1
        xgrid = 1 + i * wsize;
        ygrid = 1 + j * wsize;
        % find correspond points of two images
        [px,py] = corr_search(mat_a, mat_b, wsize, xgrid, ygrid);
        dx = px - xgrid;
        dy = py - ygrid;
        res = [res;ygrid,xgrid,dx,dy];
        mask_a(ygrid:(ygrid+wsize),xgrid:(xgrid+wsize)) = sqrt(dx*dx + dy*dy);
    end
end

% draw the corresponding points
mask_a(mask_a>100) = 100;
surf(mask_a)
shading interp
colorbar
hold on
% plot(res(:,2),res(:,1),'+')
% plot(res(:,4),res(:,3),'.')

end

function [px,py] = corr_search(mat_a, mat_b, wsize, xgrid, ygrid)

% pattern (window)
pat_left = xgrid;
pat_right = xgrid + wsize - 1;
pat_top = ygrid;
pat_bottom = ygrid + wsize - 1;
pattern = mat_a(pat_top:pat_bottom, pat_left:pat_right);


% search region: 3x window size square
[b_Y,b_X] = size(mat_b);
search_left = max(1, pat_left - wsize + 1);
search_right = min(b_X, pat_right + wsize);
search_top = max(1, pat_top - wsize + 1);
search_bottom = min(b_Y, pat_bottom + wsize);
search_region = mat_b(search_top:search_bottom, search_left:search_right);

% find the max cross correlation position
cross_corr = my_norm_xcorr2_2(search_region, pattern);

% cross_corr = my_norm_xcorr2_2(mat_b, pattern);
[rel_y,rel_x] = find(cross_corr == max(abs(cross_corr(:))));
if isempty(rel_y)
    rel_x = (10000);
    rel_y = (10000);
end
px = rel_x(1) + search_left - 1;
py = rel_y(1) + search_top - 1;

end


