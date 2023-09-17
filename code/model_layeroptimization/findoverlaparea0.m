


function [xMat, yMat, zMat, rc] = findoverlaparea0(xMat, yMat, zMat, startpoint, endpoint)


numDim = 3;
[rangeRow, rangeCol] = deal(zeros(numDim, 2));
xyz = {xMat, yMat, zMat};

%% to determine the search region where the line coincides with the descrete layer surface 
for i = 1: numDim
    [rangeRow(i, :), rangeCol(i, :)] = findidx( xyz{i}, [startpoint(i), endpoint(i)] );
end
% 
% ax1 = axes(figure);
% layersurf(ax1, xMat, yMat, zMat);
% se = [startpoint; endpoint];
% hold(ax1, 'on');
% scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'blue', 'filled');
% plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 1.5);

range1 = [max(rangeRow(:, 1)), min(rangeRow(:, 2))];
range2 = [max(rangeCol(:, 1)), min(rangeCol(:, 2))];
rowArray = range1(1) : range1(2);
colArray  = range2(1) : range2(2);
rc = [range1(1), range2(1)];
if isempty(rowArray) || isempty(colArray)
    [xMat, yMat, zMat, rc] = deal([]);
    return;
end

%% Determine the search gird points ......
xMat = xMat(rowArray, colArray);   yMat = yMat(rowArray, colArray);   zMat = zMat(rowArray, colArray);
%  
% scatter3(ax1, xMat(:), yMat(:), zMat(:), 10, 'red', 'filled');
% 
% ax2 = axes(figure);
% layersurf(ax2, xMat, yMat, zMat);
% se = [startpoint; endpoint];
% hold(ax2, 'on');
% scatter3(ax2, se(:, 1), se(:, 2), se(:, 3), 50, 'blue', 'filled');
% plot3(ax2, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 1.5);

end

function [rangeRow, rangeCol] = findidx(xMat, xArray)
% -----------------------------------------------------------------------------------------------------
% find the rectangle range where the coordinates overlap 
% between the line segment and the discrete layer surface
%INPUT:
% xMat: n* m.
% xArray£»1* 2
% 
% OUTPUT: 
% rangeRow: row range.
% rangeCol: column range.
% -----------------------------------------------------------------------------------------------------
xx = sort(xArray);
rowMat = size(xMat, 1);
colMat = size(xMat, 2);
s1 = find(xMat >= xx(1));
s2 = find(xMat <= xx(2));
sol = intersect(s1, s2);
% [r, c] = find(mat>=xx(1) && mat <= xx(2));
r =  sol - (ceil(sol / rowMat) - 1) * rowMat;   %  mod(sol, rowMat);
c = ceil(sol / rowMat);    %% ceil: round up to an integer
rangeRow = [max(1, min(r) - 1), min(max(r) + 1, rowMat)];
rangeCol = [max(1, min(c) - 1), min(max(c) + 1, colMat)];
% -----------------------------------------------------------------------------------------------------
if isempty(rangeRow) || isempty(rangeCol)
    rangeRow = [1, 0];
    rangeCol = [1 0];
end
% 
% 
% 
end