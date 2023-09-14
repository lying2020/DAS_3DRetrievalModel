%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to correct the original grid point data    
%% -----------------------------------------------------------------------------------------------------
function [X, Y, Z] = gridcorrection(xMat, yMat, zMat, layerGridModel, iFile)
% -----------------------------------------------------------------------------------------------------
% INPUT: 
% xMat, yMat, zMat:  n *m, x, y z coordinates of the grid point.  (网格点上的x, y坐标)
% OUTPUT:
% X, Y, Z: the x, y, z grid point coordinates after interpolation.
%% -----------------------------------------------------------------------------------------------------
[xLen, yLen] = size(xMat);

 layer = layerGridModel{iFile};
[points, idx] = unique(layer(:, 1:3), 'rows');
idx = sort(idx);
A = (1: length(layer))';
sd = setdiff(A, idx);
lm = layer(sd, 1:3);
















