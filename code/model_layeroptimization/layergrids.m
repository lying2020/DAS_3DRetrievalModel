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
function [p4, rc] = layergrids(xMat, yMat, zMat, startpoint, endpoint)
% -----------------------------------------------------------------------------------------------------
% 找到直线与地层的交点所在的矩形网格点坐标
% INPUT:
% xMat, yMat, zMat:  n *m, x, y z coordinates of the grid point.  (网格点上的x, y坐标)
% sartpoint, endpoint: startpoint and endpoint of a line segment.
%
% OUTPUT:
% p4: num * 1 cell, each cell includes 4* numDim matrix, that represents the vertices of the small quadriateral
% rc: num* 2 matrix, each row conains row and column indexes of the lower left vertex of the small quadrilateral(四边形)
% [numRow, numCol] = size(xMat);
%% -----------------------------------------------------------------------------------------------------
numDim = 3;
[rangeRow, rangeCol] = deal(zeros(numDim, 2));
xyz = {xMat, yMat, zMat};

%% to determine the search region where the line coincides with the descrete layer surface 
for i = 1: numDim
    [rangeRow(i, :), rangeCol(i, :)] = findidx( xyz{i}, [startpoint(i), endpoint(i)] );
end
% 
range1 = [max(rangeRow(:, 1)), min(rangeRow(:, 2))];
range2 = [max(rangeCol(:, 1)), min(rangeCol(:, 2))];
rowArray = range1(1): range1(2);
colArray = range2(1):range2(2);
rc = [range1(1), range2(1)];
if isempty(rowArray) || isempty(colArray)
    p4 = cell(0, 0);
    return;
end

%% Determine the search gird points ......
xMat = xMat(rowArray, colArray);   yMat = yMat(rowArray, colArray);   zMat = zMat(rowArray, colArray);
%  
xyz = {xMat, yMat, zMat};
tmpSol = cell(1, 3);
tmp = [1 2; 1 3; 2 3];
for  i = 1: numDim
    tmpSol{i} = findgrids(xyz{tmp(i, 1)}, xyz{tmp(i, 2)}, startpoint(tmp(i, :)), endpoint(tmp(i, :)));
end
sol = intersect(tmpSol{1}, tmpSol{2});
sol = intersect(sol, tmpSol{3});

%% determine coordinates of  the grid points
p4 = cell(length(sol), 1);
[rowMat, ~] = size(xMat);
r =  sol - (ceil(sol / rowMat) - 1) * rowMat;   %  mod(sol, rowMat);  
c = ceil(sol/ rowMat);   %% ceil: round up to an integer
rc = rc + [r, c] - [1 1];
for i = 1: length(sol)
    px = [xMat(r(i), c(i)), xMat(r(i), c(i)+1), xMat(r(i)+1, c(i)+1), xMat(r(i)+1, c(i))]';
    py = [yMat(r(i), c(i)), yMat(r(i), c(i)+1), yMat(r(i)+1, c(i)+1), yMat(r(i)+1, c(i))]';
    pz = [zMat(r(i), c(i)), zMat(r(i), c(i)+1), zMat(r(i)+1, c(i)+1), zMat(r(i)+1, c(i))]';
    p4{i, 1} = [px, py, pz];
    %
end
% 
% 
% 
end
%
%
% 
%% -----------------------------------------------------------------------------------------------------
function [rangeRow, rangeCol] = findidx(xMat, xArray)
% -----------------------------------------------------------------------------------------------------
% find the rectangle range where the coordinates overlap 
% between the line segment and the discrete layer surface
%INPUT:
% xMat: n* m.
% xArray；1* 2
% 
% OUTPUT: 
% rangeRow: row range.
% rangeCol: column range.
% -----------------------------------------------------------------------------------------------------
xx = sort(xArray);
rowMat = size(xMat, 1);
s1 = find(xMat >= xx(1));
s2 = find(xMat <= xx(2));
sol = intersect(s1, s2);
% [r, c] = find(mat>=xx(1) && mat <= xx(2));
r =  sol - (ceil(sol / rowMat) - 1) * rowMat;   %  mod(sol, rowMat);
c = ceil(sol / rowMat);    %% ceil: round up to an integer
rangeRow = [min(r), max(r)];
rangeCol = [min(c), max(c)];
% -----------------------------------------------------------------------------------------------------
if isempty(rangeRow) || isempty(rangeCol)
    rangeRow = [1, 0];
    rangeCol = [1 0];
end
% 
% 
% 
end











