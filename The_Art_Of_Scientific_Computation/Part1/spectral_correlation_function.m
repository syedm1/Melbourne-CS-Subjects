%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Compute the spectral cross correlation of two vectors   %
%           of the same size using Fourier transform.               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vec_res = spectral_correlation_1d(vec_a, vec_b)

f_a = fft(vec_a);
f_b = fft(vec_b);
conj_f_a = conj(f_a);
mid_res = conj_f_a .* f_b;
vec_res = ifft(mid_res);


%% My fft, does not work is NN is not the power of 2
function res_fft = my_fft(vec)

vec_size = size(vec);
N = vec_size(2)
c = zeros(1,N);
% indexing computation
j1 = 0;
for i = 1 : N
    if i < j1 + 1
        tmp = vec(j1 + 1);
        vec(j1 + 1) = vec(i);
        vec(i) = tmp;
    end
    k = N / 2;
    while k <= j1
        j1 = j1 - k;
        k = k / 2;
    end
    j1 = j1 + k;
end

%% Butterfly computing
dig = 0;
k = N;
while k > 1
    dig = dig + 1;
    k = k / 2;
end

n = N / 2;
for m = 1 : dig
    dist = 2 ^ (m - 1);
    idx = 1;
    for i = 1 : n
        idx1 = idx;
        for j1 = 1 : N / (2 * n)
            r = (idx - 1) * 2 ^ (dig - m);
            coef = exp(j * (-2 * pi * r / N));
            tmp                 = vec(idx);
            vec(idx)         = tmp + vec(idx + dist) * coef;
            vec(idx + dist)  = tmp - vec(idx + dist) * coef; 
            idx = idx + 1;
        end
        idx = idx1 + 2 * dist;
    end
    n = n / 2;
end
res_fft = vec; 