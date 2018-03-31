%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Compute the  cross correlation vector of two %
%           vectors of the same size                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vec_c = spatial_correlation_1d(vec_a,vec_b)
% add 0 in the head and tail of vec_a 
len = length(vec_a);
vec_a = vec_a - mean(vec_a);
vec_b = [zeros(1, len-1), vec_b - mean(vec_b), zeros(1, len-1)];


% compute vec_c
vec_c = zeros(1, 2*len-1);
for i = 1:(2*len-1)
    vec_c(i) = sum(vec_a .* (vec_b(1,i:i+len-1)))/len;
end