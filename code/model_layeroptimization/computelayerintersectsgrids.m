%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to find the rectangular grid coordinates where the line intersects the layer
%% -----------------------------------------------------------------------------------------------------
function [points4, rc_array] = computelayerintersectsgrids(xMat, yMat, zMat, layerRange, startpoint, endpoint)
% -----------------------------------------------------------------------------------------------------
% 找到直线与地层的交点所在的矩形网格点坐标
% INPUT:
% xMat, yMat, zMat:  n *m, x, y z coordinates of the grid point.  (网格点上的x, y坐标)
% sartpoint, endpoint: startpoint and endpoint of a line segment.
%
% OUTPUT:
% p4: num * 1 cell, each cell includes 4* numDim matrix, that represents the vertices of the small quadriateral
% rc_array: num* 2 matrix, each row conains row and column indexes of the lower left vertex of the small quadrilateral(四边形)
% [numRow, numCol] = size(xMat);
% Check the validity of the inputs
assert(isequal(size(xMat), size(yMat), size(zMat)), 'xMat, yMat, and zMat must be of the same size.');
assert(isequal(size(startpoint), [1, 3]) && isequal(size(endpoint), [1, 3]), 'startpoint and endpoint must be 1x3 vectors.');
assert(~isequal(startpoint, endpoint), 'startpoint and endpoint must not be equal.');

%% -----------------------------------------------------------------------------------------------------
% ax1 = axes(figure);  hold(ax1, 'on');
% seCoords = [startpoint; endpoint];
% scatter3(ax1, seCoords(:, 1), seCoords(:, 2), seCoords(:, 3), 50, 'red', 'filled');
%  layersurf(ax1, xMat, yMat, zMat);
%  plot3(ax1, seCoords(:, 1), seCoords(:, 2), seCoords(:, 3), 'b:', 'linewidth', 1.5);
% displaytimelog(['startpoint: ', num2str(startpoint), ', endpoint: ', num2str(endpoint)]);
% 

% zRange = [min(zMat(:)), max(zMat(:))];
zRange = [layerRange(3, 1), layerRange(3, 2)];
[startpoint, endpoint] = compute_overlap_z(zRange, startpoint, endpoint);

% ax1 = axes(figure);  hold(ax1, 'on');
% seCoords = [startpoint; endpoint];
% scatter3(ax1, seCoords(:, 1), seCoords(:, 2), seCoords(:, 3), 50, 'filled');
% layersurf(ax1, xMat, yMat, zMat);
% plot3(ax1, seCoords(:, 1), seCoords(:, 2), seCoords(:, 3), 'k-', 'linewidth', 4.5);
% displaytimelog(['startpoint: ', num2str(startpoint), ', endpoint: ', num2str(endpoint)]);

 
% [xMat, yMat, zMat] = findoverlaparea0(xMat, yMat, zMat, startpoint, endpoint);
[xMat, yMat, zMat, rcStart] = findoverlaparea(xMat, yMat, zMat, startpoint, endpoint);
if (isempty(xMat) || isempty(yMat))
    points4 = cell(0);
    rc_array = [];
    return;
end

% scatter3(ax1, xMat(:), yMat(:), zMat(:), 10, 'red', 'filled');

% xy_seq = findlayerintersectsgridsseq(xMat, yMat, startpoint([1, 2]), endpoint([1, 2]));
% xz_seq = findlayerintersectsgridsseq(xMat, zMat, startpoint([1, 3]), endpoint([1, 3]));
% yz_seq = findlayerintersectsgridsseq(yMat, zMat, startpoint([2, 3]), endpoint([2, 3]));

xy_seq = findlayerintersectsgridsseq(xMat, yMat, startpoint([1, 2]), endpoint([1, 2]) );
xz_seq = findlayerintersectsgridsseq(xMat, zMat, startpoint([1, 3]), endpoint([1, 3]), xy_seq);
yz_seq = findlayerintersectsgridsseq(yMat, zMat, startpoint([2, 3]), endpoint([2, 3]), xz_seq);

