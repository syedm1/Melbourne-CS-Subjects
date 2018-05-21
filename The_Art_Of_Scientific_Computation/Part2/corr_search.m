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
sr_top = max(1, pat_top - extend + 1);
sr_bottom = min(Y, pat_bottom + extend);
search_region = B(sr_top:sr_bottom, sr_left:sr_right);

%% find the max cross correlation position
% cross_corr = my_norm_xcorr2(search_region, pattern);
cross_corr = normxcorr2(pattern, search_region);
surf(cross_corr)
shading interp
hold on
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