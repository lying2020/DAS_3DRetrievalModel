%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% 
 %% -----------------------------------------------------------------------------------------------------
function [baseCoord, layerCoeffModel, layerGridModel, ax1] = test_first(baseCoord, fittingType, type)
% layerGridModel: num* 3 cell, each row contains xMat, yMat, zMat grid point data.
% layerCoeffModel: num* 1 cell, each row contains (m-1)*(n-1) cell, 
% each cell contains 1*10 coeff matrix.
%% -----------------------------------------------------------------------------------------------------
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
%
if nargin < 3, type = 'layer';   end
if nargin < 2, fittingType = 'nonlinear';   end
if nargin < 1, baseCoord = [0 0 0];  end
%
filenameList = getfilenamelist(type);
% filenameList is a cell array
num = length(filenameList);
% layerGridModel = cell(num, 3);
[baseCoord, layerCoeffModel, layerGridModel] = getlayermodel(filenameList, baseCoord, fittingType, type);

ax1 = axes(figure);  hold(ax1, 'on');
for iFile = 1:num
    [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
    %      interval = 10;
    %      xMat = xMat(1: interval :end, 1: interval :end);
    %      yMat = yMat(1: interval :end, 1: interval :end);
    %      zMat = zMat(1: interval :end, 1: interval :end);
    %      T = delaunay(xMat, yMat);
    %      trisurf(ax1, T,xMat,yMat,zMat)
    %      scatter3(ax1, xMat(:), yMat(:), zMat(:), 30, zMat(:));
    layersurf(ax1, xMat, yMat, zMat);
    %
end








