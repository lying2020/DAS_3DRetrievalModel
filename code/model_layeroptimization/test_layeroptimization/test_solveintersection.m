
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
%% --------------------------------------------------------------------
for iFile = 1:num
    [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
    %  ----------------------------------
     [p4, rc] = computelayerintersectsgrids(xMat, yMat, zMat, startpoint, endpoint);
    for iP4 = 1:length(p4)
        tmp = p4{iP4, 1};
         pts = p4{ipoint, 1}; % pts: 4*3 matrix, quadrangle vertex coordinates.
        coeff = coeffMat{rc(ipoint, 1), rc(ipoint, 2)};
        
       intersection = solveintersection(coeff, tmp, se(1, :), se(2, :));
%         [intersection, gridsfunc, resnorm] = solveintersection(tmp, startpoint, endpoint);
        if ~isempty(intersection)
%
            intersects = [intersects; intersection];  
            %
            plot3(ax1, [tmp(:, 1); tmp(1, 1)], [tmp(:, 2); tmp(1, 2)], [tmp(:, 3); tmp(1, 3)], 'r-', 'linewidth', 1.5);
            patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), abs(tmp(:, 3))/norm(tmp(:, 3)));
            scatter3(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), 20, 'filled');
            %
            scatter3(ax1, intersection(:, 1), intersection(:, 2), intersection(:, 3), 100, 'filled');
        end
    end
%
end
xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');











