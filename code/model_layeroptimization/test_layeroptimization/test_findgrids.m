
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
typeFitting = 'nonlinear';  
[baseCoord, layerCoeffModel, layerGridModel] = test_first(baseCoord, typeFitting);
%
%% --------------------------------------------
% ax1 = axes(figure);     hold(ax1, 'on');
%% 投影到不同的面去解决交点的问题
ax1 = axes(figure);  hold(ax1, 'on');
ax2 = axes(figure);  hold(ax2, 'on');
ax3 = axes(figure);  hold(ax3, 'on');

scatter(ax1, se(:, 1), se(:, 2), 50, 'MarkerFaceColor', [0 0 0]);
plot(ax1, se(:, 1), se(:, 2),  'b-', 'linewidth', 2.5);
xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');

scatter(ax2, se(:, 1), se(:, 3), 50, 'MarkerFaceColor', [0 0 0]);
plot(ax2, se(:, 1), se(:, 3),  'b-', 'linewidth', 2.5);
xlabel(ax2, 'x /m');   ylabel(ax2, 'z /m');

scatter(ax3, se(:, 2), se(:, 3), 50, 'MarkerFaceColor', [0 0 0]);
plot(ax3, se(:, 2), se(:, 3),  'b-', 'linewidth', 2.5);
xlabel(ax3, 'y /m');  ylabel(ax3, 'z /m');
num = size(layerGridModel, 1);
for iFile = 1:num 
  
  [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
    %     interval = 10;
    %     x = x(1: interval :end, 1: interval :end);
    %     y = y(1: interval :end, 1: interval :end);
    %     z = z(1: interval :end, 1: interval :end);
    %  
    plot(ax1, xMat(:), yMat(:), ':', 'linewidth', 1.1);
    plot(ax2, xMat(:), zMat(:), ':', 'linewidth', 1.1);
    plot(ax3, yMat(:), zMat(:), ':', 'linewidth', 1.1);
    %
    seq = findlayerintersectsgridsseq(xMat, yMat, startpoint, endpoint);
    
    %
end











