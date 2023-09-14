%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to convert the velocity discrete data into grid point data
% and select a reference original point
%% -----------------------------------------------------------------------------------------------------
function p4 = points4(xMat, yMat, zMat, sp, ep)
% xMat, yMat, zMat: xLen* yLen matrix;
% p4: num * 1 cell, each cell includes 4* numDim matrix.
% sp: 1* numDim matrix. The starting point of the given line;
% ep: 1* numDim matrix. The ending point of the given line;
%% -----------------------------------------------------------------------------------------------------
%
[numRow, numCol] = size(xMat);
v0 = repmat(ep - sp, numRow, 1); 
x1 = ep(1) - xMat;  y1 = ep(2) - yMat;  z1 = ep(3) - zMat;
% x1 = x - sp(1);   y1 = y - sp(2);    z1 = z - sp(3);
sol = zeros(numRow-1, numCol -1);
% v1(:, :, 1) = ep(1) - x;
% v1(:, :, 2) = ep(2) - y;   
% v1(:, :, 3) = ep(3) - z;
for i = 1: numCol - 1
    v1 = [x1(:, i), y1(:, i), z1(:, i)];
    v2 = [x1(:, i + 1), y1(:, i + 1), z1(:, i + 1)];
    c1  = cross(v0, v1, 2);
    c2 = cross(v0, v2, 2);
%         tmp = [cross(c1(1:end-1, :), c1(2:end, :), 2);  cross(c1(1:end-1, :), c2(1:end-1, :), 2); cross(c1(1:end-1, :), c2(2:end, :), 2)];
    % tmp = [a11* a21, a11* a12, a11* a22, a21* a12, a21* a22, a12* a22]
    tmp = [dot(c1(1:end-1, :), c1(2:end, :), 2),  dot(c1(1:end-1, :), c2(1:end-1, :), 2), ...
                dot(c1(1:end-1, :), c2(2:end, :), 2),  dot(c1(2:end, :), c2(1:end-1, :), 2), ...                 
                dot(c1(2:end, :), c2(2:end, :), 2),     dot(c2(1:end-1, :), c2(2:end, :), 2)];
%             tmp = [ dot(c1(1:end-1, :), c2(2:end, :), 2),  dot(c1(2:end, :), c2(1:end-1, :), 2)];
    sol(:, i) = all([any(tmp >= 0, 2), any(tmp <= 0, 2)], 2);   
%     t =  find(sol(:, i)); 
%     if t
%         se = [sp; ep];
%         ax1 = axes(figure);  hold(ax1, 'on');
%   scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'MarkerFaceColor', [0 0
%   0]);  
%    plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 2.5);
%         i
%         tmp(t, :)
%     end
end
[r, c] = find(sol);
p4 = cell(length(r), 1);
% ax1 = axes(figure);  hold(ax1, 'on');
for i = 1: length(r)
    px = [xMat(r(i), c(i)), xMat(r(i), c(i)+1), xMat(r(i)+1, c(i)+1), xMat(r(i)+1, c(i))]';
    py = [yMat(r(i), c(i)), yMat(r(i), c(i)+1), yMat(r(i)+1, c(i)+1), yMat(r(i)+1, c(i))]';
    pz = [zMat(r(i), c(i)), zMat(r(i), c(i)+1), zMat(r(i)+1, c(i)+1), zMat(r(i)+1, c(i))]';
    p4{i, 1} = [px, py, pz];
%     scatter3(ax1, px, py, pz, 50, 'MarkerFaceColor', [0 1 0]);
%     p4{i, 1} = [x(r(i), c(i)),           y(r(i), c(i)),         z(r(i), c(i));       ...
%                      x(r(i), c(i)+1),      y(r(i), c(i)+1),     z(r(i), c(i)+1);  ...
%                      x(r(i)+1, c(i)),      y(r(i)+1, c(i)),     z(r(i)+1, c(i));  ...
%                      x(r(i)+1, c(i)+1), y(r(i)+1, c(i)+1), z(r(i)+1, c(i)+1); ];
end

end
