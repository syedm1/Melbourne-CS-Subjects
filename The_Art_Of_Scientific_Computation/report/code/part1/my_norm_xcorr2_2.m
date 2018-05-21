%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Receive two matrix, t(template) and A(search %
%           region) returns normalized cross power       %
%           spectrum of these two matrix, A larger than t%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mat_r = my_norm_xcorr2_2(mat_A, mat_t)

% calculate padding
[tx,ty] = size(mat_t);
[Ax, Ay] = size(mat_A);

% Change - Compute the cross power spectrum
Ga = fft2(mat_A);
Gb = fft2(mat_t, Ax, Ay);

mat_r = real(ifft2((Ga.*conj(Gb))./abs(Ga.*conj(Gb))));