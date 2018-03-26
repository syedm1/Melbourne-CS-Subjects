%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Given two signal file, these signals have    %
%           come from the same the same sourcce and just %
%           offset by some time, find the offset time    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function offset = signal_offset_checker(f_1, f_2)

% read data from file
file_1 = importdata(f_1);
file_2 = importdata(f_2);
sig_1 = file_1.data';
sig_2 = file_2.data';
SAMPLE_RATE = 44100;

% compute cross correlation of two signal
tic;
% special method
cross_cor = spatial_correlation_1d(sig_1, sig_2)';
% spectral method
% cross_cor = spectral_correlation_function(sig_1, sig_2)';
run_time = toc

% find the position of max cross coorelation value, 
% then compute the offset.
[max_value, max_pos] = max(abs(cross_cor));
offset = abs(length(sig_1) - max_pos)

%compute offset time and sensor distance
offset_time = offset / SAMPLE_RATE
distance = 333 * offset_time
