%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Receive two matrix, t(template) and A(search region)    %
%           return cross correlation of these two matrix            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mat_res = spatial_correlation_2d(mat_t, mat_A)
%% init mat_res with 0
[tY,tX] = size(mat_t);
[AY,AX] = size(mat_A);
mat_res = zeros(AY-tY+1, AX-tX+1);
[rY,rX] = size(mat_res);

%% cross correlation
for i = 1:rY
    for j = 1:rX
        % compute mat_res(i,j)
        % first get the part of mat_A covered by the mat_t 
        mat_A_under = mat_A(i:(i+tY-1), j:(j+tX-1));
        % compute numerator and denominator of the cross correlation
        mat_res(i,j) = sum(sum(mat_t .* mat_A_under));
    end
end

%% figure
figure,
surf(mat_res);
figure(gcf)
