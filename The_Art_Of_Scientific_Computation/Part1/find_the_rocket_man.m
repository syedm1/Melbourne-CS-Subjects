%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li                                               %
% Purpose:  Give two pictures, one is a part of another find the    %
%           corresponding position and mark it                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pos_y, pos_x] = find_the_rocket_man(pic_t, pic_A)
%% read images
pic_t = imread(pic_t);
pic_A = imread(pic_A);
mat_t = mean(pic_t, 3);
mat_A = mean(pic_A, 3);
[tY,tX] = size(mat_t);

%% compute cross correlation
tic;
% cross_corr = normalised_spatial_correlation_2d(mat_t,mat_A);
 cross_corr = my_norm_xcorr2(mat_A,mat_t);
run_time = toc

% max cross correlation position
[pos_y, pos_x] = find(cross_corr == max(max(cross_corr)));

%% plot cross correlation
figure
plot(cross_corr)
hold on

%% save marked image
imshow(pic_A);
hold on;
marker = plot(pic_A(1,1), 'o');
marker.XData = pos_x + tX/2;
marker.YData = pos_y + tY/2;
marker.MarkerSize = 50;
marker.LineWidth = 5;
marker.Color = 'b';
saveas(gcf, 're','png');

