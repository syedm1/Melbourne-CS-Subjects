%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                    %
% Purpose:  Give two pictures, one is a part of another  %
%           find the corresponding position and mark it  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pic_R = find_the_rocket_man(pic_t, pic_A)

% read images
pic_t = imread(pic_t);
pic_A = imread(pic_A);
mat_t = mean(pic_t, 3);
mat_A = mean(pic_A, 3);
size_t = size(mat_t);

% compute cross correlation
tic;
cross_corr = normalised_spatial_correlation_2d(mat_t,mat_A);
run_time = toc

% max cross correlation position
[pos_y pos_x] = find(cross_corr == max(max(cross_corr)))

% save marked image
imshow(pic_A);
hold on;
marker = plot(pic_A(1,1), 'p');
marker.XData = pos_x+size_t(2)/2;
marker.YData = pos_y+size_t(1)/2;
marker.MarkerSize = 30;
marker.Color = 'r';
marker.MarkerFaceColor = 'r';
saveas(gcf, 're','png');

