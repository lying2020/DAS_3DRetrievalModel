
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
% 
fittingType = 'nonlinear';  
[baseCoord, coeffModel, layerGridModel] = test_first(baseCoord, fittingType);
num = size(layerGridModel, 1);
%
ax1 = axes(figure);  hold(ax1, 'on');

for iFile = 1:num
  [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
    intervalX = 30;
    intervalY = 20;
    xMat = xMat(1: intervalX :end, 1: intervalY :end);
    yMat = yMat(1: intervalX :end, 1: intervalY :end);
    zMat = zMat(1: intervalX :end, 1: intervalY :end);
%
    layersurf(ax1, xMat, yMat, zMat);
    %
end

toc





