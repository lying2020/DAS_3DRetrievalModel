
%
%
%
% close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
%

baseCoord = [14620550.3 4650200.4 1514.78];
%% --------------------------------------------
sp =  [14621234 4650653 -2000.00; 14619460 4650140 -110;   14619580 4650100 -2130; 14619460,4650100,-2110; 14619460 4650140 -2110; 14619430 4650140 -2000; 14620022 4650108 1200; 14619240 4650620 -800];  %
ep =   [14619869 4649742 -2990; 14618970 4649700 -2300; 14618900 4649720 -2250; 14618900,4649720,-2340; 14618870 4649700 -2300; 14618920 4649740 -2300];
%% --------------------------------------------
n = 1;
startpoint = sp(n, :);
endpoint = ep(n, :);
% baseCoord = startpoint; % [14621234 4650653 2000];
se = [startpoint; endpoint] - baseCoord;
%
% fittingType = 'nonlinear';
fittingType = 'cubic';
[baseCoord, layerCoeffModel, layerGridModel, layerRangeModel, ax1] = test_first(baseCoord, fittingType);
num = size(layerGridModel, 1);
%
%% --------------------------------------------
ax1 = axes(figure); 
hold(ax1, 'on');
scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'filled');
plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 1.5);
%% ---------------------------------------------------------------------------
for iFile = 1:num
    [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
%%
        p4 =  computelayerintersectsgrids(xMat, yMat, zMat, se(1, :), se(2, :));
%     p4 = points4(x, y, z, se(1, :), se(2, :));
%  ---------------------------------------------------------------------------------
    for iP4 = 1:length(p4)
        tmp = p4{iP4, 1};
        plot3(ax1, [tmp(:, 1); tmp(1, 1)], [tmp(:, 2); tmp(1, 2)], [tmp(:, 3); tmp(1, 3)], 'r-', 'linewidth', 1.5);
        patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), abs(tmp(:, 3))/norm(tmp(:, 3)));
        scatter3(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), 20, 'MarkerFaceColor', [0 0 0]);
        % 测试四点是否在直线不同侧
        for jTmp = 1: size(tmp, 1)
            st = [se(1, :); tmp(jTmp, :)];             
            plot3(ax1, st(:, 1), st(:, 2), st(:, 3), 'b-');
        end      
    end   
    
end
%%  ------------------------------------------------------------------------------------
% # test 1

tic
%
[intersection1, idxLayer, pointSet, coeffSet]  = computelayerintersectscoords(layerCoeffModel, layerGridModel, layerRangeModel, se(1, :), se(2, :));
%
    for ips = 1:length(pointSet)
        tmp = pointSet{ips, 1};
        plot3(ax1, [tmp(:, 1); tmp(1, 1)], [tmp(:, 2); tmp(1, 2)], [tmp(:, 3); tmp(1, 3)], 'r-', 'linewidth', 1.5);
        patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), abs(tmp(:, 3))/norm(tmp(:, 3)));
        scatter3(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), 20, 'MarkerFaceColor', [0 0 0]);
        % 测试四点是否在直线不同侧
        for jTmp = 1: size(tmp, 1)
            st = [se(1, :); tmp(jTmp, :)];
            plot3(ax1, st(:, 1), st(:, 2), st(:, 3), 'b-');
        end
    end
    
[intersection2, idxLayer2] = layerintersects_tanyan(layerCoeffModel, layerGridModel, layerRangeModel, se(1, :), se(2, :));
if ~isempty(intersection2)
    scatter3(ax1, intersection2(:, 1), intersection2(:, 2), intersection2(:, 3), 'g', 100, 'filled');
end

if ~isempty(intersection1)
    scatter3(ax1, intersection1(:, 1), intersection1(:, 2), intersection1(:, 3), 100, 'filled');
end
xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');

%
%
%% -------------------------------------------------------------------------------------
% # test 2
%  p4surf(coeffSet, pointSet, intersection1, se);
%
%

toc





