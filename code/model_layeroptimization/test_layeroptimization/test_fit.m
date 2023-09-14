
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
%% This code is used to function fit the layer model
type = 'layer';
filenameList = getfilenamelist(type);
% filenameList is a cell array
num = length(filenameList);
% layerGridModel: num* 3 cell, each row contains xMat, yMat, zMat grid point data.
layerGridModel = cell(num, 3);
% 
%  sequence the layer from top to bottom
meanZ = zeros(num, 1);
% base coordinate. 
 baseCoord = [14620550.3 4650200.4 1514.78];
% 
ax1 = axes(figure);  hold(ax1, 'on');
for iFile = 1:num
    % layerTmp is a n*5 matrix. 
    layerTmp= readtxtdata(filenameList{iFile}, type);
    [xMat, yMat, zMat] = layerdata(layerTmp, baseCoord, type);
    % 
    layerGridModel(iFile, 1:3)= {xMat, yMat, zMat};
    meanZ(iFile, 1) = mean(mean(zMat));
    layersurf(ax1, xMat, yMat, zMat);
    %  
end
%% 
% sequence the layer from top to bottom  
[~, idxZ] = sort(meanZ, 'descend');
layerGridModel = layerGridModel(idxZ, :);
%
%% get fitting polynomial function ceofficientions
COEFF = cell(num, 1);
%
ax2 = axes(figure);     hold(ax2, 'on');
for iFile = 1:num
     [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
    %
func = fit([xMat(:) yMat(:)], zMat(:), 'poly33', 'Exclude', [1 10 25]);
COEFF{iFile, 1} = func;
% zhat = func(mean( xMat(:) ), mean( yMat(:) ));
figure
plot(func, [xMat(:) yMat(:)], zMat(:), 'Exclude', [1 10 25]); 
title('Fit with data points 1, 10, and 25 excluded')
% 
    layersurf(ax2, xMat, yMat, func(xMat, yMat));

end

















