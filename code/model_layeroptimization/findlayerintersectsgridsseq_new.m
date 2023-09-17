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
function seq = findlayerintersectsgridsseq_new(xMat, yMat, startpoint, endpoint)
% -----------------------------------------------------------------------------------------------------
% 找到直线与网格点矩形区域重合的网格顶点坐标
% INTPUT: 
% X, Y: n *m, x, y coordinates of the grid point.  (网格点上的x, y坐标)
% startpoint, endpoint: 1* 2， endpoint of a line. 直线的两个端点
% OUTPUT: 
% [rArray, cArray]: 1*num, the row / col index sequence of the target grid coordinates
%% -----------------------------------------------------------------------------------------------------
[numRow, numCol] = size(xMat);
sol = zeros(numRow-1, numCol -1);

v0 = endpoint - startpoint;
xMat1 = xMat - startpoint(1); 
yMat1 = yMat - startpoint(2);
% -----------------------------------------------------------------------------------------------------
%  计算实现与网格点上的每个点的叉乘的值
% % v0:[x1, y1];  sol = x1*y2 - x2*y1;  % cross product

    %  x1*y2, v0(:, 1).* vec1(:, 2)
    vx_yMat1 = v0(:, 1).*yMat1;
    %  y1*x2, v0(:, 2).* vec1(:, 1)
    vy_xMat1 = v0(:, 2).*xMat1;
    
    vec_x1 = vx_yMat1(:, 1: numCol - 1);
    vec_y1 = vy_xMat1(:, 1: numCol - 1);

    vec_x2 = vx_yMat1(:, 2: numCol);
    vec_y2 = vy_xMat1(:, 2: numCol);

    crossp1 = vec_x1 - vec_y1;
    crossp2 = vec_x2 - vec_y2;

for i = 1: numCol - 1
    griddatacrossproducts = [crossp1(1:end-1, i), crossp1(2:end, i), crossp2(1:end-1, i),  crossp2(2:end, i)];
    condition1 = any(griddatacrossproducts >= 0, 2);
    condition2 = any(griddatacrossproducts <= 0, 2);
    % Determine if the line crosses the rectangle
    sol(:, i) = all([condition1, condition2], 2);
end

[rArray, cArray] = find(sol);
seq = numRow * (cArray - 1) + rArray;


