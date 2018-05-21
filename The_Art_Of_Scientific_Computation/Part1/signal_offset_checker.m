%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Give two signal file with signals come from the same    %
%           source and just offset by some time, find the offset    %
%           time and sensor distance                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function offset = signal_offset_checker(f_1, f_2)
%% read data from file
file_1 = importdata(f_1);
file_2 = importdata(f_2);
sig_1 = file_1.data';
sig_2 = file_2.data';
SAMPLE_RATE = 44100;

%% compute cross correlation of two signal, log run time
tic;
% special method
% cross_corr = spatial_correlation_1d(sig_1, sig_2)';
% spectral method (faster)
cross_corr = spectral_correlation_function(sig_1, sig_2)';
run_time = toc

%% find the position of max cross coorelation value and compute the offset.
[max_value, max_pos] = max(abs(cross_corr))
offset = abs(length(sig_1) - max_pos)

% compute offset time and sensor distance
offset_time = offset / SAMPLE_RATE
distance = 333 * offset_time

%% show
figure
plot(cross_corr)
ylim([-0.4,1.2])
hold on
plot(max_pos,max_value,'ro')
text(max_pos,max_value,'Maximum','FontSize',12)