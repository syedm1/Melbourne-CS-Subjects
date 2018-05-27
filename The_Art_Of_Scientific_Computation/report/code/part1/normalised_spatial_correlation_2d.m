%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Receive two matrix, t(template) and A(search region)    %
%           return normalized cross-correlation of them             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mat_res = normalised_spatial_correlation_2d(mat_t, mat_A)
%% init mat_res with 0
[tY,tX] = size(mat_t);
[AY,AX] = size(mat_A);
mat_res = zeros(AY-tY+1, AX-tX+1);
[rY,rX] = size(mat_res);

%% cross correlation
% mat_t_ is a matrix of mat_t minus mean(mat_t)
mat_t_ = mat_t - mean(mat_t);
for i = 1:rY
    for j = 1:rX
        % compute mat_res(i,j)
        % first get the part of mat_A covered by the mat_t 
        mat_A_under = mat_A(i:(i+tY-1), j:(j+tX-1));
        mat_A_under_ = mat_A_under - mean(mat_A_under);
        % compute numerator and denominator of the cross correlation
        numerator = sum(sum(mat_t_ .* mat_A_under_));
        denominator = sqrt(sum(sum(mat_t_.^2)) * sum(sum(mat_A_under_.^2)));
        mat_res(i,j) = numerator/denominator;
    end
end

%% figure
figure,
surf(mat_res);
figure(gcf)
