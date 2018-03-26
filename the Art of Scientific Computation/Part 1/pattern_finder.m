%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Compute the spectral cross correlation       %
%           vector of two vectors of the same size       %
%           using Fourier transform.                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = pattern_finder(wavfile)

[y,Fs] = audioread(wavfile);
x = y(:,1);
y2 = y(:,2);

%f_y = fft(y1);
%conj_f_y1 = conj(f_y1);
%mid_res = conj_f_y1 .* f_y1;
%res = ifft(mid_res);

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
X1_f(10:end) = 0;

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