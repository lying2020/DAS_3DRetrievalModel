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
% filename_sp = getfilenamelist(type, 'off');
% sensorposition = readtxtdata(filename_sp, type);

%% base Coord and well coordinate ...
% type = 'wellmodel';
% filename_well = getfilenamelist(type, 'off');
%  [baseCoord, wellCoordSet] = getwellmodel(filename_well, 'bottom', []);

%  filename_well = getfilenamelist('wellmodel', 'off'); 
%  wellCoordSet0 = readsavedata(filename_well);  
 
%  filename_base = getfilenamelist('basecoord', 'off'); 
% baseCoord = readsavedata(filename_base);  

wellCoordSet = importdata('wellData.mat');
baseCoord = [14620550.3 4650200.4 1514.78];
% wellCoordSet = wellCoordSet - [10.5, baseCoord];
%% sensor coordinate ...
% [undergroundCoord, overgroundCoord, Posi, Pz] = getsensorcoord(wellCoordSet, sensorposition);
% sensorCoordSet = [overgroundCoord; undergroundCoord];

% type = 'sensorcoord';
% filename_sc = getfilenamelist(type, 'off');
% sensorCoordSet0 = readsavedata(filename_sc);

%% layer model
% type = 'layer';
type = 'fault';
func_name = mfilename;
displaytimelog(['func: ', func_name]);

if exist('filenameList_layer', 'var')
    displaytimelog(['func: ', func_name, '. ', 'Variable filenameList_layer exists']);
else
    displaytimelog(['func: ', func_name, '. ', 'Variable filenameList_layer does not exist, now importdata ... ']);
    filenameList_layer = getfilenamelist(type);
end

tic
gridFlag = true; gridType = 'linear'; gridStepSize = [10, 10]; gridRetractionDist = [10, 10]; fittingType = 'nonlinear'; layerType = 'layer';
layerModelParam = struct('gridFlag', gridFlag, 'gridType', gridType, 'gridStepSize', gridStepSize, 'gridRetractionDist', gridRetractionDist, ...
                                                  'fittingType', fittingType, 'layerType', layerType, 'pathSave', []);
[baseCoord, layerCoeffModel, layerGridModel] = getlayermodel(filenameList_layer, baseCoord, layerModelParam);

t_layermodel = toc
% 
% -----------------------------------------------------------------------------------------------------
axs= axes(figure);
% layerGridModel = [];
[h1, h2, h3, h4, h5] = sourceplot3D(axs, layerGridModel, wellCoordSet) ; % , sensorCoord);

if strcmp(type, 'fault'),    colormap(axs, 'jet');    end
% axs = axes(figure);
% sourceplot3D(axs, [], wellModel, [], sourcePosition0);
% vArray = 0.001:0.001:2.0;     sourcePosition0 = zeros(length(vArray), 4);
% for i = 1: length(vArray)
%     sourcePosition0(i, :) = sourcelocation([],  vArray(i), posi(arr0(validSensor), :), wd(validSensor));
% end



