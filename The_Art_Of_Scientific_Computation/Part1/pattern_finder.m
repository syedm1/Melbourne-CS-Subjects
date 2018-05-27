%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Find all accurance of a particular music element in a   %
%           piece of music                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = pattern_finder(music,pat)
%% load the music and a particular element (drum)
[y1,Fs1] = audioread(music);
x1 = y1(:,1);
[y2,Fs2] = audioread(pat);
x2 = y2(:,1);

%% cross correlation 
corr_vec = xcorr(x1',x2');
res = corr_vec;

%% show
% plot(y1);
% plot(y2);
 plot(res);
