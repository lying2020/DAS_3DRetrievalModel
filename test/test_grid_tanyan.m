
%
%
%
%
%
%
%
%
% close all;
clear
%%  -----------------------------------------------------------
%  DEBUG ! ! !
dbstop if error;   
format long
addpath(genpath('../../../include'));
% 
% baseCoord =  [14621234 4650653 2000];
baseCoord =  [14620730 4650330 1500];
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
type = 'layer';
layerdata = cell(num, 1);
inter = 10;

ax1 = axes(figure);  hold(ax1, 'on');
%ax2 = axes(figure);  hold(ax2, 'on');
for iFile = 1:num
    layerdata{iFile} = readlayerdata(filenameList{iFile});
end
layergriddata = grid_tanyan(layerdata,baseCoord,inter,150,300); % olddata
% layergriddata = grid_tanyan(layerdata,baseCoord,inter,20,20); % new data

  for iFile = 1:num
     figure(iFile);

    x = layergriddata{iFile,1};
    y = layergriddata{iFile,2};
    z = layergriddata{iFile,3};
     mesh( x, y, z);
%     colormap( 'hot');
% %      shading(ax1, 'interp');
% %      hold on
 end


