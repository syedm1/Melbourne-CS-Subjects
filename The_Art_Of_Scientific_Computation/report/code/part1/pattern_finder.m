%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Compute the spectral cross correlation       %
%           vector of two vectors of the same size       %
%           using Fourier transform.                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = pattern_finder(wavfile,patfile)

[y1,Fs] = audioread(wavfile);
x1 = y1(:,1);

[y2,Fs] = audioread(wavfile);
x2 = y2(:,1);

corr_vec = spectral_correlation_function(x1',x2')

res = corr_vec
