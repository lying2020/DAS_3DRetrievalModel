


% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2023-9-14: Modify the description and comments
% this code is used to find the rectangular grid area that line covered.
function [xMat0, yMat0, zMat0, rcStart] = findoverlaparea(xMat, yMat, zMat, startpoint, endpoint)
% -----------------------------------------------------------------------------------------------------
% 找到地层被直线覆盖部分的矩形网格区域
% INPUT:
% xMat, yMat, zMat:  n *m, x, y z coordinates of the grid point.  (网格点上的x, y坐标)
% sartpoint, endpoint: startpoint and endpoint of a line segment.
%
% OUTPUT: 
% overlap area
% Check the validity of the inputs
assert(isequal(size(xMat), size(yMat), size(zMat)), 'xMat, yMat, and zMat must be of the same size.');
assert(isequal(size(startpoint), [1, 3]) && isequal(size(endpoint), [1, 3]), 'startpoint and endpoint must be 1x3 vectors.');
assert(~isequal(startpoint, endpoint), 'startpoint and endpoint must not be equal.');
% -----------------------------------------------------------------------------------------------------
[rLen, cLen] = size(xMat);

% to determine the search region where the line coincides with the descrete layer surface 
xRange = find_overlap_range(xMat(:, floor(cLen / 2))', [startpoint(1), endpoint(1)]);
yRange = find_overlap_range(yMat(floor(rLen / 2), :), [startpoint(2), endpoint(2)]);

% disp(['startpoint: ', num2str(startpoint), ', endpoint: ', num2str(endpoint)]);
% ax1 = axes(figure);
% layersurf(ax1, xMat, yMat, zMat);
% se = [startpoint; endpoint];
% hold(ax1, 'on');
% scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'blue', 'filled');
% plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 1.5);

if (isempty(xRange) || isempty(yRange))
    [xMat0, yMat0, zMat0, rcStart] = deal([]);
    return;
end

xMat0 = xMat(xRange, yRange);
yMat0 = yMat(xRange, yRange);
zMat0 = zMat(xRange, yRange);
rcStart = [xRange(1), yRange(1)];

% scatter3(ax1, xMat0(:), yMat0(:), zMat0(:), 10, 'red', 'filled');
% 
% ax2 = axes(figure);
% layersurf(ax2, xMat0, yMat0, zMat0);
% se = [startpoint; endpoint];
% hold(ax2, 'on');
% scatter3(ax2, se(:, 1), se(:, 2), se(:, 3), 50, 'blue', 'filled');
% plot3(ax2, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 1.5);

end

%% -----------------------------------------------------------------------------------------------------
function overlapRange = find_overlap_range(xRange, xArray)
% -----------------------------------------------------------------------------------------------------
% find thex range with coordinates overlapping
% between the line segment and the discrete layer surface
%INPUT:
% xRange:  1* num. x range
% xArray；1 *2 points
%
% OUTPUT: 
% overlapRange: valid range. 1: n vector
% -----------------------------------------------------------------------------------------------------
xx = sort(xArray);
num = length(xRange);
seq1 = find(xRange >= xx(1));
seq1 = [max(1, min(seq1) - 1), seq1];
seq2 = find(xRange <= xx(2));
seq2 = [seq2, min(1, max(seq2) + 1)];
sol = intersect(seq1, seq2);

if isempty(sol), overlapRange = []; return; end
overlapRange =  max(1, min(sol) - 1) : min(max(sol) + 1, num);
%
end

