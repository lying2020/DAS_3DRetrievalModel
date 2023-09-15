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
%
baseCoord = [14620550.3, 4650200.4, 1514.78];
%% filenameList is a cell array
layerType = 'layer';   %  'fault';      % 
filenameList = getfilenamelist(layerType);
num = length(filenameList);
% fittingType = 'nonlinear';
[layerCoeffModel, layerGridModel] = deal(cell(num, 3));
% [baseCoord, layerCoeffModel, layerGridModel] = getlayermodel(filenameList, baseCoord, fittingType, type);
layerTmp = cell(num, 1);
for iFile = 1:num
    %% layerTmp is a n*5 matrix.
    layerTmp{iFile, 1} = readtxtdata(filenameList{iFile}, layerType);
    %% xMat is a m* n matrix.
    [xMat, yMat, zMat] = layerdata(layerTmp{iFile, 1}, baseCoord, layerType);
    layerGridModel(iFile, 1:3)= {xMat, yMat, zMat};
end
%
%% --------------------------------------------
% ax1 = axes(figure);    hold(ax1, 'on');
ax1 = axes(figure);  hold(ax1, 'on');
ax2 = axes(figure);  hold(ax2, 'on');
for iFile = 1:num
    [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
    layersurf(ax1, xMat, yMat, zMat);
    %     colormap(ax1, 'hot');
    %shading(ax1, 'interp');
    %% ------------------------------------------------
    % ÌÞ³ýÖØ¸´×ø±êÐÐ
    layer = layerTmp{iFile};
    [points, idx] = unique(layer(:, 1:3), 'rows');
    idx = sort(idx);
    A = (1: length(layer))';
    sd = setdiff(A, idx);
    lm = layer(sd, 1:3);
    scatter3(ax1, lm(:, 1), lm(:, 2), lm(:, 3), 10, 'MarkerFaceColor', [0 0 0]);
    %% ------------------------------------------------
    scatter3(ax2, xMat(:), yMat(:), zMat(:), 10, 'MarkerFaceColor', [0 0 0]);
end
%% ------------------------------------------------
xlabel(ax2, 'x /m');   ylabel(ax2, 'y /m');  zlabel(ax2, 'z /m');
xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');

ax2 = axes(figure);
sourceplot3D(ax2, layerGridModel, [], [], []);

