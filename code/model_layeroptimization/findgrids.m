%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to  find the vertex coordinates of the rectangle 
% where the line coincides with the grid point rectangle region
%% -----------------------------------------------------------------------------------------------------
function seq = findgrids(xMat, yMat, sp, ep)
% -----------------------------------------------------------------------------------------------------
% 找到直线与网格点矩形区域重合的矩形顶点坐标
% INTPUT: 
% X, Y: n *m, x, y coordinates of the grid point.  (网格点上的x, y坐标)
% sp, ep: 1* 2， endpoint of a line. 直线的两个端点
% OUTPUT: 
% s: the index sequence of the target grid coordinates
%% -----------------------------------------------------------------------------------------------------
[numRow, numCol] = size(xMat);
v0 = repmat(ep - sp, numRow, 1);
sol = zeros(numRow-1, numCol -1);
x1 = xMat - sp(1);   y1 = yMat - sp(2);
% -----------------------------------------------------------------------------------------------------
%  计算实现与网格点上的每个点的叉乘的值。
for i = 1: numCol - 1
    v1 = [x1(:, i), y1(:, i)];
    v2 = [x1(:, i + 1), y1(:, i + 1)];
    %  c1  = crossproduct(v0, v1);
    %  c2 = crossproduct(v0, v2);
    % % sol = x1*y2 - x2*y1;
    c1 = v0(:, 1).* v1(:, 2) - v0(:, 2).* v1(:, 1);
    c2 = v0(:, 1).* v2(:, 2) - v0(:, 2).* v2(:, 1);
    %
    tmp = [ c1(1:end-1, :), c1(2:end, :), c2(1:end-1, :),  c2(2:end, :) ];
    % Determine if the line crosses the rectangle
    sol(:, i) = all([any(tmp >= 0, 2), any(tmp <= 0, 2)], 2);
end
[r, c] = find(sol);
% Find the position of the subscript in the lower left corner of the overlapping rectangle
seq = numRow* (c - 1) + r;
%% -----------------------------------------------------------------------------------------------------

% f1 = figure;
% ax1 = axes(f1);
% hold(ax1, 'on');
%  plot(ax1, xMat(:), yMat(:), 'c:', 'linewidth', 1);
%  scatter(ax1, xMat(:), yMat(:), 40);
% se = [ep; sp];
% % seq =1 ;
% scatter(ax1, se(:, 1), se(:, 2), 40, 'filled');
% plot(ax1, se(:, 1), se(:, 2), 'r', 'linewidth', 2);
% scatter(ax1, xMat(seq), yMat(seq), 100, 'filled');
% scatter(ax1, xMat(seq + 1), yMat(seq + 1), 20, 'filled');
% scatter(ax1, xMat(seq + numRow), yMat(seq + numRow), 20, 'filled');
% scatter(ax1, xMat(seq + numRow + 1), yMat(seq + numRow + 1), 20, 'filled');
% disp('all is ok !');
% close(f1);
%  if isfield(f1, 'h'), close(hr); end
% 
%% -----------------------------------------------------------------------------------------------------
% f2 = figure;
% ax2 = axes(f2);
% hold(ax2, 'on');
% YY = repmat(1: numCol, numRow, 1);
% XX =  repmat((1: numRow)', 1, numCol);
% plot(ax1, X(:), Y(:), 'c:', 'linewidth', 1);
% scatter(ax2, XX(:), YY(:), 40);
% scatter(ax2, r, c, 100, 'filled');
% scatter(ax2, r + 1, c + 1, 20, 'filled');
% scatter(ax2, r, c + 1, 20, 'filled');
% scatter(ax2, r + 1, c , 20, 'filled');
% % 
% 
% 
end
% 
% 
% 
%% ----------------------------------------------------------------------------------------------------- 
% function sol = crossproduct(p1, p2)
% % take the cross prod uct of two vectors
% % p1, p2: n* numDim, 
% -----------------------------------------------------------------------------------------------------
% if size(p1, 2) == 2
% % sol = x1*y2 - x2*y1;
% sol = p1(:, 1).* p2(:, 2) - p1(:, 2).* p2(:, 1);
%     return;
% end
% % sol = x1*y2 + y1*z2 + z1*x2 - (x2*y1 + y2*z1 + z2*x1);
% sol = p1(:, 1).* p2(:, 2) + p1(:, 2).* p2(:, 3) + p1(:, 3).* p2(:, 1) ...
%      -( p2(:, 1).* p1(:, 2)  + p2(:, 2).*p1(:, 3) + p2(:, 3).* p1(:, 1) );
%
% end
