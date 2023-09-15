%
%
%
%
% clc
% close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
% 
%% base coord
baseCoord = [14620550.3 4650200.4 1514.78];
layerType = 'layer';
% fittingType = 'nonlinear';
fittingType = 'cubic';
flag = 'v3';
% filenameList = getfilenamelist(layerType);
% num = length(filenameList);
% [baseCoord, layerCoeffModel, layerGridModel] = getlayermodel(filenameList, baseCoord, fittingType, layerType);

%% -----------------------------------------------------------------------------------------------------
sp =  [14621234 4650653 2000; 14619460 4650140 -110;   14619580 4650100 -2130; 14619460,4650100,-2110; 14619460 4650140 -2110; 14619430 4650140 -2000; 14620022 4650108 1200; 14619240 4650620 -800];  %
ep =   [14619869 4649742 -2990; 14618970 4649700 -2300; 14618900 4649720 -2250; 14618900,4649720,-2340; 14618870 4649700 -2300; 14618920 4649740 -2300];
n = 1;
startpoint = sp(n, :) - baseCoord;
endpoint = ep(n, :) - baseCoord;
se = [startpoint; endpoint];
% ax1 = axes(figure);  hold(ax1, 'on');
% scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'filled');
% plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 4.5);
% %

velocityModel=[4.5, 3.5, 4.2, 5.1, 4.8, 4.4, 5.4, 6, 4.4, 4.1, 3.8, 3.9, 4.9, 5.2, 4.8]';
[realCoordSet, totalTime, initialCoordSet, velocity] = computeraytrace_curve(layerCoeffModel, layerGridModel,  velocityModel,  startpoint,  endpoint, flag);

% plotrefraction(realCoordSet, initialCoordSet, ax1);
[~, initialTime] = getratiotime(velocity, initialCoordSet)
[~, realTime] = getratiotime(velocity, realCoordSet)

return; 

%% -----------------------------------------------------------------------------------------------------
% 
sensorCoordSet=[2.0, 1, 5.3;
                              0.0, 0, 5.0; 
                              2.0, 0, 5.3];
%
sourceCoordSet=[7, 5.4, -7.6; 
                               5, 7.0, -2.3];
n = 1;
sensorCoord = sensorCoordSet(n, :);
sourceCoord = sourceCoordSet(n, :);
%
layerHeight = [4.5, 3.1, 1.0, -0.5, -2.0, -3.0, -3.5, -4.0, -4.5 -6.0, -6.5]';
velocityModel= [4.5, 3.5, 2.0, 5.1, 4.8, 4.4, 5.4, 6.0, 4.4, 6.1, 5.5, 4.8, 5.2]';
%
%% -------------------------------------------------------------
numConst = length(layerHeight);
layerGridModel = cell(numConst, 1);
for i = 1: numConst
layer = @(x,y,z) -x^2*y^2/5000 + sin(x*y)  + layerHeight(i) - z;
layerGridModel{i} = layer;
end
%  
% layerGridModel2 = @(x,y,z) -x^2*y^2/5000+1-z;
% layerGridModel3 = @(x,y,z) -x^2*y^2/5000-0.5-z;
% layerGridModel4= @(x,y,z) -x^2*y^2/5000-3-z;
% layerGridModel5= @(x,y,z) -x^2*y^2/5000-3.5-z;
% layerGridModel6= @(x,y,z) -x^2*y^2/5000-4-z;
% layerGridModel = {layerGridModel1, layerGridModel2, layerGridModel3, layerGridModel4, layerGridModel5, layerGridModel6};
%% -------------------------------------------------------------
[realCoordSet, totalTime, initialCoordSet, velocity] = computeraytrace_curve(layerCoeffModel, layerGridModel,  velocityModel,  sensorCoord,  sourceCoord)
%
numDim = length(sensorCoord);
st = sortrows( [ sensorCoord; initialCoordSet; sourceCoord ],  -numDim);
%% -----------------------------------------------------
X= 0:0.1:10;
Y= 0:0.1:10;
[X,Y] = meshgrid(X,Y);
Z = cell(numConst, 1);
ax1 = axes(figure);
hold(ax1, 'on');
for i = 1:numConst
Z{i} = -(Y).^2.*(X).^2/5000 + layerHeight(i);
 surf(ax1, X,Y,Z{i},'EdgeColor', 'none');
end
%% -------------------------------------------------------
%
plotrefraction(realCoordSet, initialCoordSet, ax1);
[~, initialTime] = getratiotime(velocity, initialCoordSet)
[~, realTime] = getratiotime(velocity, realCoordSet)





