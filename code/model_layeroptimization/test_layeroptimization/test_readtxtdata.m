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
%% 
baseCoord = [14620550.3 4650200.4 1514.78];
type = 'layer';
filenameList = getfilenamelist(type);
num = length(filenameList);
layerGridModel = cell(num, 1);
% 
ax2 = axes(figure(3));  hold(ax2, 'on');
for iFile = 1:num
    layerTmp = readtxtdata(filenameList{iFile}, type);
%     layerTmp = readlayerdata(filenameList{iFile});
    [xMat, yMat, zMat] = layerdata(layerTmp, baseCoord);
    layersurf(ax2, xMat, yMat, zMat);
end


