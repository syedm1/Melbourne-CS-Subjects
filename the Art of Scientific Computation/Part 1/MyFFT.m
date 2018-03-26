
function ret_val = MyFFT(vector)
%======================================
%ret_val 为fft变换后返回的频域序列
%N 为点数
%vector 为变换前的序列
%======================================
vector_size = size(vector);
N = vector_size(2)
c = zeros(1,N);
%
%变址运算
%
j1 = 0;
for i = 1 : N
    if i < j1 + 1
        tmp = vector(j1 + 1);
        vector(j1 + 1) = vector(i);
        vector(i) =tmp;
    end
    k = N / 2;
    while k <= j1
        j1 = j1 - k;
        k = k / 2;
    end
    j1 = j1 + k;
end

%
%蝶形运算
%
%%%%%%%计算 N 的
dig = 0;
k = N;
while k > 1
    dig = dig + 1;
    k = k / 2;
end
%%%%%%
% m 为级; dist 为蝶形运两点的距离; n 为蝶形运算组数
%
n = N / 2;
for m = 1 : dig
    dist = 2 ^ (m - 1);
    idx = 1;
    for i = 1 : n
        idx1 = idx;
        for j1 = 1 : N / (2 * n)
            r = (idx - 1) * 2 ^ (dig - m);
            coef = exp(j * (-2 * pi * r / N));
            tmp                 = vector(idx);
            vector(idx)         = tmp + vector(idx + dist) * coef;
            vector(idx + dist)  = tmp - vector(idx + dist) * coef; 
            idx = idx + 1;
        end
        idx = idx1 + 2 * dist;
    end
    n = n / 2;
end

ret_val = vector; 