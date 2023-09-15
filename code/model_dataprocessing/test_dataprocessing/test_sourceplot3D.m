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
% %
% %% 平面地层。
% n = 1;
% tmp = [18, 11, -13] + rand(50, 3)*10 - 6;
% layerGridModel = [ 0.0   -4   -5   -9.2   -11   -12.1 -17.5   -20.5 ]' * n;
% velocityModel = [ 4.1  4.5  4.8    5.1   5.4     5.7     6.7    6.8 ]; % * n;
% overgroundCoord = [2, 3.8, 0; 4, 4, 0;  4,  2, 0; 4, 1, 0; 4, -4,  0;  1, -4, 0; -2, -4, 0; -3, -4, 0;  -4, -4, 0; -4, 4,  0;  -3,  4, 0];
% undergroundCoord = [ 0, 0, 0; 0, 0, -3; 0, 0.0, -8; 0, 0, -10; 0, 0, -14.4; 0, -0, -16; 0, 0, -18];
% sensorCoordSet = [ overgroundCoord; undergroundCoord]* n;
% sourceCoordSet =   [ 21, 2, -13;   4.2,  3,  -8.8;  4.2, 1.2,  -9.1;  4,  3, -10;  3, 4, -14;   16, 11, -13 ; 2, 3,   -9; tmp]* n;
% deepth = layerGridModel(end); % uint: m
% n1 = 10;
% wellModel  = []; %  [zeros(n1, 1), zeros(n1, 1), flip(linspace(deepth, 0, n1)')];  %
% ax1 = axes(figure);
% % sourceplot3D(ax1);
% [h1, h2, h3, h4, h5] = sourceplot3D(ax1, layerGridModel, wellModel, sensorCoordSet, sourceCoordSet);
%  delete([h1, h2, h3, h4, h5]);
%


%% 离散曲面地层

%% sensor coordinates.
 type = 'sensorcoord';
filename_sc = getfilenamelist(type, 'off');
sensorCoordSet0 = readsavedata(filename_sc);
arr = 79:217;
sensorCoord = sensorCoordSet0(arr, :);

%% base coord
baseCoord = [14620550.3 4650200.4 1514.78];

%% layer model
type = 'layer';
filenameList_layer = getfilenamelist(type);
% tic
[baseCoord, layerCoeffModel, layerGridModel] = getlayermodel(filenameList_layer, baseCoord);
% t_layermodel = toc

%% 
axs= axes(figure);   hold(axs, 'on');
sourceplot3D(axs, [], [], sensorCoord);
% layerGridModel = [];
sourceplot3D(axs, layerGridModel, [], []);

%% fault model
type = 'fault';
filenameList_fault = getfilenamelist(type);
[baseCoord, ~, faultModel] = getlayermodel(filenameList_fault, baseCoord, 'linear', 'fault');
axs= axes(figure);     hold(axs, 'on');
sourceplot3D(axs, faultModel, [], []);
% -----------------------------------------------------------------------------------------------------
faultCoordSet = [];
 figure; hold on;
 for i = 1: size(faultModel, 1)
 [x, y, z] = faultModel{i, :};
 faultCoordSet = [faultCoordSet; x(:), y(:), z(:)];
 plot3(x(:), y(:), z(:), 'r.')
 
 end




















