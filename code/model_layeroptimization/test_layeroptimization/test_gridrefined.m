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
%% layer and fault model.
% faultModel = importdata('faultModel31.mat');
faultModel = importdata('faultModel3.mat');
layerModel = importdata('layerModel6.mat');

% points= [0 0 0; 4 4 4; 0 3.2 4; 8 0 0 ];
points = [1, 0, 0; 0, 1, 0; 0, 0, 1; 1, 1, 1; 0.5, 0.5, 1; 0.5, 0.5, 0];
%  [X, Y, Z] = pointsinterpolation(points, 1, 0.01, 'cubic', axes(figure));
 
 [xMat, yMat, zMat] = faultModel{1, :};
[xMat0, yMat0, zMat0]  = gridrefined(xMat, yMat, zMat, [50 2], 'linear');
 
ax1 = axes(figure);  hold(ax1, 'on');
 layersurf(ax1, xMat0, yMat0, zMat0);
 plot3(ax1, xMat(:), yMat(:), zMat(:), 'bo', 'linewidth', 0.6);
  plot3(ax1, xMat0(:), yMat0(:), zMat0(:), 'r.');
  
%   points = [xMat0(:), yMat0(:), zMat0(:)];
%     [X, Y, Z] = pointsinterpolation(points, 10, 10, 'cubic', axes(figure));
    
% F = scatteredInterpolant(xMat, yMat, zMat);	
% %%
 faultCoordSet = [];
%  
refinedFaultModel3 = cell(3, 3);
 ax2 = axes(figure); hold(ax2, 'on');
 for i = 1: size(faultModel, 1)
 [xMat, yMat, zMat] = faultModel{i, :};
      [xMat0, yMat0, zMat0]  = gridrefined(xMat, yMat, zMat, [20 1], 'linear');
      refinedFaultModel3(i, :) = {xMat0, yMat0, zMat0};
 faultCoordSet = [faultCoordSet; xMat0(:), yMat0(:), zMat0(:)];
%  scatter3(ax2, xMat0(:), yMat0(:), zMat0(:), 'r.')
 layersurf(ax2, xMat0, yMat0, zMat0);
 plot3(ax2, xMat(:), yMat(:), zMat(:), 'r.');
 end
 
%  
%  
%  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 