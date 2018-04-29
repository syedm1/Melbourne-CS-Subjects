%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Compute the normalised cross correlation     %
%           vector of two vectors of the same size       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vec_c = normalised_spatial_correlation_1d(vec_a, vec_b)

len = length(vec_a);
vec_a = vec_a - mean(vec_a);
vec_b = vec_b - mean(vec_b);
% compute sigma 
sigma = sqrt(sum(vec_a.^2)*sum(vec_b.^2))
% add 0 in the head and tail of vec_b
vec_b = [zeros(1, len-1), vec_b, zeros(1, len-1)];

% compute vec_c
vec_c = zeros(1, 2*len-1);
for i = 1:(2*len-1)
    % nor_a, nor_b are the normalization factors
    vec_c(i) = sum(vec_a .* (vec_b(1,i:i+len-1)))/sigma;
end
