
%
%
%
%
%
%
%
%
close all;
clear
%%  -----------------------------------------------------------
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../include'));
%
[fileName, pathName] = uigetfile({'*.*'; '*.txt'; '*.mat'}, ' Select the TXT-file ',  'MultiSelect', 'on');
%
if  isa(fileName, 'numeric'), return;  end
%
filenameList = fullfile(pathName, fileName);
%
if isa(filenameList, 'char')
    tmp{1, 1} = filenameList;
    filenameList = tmp;
end
% filenameList is a cell array
num = length(filenameList);

layerdata = cell(num, 1);
inter = 10;
baseCoord =  [14621234 4650653 2000];
% ax1 = axes(figure);  hold(ax1, 'on');
% ax2 = axes(figure);  hold(ax2, 'on');
for iFile = 1:num
    layerdata{iFile} = readlayerdata(filenameList{iFile});
end

layerGridModel = grid_tanyan(layerdata,baseCoord,inter,100,250);
[layerCoeffModel, layerCoeffModel_zdomain] = fitting_tanyan(layerGridModel);

for iFile = 1:num
    figure(iFile);
    x = layerGridModel{iFile,1};
    y = layerGridModel{iFile,2};
    z = layerGridModel{iFile,3};
    surf(x, y, z, z.*z);
    %     colormap(ax1, 'hot');
    shading('interp');
    hold on
    xx = [x(10, 10), x(10, 10) - 2.6, x(12, 11) ];
    yy = [y(15, 13), y(15, 13) - 6.3,  y(18, 14) - 2.1];
    idxLayer = [1 1 1];
    xyArray = [xx;yy]';
    zArray = layerz_tanyan(layerCoeffModel,layerGridModel,xyArray,idxLayer);
    for i =1:3
        plot3(xyArray(i,1),xyArray(i,2),zArray(i),'b.','markersize',10);hold on
    end
        displaytimelog(' all is ok !');
        
    
end
