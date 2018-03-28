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

corr_vec = spectral_correlation_1d(x1,x2)


%{
X_f=fft(x);
figure (1)
subplot(2,1,1);
plot(x);
xlabel('time')
title('time domain')
subplot(2,1,2);
plot(abs(X_f));
xlabel('frequency')
title('frequency domian')

X1_f=X_f;
X1_f(10:90) = 0;

X2_f=X_f;
X2_f(1:90)=0;
X2_f(96:end)=0;

x1_reconstruc = ifft(X1_f);
x2_reconstruc = ifft(X2_f);

figure (2)
plot(real(x1_reconstruc));
title('Reconsturctured x1')

figure (3)
plot(real(x2_reconstruc));
title('Reconsturctured x2')
%}