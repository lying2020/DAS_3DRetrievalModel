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
function [seq, rArray, cArray] = findlayerintersectsgridsseq(xMat, yMat, startpoint, endpoint, intput_seq)
% -----------------------------------------------------------------------------------------------------
% 找到直线与网格点矩形区域重合的网格顶点坐标
% INTPUT: 
% X, Y: n *m, x, y coordinates of the grid point.  (网格点上的x, y坐标)
% startpoint, endpoint: 1* 2， endpoint of a line. 直线的两个端点
% OUTPUT: 
% [rArray, cArray]: 1*num, the row / col index sequence of the target grid coordinates
%% -----------------------------------------------------------------------------------------------------
if nargin < 5
[numRow, numCol] = size(xMat);
v0 = repmat(endpoint - startpoint, numRow, 1);
sol = zeros(numRow-1, numCol -1);
xMat1 = xMat - startpoint(1);   yMat1 = yMat - startpoint(2);
% -----------------------------------------------------------------------------------------------------
%  计算实现与网格点上的每个点的叉乘的值。
for i = 1: numCol - 1
    vec1 = [xMat1(:, i), yMat1(:, i)];
    vec2 = [xMat1(:, i + 1), yMat1(:, i + 1)];
    %  c1  = crossproduct(v0, v1);
    %  c2 = crossproduct(v0, v2);
    % % sol = x1*y2 - x2*y1;
    crossp1 = v0(:, 1).* vec1(:, 2) - v0(:, 2).* vec1(:, 1);
    crossp2 = v0(:, 1).* vec2(:, 2) - v0(:, 2).* vec2(:, 1);
    %
    griddatacrossproducts = [crossp1(1:end-1, :), crossp1(2:end, :), crossp2(1:end-1, :),  crossp2(2:end, :) ];
    condition1 = any(griddatacrossproducts >= 0, 2);
    condition2 = any(griddatacrossproducts <= 0, 2);
    % Determine if the line crosses the rectangle
    sol(:, i) = all([condition1, condition2], 2);
end
[rArray, cArray] = find(sol);
seq = numRow * (cArray - 1) + rArray;

else
    if isempty(intput_seq)
        seq = intput_seq;
        return;
    end
    [numRow, ~] = size(xMat);
    v0 = endpoint - startpoint;
    vec11 = [xMat(intput_seq) - startpoint(1),  yMat(intput_seq) - startpoint(2)];
    vec12 = [xMat(intput_seq+numRow) - startpoint(1),  yMat(intput_seq+numRow) - startpoint(2)];
    vec21 = [xMat(intput_seq+1) - startpoint(1),  yMat(intput_seq+1) - startpoint(2)];
    vec22 = [xMat(intput_seq+numRow+1) - startpoint(1),  yMat(intput_seq+numRow+1) - startpoint(2)];
    crossp11 = v0(:, 1).* vec11(:, 2) - v0(:, 2).* vec11(:, 1);
    crossp12 = v0(:, 1).* vec12(:, 2) - v0(:, 2).* vec12(:, 1);
    crossp21 = v0(:, 1).* vec21(:, 2) - v0(:, 2).* vec21(:, 1);
    crossp22 = v0(:, 1).* vec22(:, 2) - v0(:, 2).* vec22(:, 1);
    griddatacrossproducts = [crossp11, crossp12, crossp21, crossp22];
    condition1 = any(griddatacrossproducts >= 0, 2);
    condition2 = any(griddatacrossproducts <= 0, 2);
    sol = all([condition1, condition2], 2);
    seq = intput_seq(sol);
end
%% -----------------------------------------------------------------------------------------------------
% Find the position of the subscript in the lower left corner of the overlapping rectangle
% f1 = figure;
% ax1 = axes(f1);
% hold(ax1, 'on');
%  plot(ax1, xMat(:), yMat(:), 'c:', 'linewidth', 1);
%  scatter(ax1, xMat(:), yMat(:), 40);
% se = [endpoint; startpoint];
% % seq =1 ;
% scatter(ax1, se(:, 1), se(:, 2), 40, 'filled');
% plot(ax1, se(:, 1), se(:, 2), 'r', 'linewidth', 2);
% scatter(ax1, xMat(seq), yMat(seq), 100, 'filled');
% scatter(ax1, xMat(seq + 1), yMat(seq + 1), 20, 'filled');
% scatter(ax1, xMat(seq + numRow), yMat(seq + numRow), 20, 'filled');
% scatter(ax1, xMat(seq + numRow + 1), yMat(seq + numRow + 1), 20, 'filled');
% displaytimelog('all is ok !');
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
