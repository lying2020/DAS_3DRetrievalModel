%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to calculate where the line segment intersects each layer               
%% -----------------------------------------------------------------------------------------------------
function  [intersectionSet, idxLayer, pointSet, coeffSet]  = computelayerintersectscoords(layerCoeffModel, layerGridModel, startpoint, endpoint)
% -----------------------------------------------------------------------------------------------------
% calculate the intersection points of a given surface and a given line
% INPUT:  
% layerCoeffModel: nomLayer* 1 cell. each cell contains (m -1)* (n -1) cell, and
% each cell contains a 1* numCoeff matrix. 
% each cell corresponds to a cubic polynomial fit parameter for each layer on each grid
%
% layerGridModel: numLayer* numDim cell. The discret point set of the given surface,
% each row of cells includes  a m* n matrix containing grid points data of x, y, z - direction of the same layer;
% layer data should be stored from top to bottom.
% 
% startpoint: 1* numDim matrix. The starting point of the given line;
% endpoint: 1* numDim matrix. The ending point of the given line;
%
% % type: fitting type: 'cubic'  | 'quad'  |  'linear'
%
% OUTPUT
% intersectionSet: num* 3 matrix, The intersection points of the given surface and the given line
% idxLayer: The index corresponding to the layer where the intersection is located
% pointsSet: num * 1 cell, each cell includes 4* numDim matrix 
% that represents the vertices of the small quadriateral
% coeffSet: num* 1 cell, each cell contains 1* numCoeff coefficient matrix.   
%% -----------------------------------------------------------------------------------------------------
% the layer is continuous data point 
if isa(layerGridModel{1}, 'function_handle')
    % [intersectionSet, idxLayer]  = layerintersection_surf(layerGridModel, startpoint, endpoint);
    pointSet = [];    coeffSet = [];
    return;
end
%
%% -----------------------------------------------------------------------------------------------------
%% the layer is discrete data point 
[intersectionSet, idxLayer] = deal([]);  %  initialize as empty matirx
numLayer = size(layerGridModel, 1);

%% initialize parameters
pointSet = cell(0);     coeffSet = cell(0); numPoints = 0;     np1 = 1; 
%%
for iLayer = 1 : numLayer % 3  %  
    %%  Find the quadrangle grid points of a line segment overlap with discrete points.
    [p4, rc] = computelayerintersectsgrids(layerGridModel{iLayer, 1}, layerGridModel{iLayer, 2}, layerGridModel{iLayer, 3}, startpoint, endpoint);

    %% the fitting polynomial coefficients set of the corresponding layer.
    coeffMat = layerCoeffModel{iLayer, 1};
    % -----------------------------------------------------------------------------------------------------
    last_intersection = [0, 0, 0];
    for ipoint = 1: length(p4)
        pts = p4{ipoint, 1}; %% pts: 4*3 matrix, quadrangle vertex coordinates.
        coeff = coeffMat{rc(ipoint, 1), rc(ipoint, 2)};
        %%  Find the intersection of a line segment and a small quadrangle().
        intersection  = solveintersection(coeff, pts, startpoint, endpoint);
        if isempty(intersection), continue; end
        % -----------------------------------------------------------------------------------------------------
        intersect_dist = last_intersection - intersection;
        if isempty(intersection) || (norm(intersect_dist(:, [1, 2])) < 10.0),  continue;   end
        last_intersection = intersection;
        %%  Updates the value of the output parameter
        numPoints = numPoints + 1;
        pointSet{numPoints, 1} = pts;
        coeffSet{numPoints, 1} = coeff;
        lp = size(intersection, 1); 
        intersectionSet( np1 : (np1 + lp - 1), :) = intersection; 
        idxLayer( np1 : (np1 + lp - 1), 1) = iLayer* ones(lp, 1);
        np1 = np1 + lp;

    end %  for ipoint = 1: length(p4)
    %
end % for iLayer = 1:numLayer

if isempty(intersectionSet)
    return;
end

%% If the endpoints are at the layer, they are removed.   
flag1 = find( rms(intersectionSet - startpoint, 2) < 1e-5, 1, 'first');
flag2 = find( rms(intersectionSet - endpoint, 2) < 1e-5, 1, 'first');
intersectionSet([flag1 flag2], :) = [];
idxLayer([flag1 flag2]) = [];
end   % function computelayerintersectscoords(layerCoeffModel, layerGridModel, startpoint, endpoint)















