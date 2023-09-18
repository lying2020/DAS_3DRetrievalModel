
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
fittingType = 'nonlinear';  
[baseCoord, layerCoeffModel, layerGridModel, ax1] = test_first(baseCoord, fittingType);
num = size(layerGridModel, 1);
%
%% --------------------------------------------
% ax1 = axes(figure);
hold(ax1, 'on');
scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'filled');
plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 1.5);
%% ---------------------------------------------------------------------------
for iFile = 1:num
    [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
    coeffMat = layerCoeffModel{iFile, 1};
    xx = [xMat(10, 10), xMat(10, 10) - 2.6, xMat(12, 11) ];
    yy = [yMat(15, 13), yMat(15, 13) - 6.3,  yMat(18, 14) - 2.1];
    for i = 1:length(xx)
        xy0 = [xx(i), yy(i)];
        [z0, sol, rc] = zvalue(coeffMat, xMat, yMat, xy0);
        scatter3(ax1, xy0(1), xy0(2), z0, 100, 'filled');
        %% ------------------------------------------------------
        [numRow, ~] = size(xMat);
        r =  sol - (ceil(sol / numRow) - 1) * numRow;
        c = ceil(sol / numRow);    %% ceil: round up to an integer
        rowArray = min(r): max(r);
        colArray = min(c): max(c);
        if isempty(rowArray) || isempty(colArray)
            z0 = [];
            return;
        end
        xMat1 = xMat(rowArray, colArray);
        yMat1 = yMat(rowArray, colArray);
        zMat1 = zMat(rowArray, colArray);
        ax2 = axes(figure);  hold(ax2, 'on');
        scatter3(ax2, xMat(sol), yMat(sol), zMat(sol), 30, 'MarkerFaceColor', [0 0 0]);
%         scatter3(ax2, points(:, 1), points(:, 2), points(:, 3), 80);  % , 'filled');
        %         surf(ax2, xMat1, yMat1, zMat1, zMat1.*zMat1);
        shading(ax2, 'interp');
        scatter3(ax2,  xy0(1), xy0(2), z0, 100, 'filled');
%         pointsinterpolation(points, 1, 0.1, 'natural', ax2);
        pointsinterpolation([xMat1(:), yMat1(:), zMat1(:)], 1, 0.1, 'natural', ax2);
        displaytimelog(' all is ok !');
    end
    
end





