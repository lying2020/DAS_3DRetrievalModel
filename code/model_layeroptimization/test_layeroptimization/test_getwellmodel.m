%
%
%
% close all;
% clear
clc
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
% -----------------------------------------------------------------------------------------------------
%
%% sensor relative position ...
% type = 'sensorposition';
%   filename_sp = getfilenamelist(type, 'off');
% sensorposition = readtxtdata(filename_sp, type);

%% baseCoord and well coordinate ...
type = 'wellmodel';
% filename_well = getfilenamelist(type, 'off');
 [baseCoord, wellCoordSet] = getwellmodel(filename_well, 'bottom', []);

 %% well...   .csv 
%  filename_well = getfilenamelist('wellmodel', 'off'); 
%  wellCoordSet0 = readsavedata(filename_well);  
 
 %% baseCoord...  .csv 
%  filename_base = getfilenamelist('basecoord', 'off'); 
% baseCoord0 = readsavedata(filename_base);  

% wellCoordSet = importdata('wellModel4.mat');
% baseCoord = [14620550.3 4650200.4 1514.78];

z = wellCoordSet(:, end);  zLen = length(z);  
layerModel = linspace(z(1), z(end), min(8, zLen));
% -----------------------------------------------------------------------------------------------------
axs= axes(figure);
% layerModel = [];
[h1, h2, h3, h4, h5] = sourceplot3D(axs, layerModel, wellCoordSet) ; % , sensorCoord);


% axs = axes(figure);
% sourceplot3D(axs, [], wellModel, [], sourcePosition0);
% vArray = 0.001:0.001:2.0;     sourcePosition0 = zeros(length(vArray), 4);
% for i = 1: length(vArray)
%     sourcePosition0(i, :) = sourcelocation([],  vArray(i), posi(arr0(validSensor), :), wd(validSensor));
% end



