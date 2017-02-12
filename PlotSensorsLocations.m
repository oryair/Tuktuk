close all;
clear;

mData = xlsread('logbook - balmas.xlsx', 2);

mLocs = mData(:,1:3);
vNum  = mData(:,4);

figure; hold on; grid on; set(gca, 'FontSize', 24);
scatter3(mLocs(:,1), mLocs(:,2), mLocs(:,3), 100, vNum, 'Fill'); colorbar; axis equal;
xlabel('a(m)'); ylabel('b(m)'); zlabel('c(m)');
caxis([min(vNum), max(vNum)]);

x=-2:.1:2;
[X,Y] = meshgrid(x);

Z = 1.1 - 0*X;
surf(X, Y ,Z, 'FaceAlpha', 0.5, 'EdgeColor', 'None');
% shading flat

Z = .3 - 0*X;
surf(X, Y ,Z, 'FaceAlpha', 0.6, 'EdgeColor', 'None');
