%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Compute the  spatial cross correlation of two vectors   %
%           with the same size                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vec_res = spatial_correlation_1d(vec_a,vec_b)
%% padding 0 in the head and tail of vec_a 
len = length(vec_a);
vec_a = vec_a - mean(vec_a);
vec_b = [zeros(1, len-1), vec_b - mean(vec_b), zeros(1, len-1)];

%% cross correlation
vec_res = zeros(1, 2*len-1);
for i = 1:(2*len-1)
    vec_res(i) = sum(vec_a .* (vec_b(1,i:i+len-1)))/len;
end