% [xy_seq,  xy_rArray, xy_cArray] = findlayerintersectsgridsseq(xMat, yMat, startpoint([1, 2]), endpoint([1, 2]) );
% [xz_seq, xz_rArray, xz_cArray] = findlayerintersectsgridsseq(xMat, zMat, startpoint([1, 3]), endpoint([1, 3]) );
% [yz_seq, yz_rArray, yz_cArray] = findlayerintersectsgridsseq(yMat, zMat, startpoint([2, 3]), endpoint([2, 3]) );

% xy_seq = findlayerintersectsgridsseq_new(xMat, yMat, startpoint([1, 2]), endpoint([1, 2]) );
% xz_seq = findlayerintersectsgridsseq_new(xMat, zMat, startpoint([1, 3]), endpoint([1, 3]) );
% yz_seq = findlayerintersectsgridsseq_new(yMat, zMat, startpoint([2, 3]), endpoint([2, 3]) );

% func_findlayerintersectsgridsseq = @findlayerintersectsgridsseq;
% func_findlayerintersectsgridsseq = @findlayerintersectsgridsseq_new;
% xy_seq = func_findlayerintersectsgridsseq(xMat, yMat, startpoint([1, 2]), endpoint([1, 2]) );
% xz_seq = func_findlayerintersectsgridsseq(xMat, zMat, startpoint([1, 3]), endpoint([1, 3]) );
% yz_seq = func_findlayerintersectsgridsseq(yMat, zMat, startpoint([2, 3]), endpoint([2, 3]) );

seq = intersect(xy_seq, xz_seq);
seq = intersect(yz_seq, seq);
if isempty(seq)
    points4 = cell(0);
    rc_array = [];
    return;
end

% seq = rowMat* (col_array - 1) + seq;
[rowMat, ~] = size(xMat);
row_array =  seq - (ceil(seq / rowMat) - 1) * rowMat; % mod(seq, rowMat);  
col_array  = ceil(seq/ rowMat);      % ceil: round up to an integer

num_row_array = length(seq);
%% determine coordinates of  the grid points
points4 = cell(num_row_array, 1);

rc_array = [row_array, col_array] + rcStart - [1 1];
for i = 1: num_row_array
    px = [xMat(row_array(i), col_array(i)), xMat(row_array(i), col_array(i)+1), xMat(row_array(i) +1, col_array(i) +1), xMat(row_array(i) +1, col_array(i))]';
    py = [yMat(row_array(i), col_array(i)), yMat(row_array(i), col_array(i)+1), yMat(row_array(i) +1, col_array(i)+1), yMat(row_array(i) +1, col_array(i))]';
    pz = [zMat(row_array(i),  col_array(i)), zMat(row_array(i), col_array(i)+1), zMat(row_array(i) +1, col_array(i)+1),  zMat(row_array(i) +1, col_array(i))]';
    points4{i, 1} = [px, py, pz];
    %
end
% 
% 
% 
end
%
%
% 


function [zMinPoint, zMaxPoint] = compute_overlap_z(zRange, startpoint, endpoint)
    % Compute the z values for the given range on the line defined by startpoint and endpoint
    zRange = sort(zRange);
    seZ = sort([startpoint(3), endpoint(3)]);
    % Extract the zMin and zMax values from zRange
    tolerance = 10.0;
    zMin = max(seZ(1), zRange(1) - tolerance);
    zMax = min(seZ(2), zRange(2) + tolerance);

    % Compute the slope of the line
    zxSlope = (endpoint(1) - startpoint(1)) / (endpoint(3) - startpoint(3));
    zySlope = (endpoint(2) - startpoint(2)) / (endpoint(3) - startpoint(3));
    % Compute the x and y values for the zMin and zMax points on the line
    xMin = (zMin - startpoint(3)) * zxSlope + startpoint(1);
    yMin = (zMin - startpoint(3)) * zySlope + startpoint(2);

    xMax = (zMax - startpoint(3)) * zxSlope + startpoint(1);
    yMax = (zMax - startpoint(3)) * zySlope + startpoint(2);

    % Create the zMin and zMax points and Return
    zMinPoint = [xMin, yMin, zMin];
    zMaxPoint = [xMax, yMax, zMax];

end











