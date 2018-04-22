%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Receive two matrix, t(template) and A(search %
%           region) returns normalized cross-correlation %
%           of these two matrix, A larger than t         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mat_r = normalised_spatial_correlation_2d(mat_t, mat_A)

% init mat_r with 0
size_t = size(mat_t);
size_A = size(mat_A);
mat_r = zeros(size_A(1)-size_t(1)+1, size_A(2)-size_t(2)+1);
size_r = size(mat_r);

% mat_t_ is a matrix of mat_t minus mean(mat_t)
mat_t_ = mat_t - mean(mat_t);

for i = 1:size_r(1)
    for j = 1:size_r(2)
        % compute mat_r(i,j)
        % first get the part of mat_A covered by the mat_t 
        mat_A_under = mat_A(i:(i+size_t(1)-1), j:(j+size_t(2)-1));
        mat_A_under_ = mat_A_under - mean(mat_A_under);
        % compute numerator and denominator of the cross correlation
        numerator = sum(sum(mat_t_ .* mat_A_under_));
        denominator = sqrt(sum(sum(mat_t_.^2)) * sum(sum(mat_A_under_.^2)));
        mat_r(i,j) = numerator/denominator;
    end
end

% figure
figure,surf(mat_r);figure(gcf)

