%
%
%
%% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to solve the intersection of a line segment and a grid surface   
%% -----------------------------------------------------------------------------------------------------
function p4surf(coeffSet, pointSet, intersections, se, ax1)
% -----------------------------------------------------------------------------------------------------
% coeffSet: num* 1 cell, each cell contains 1* numCoeff array. 
% pointSet: num* 1 cell, each cell contains a 4* numDim matrix.
% intersections: : n* numDim matrix, the intersection points of the given surface and the given line.             
% se: 2* numDim matrix, se = [startpoint; endpoint];   
% ax1: axes, coordinate axis handle
% -----------------------------------------------------------------------------------------------------
% some default parameters.
if nargin < 5,  ax1 = axes(figure);   end
if nargin < 4, se = [];  end
if nargin < 3, intersections = [];  end
% -----------------------------------------------------------------------------------------------------

hold(ax1, 'on');
coeff = zeros(1, 10);
for ips = 1:length(pointSet)
    tmp = pointSet{ips, 1};
    %     interpolation(tmp, 1, 0.1, 'linear', ax1);
%     plot3(ax1, [tmp(:, 1); tmp(1, 1)], [tmp(:, 2); tmp(1, 2)], [tmp(:, 3); tmp(1, 3)], 'r-', 'linewidth', 1.1);
%     patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), abs(tmp(:, 3))/norm(tmp(:, 3)));
    %     patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3),  [0 0.1 0.9],'EdgeColor','interp','Marker','o','MarkerFaceColor','flat');
    scatter3(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), 20, 'MarkerFaceColor', [0 0 0]);
    % 测试四点是否在直线不同侧
    %     for jTmp = 1: size(tmp, 1)
    %         st = [se(1, :); tmp(jTmp, :)];
    %         plot3(ax1, st(:, 1), st(:, 2), st(:, 3), 'b-');
    %     end
% -----------------------------------------------------------------------------------------------------
    % fitting polynomial surface.
    aa = coeffSet{ips, 1};     coeff(1: length(aa)) = aa;
    % Linear | Quadric | Cubic function fitted at mesh point
    % [1, y, x, x*y, y*y, x*x, y*y*y, x*y*y, x*x*y, x*x*x]    
    gridsfunc = @(x, y) coeff(1)+ coeff(2)*y+ coeff(3)*x+ coeff(4)*x.*y+ coeff(5)*y.^2+ coeff(6)*x.^2 ...
        + coeff(7)*y.*y.*y+ coeff(8)*x.*y.*y+ coeff(9)*x.*x.*y+ coeff(10)*x.*x.*x;
    xArray = min(tmp(:, 1)):0.5:max(tmp(:, 1));
    yArray = min(tmp(:, 2)):0.5:max(tmp(:, 2));
    [xMat, yMat] = meshgrid(xArray, yArray);
    zMat = gridsfunc(xMat, yMat);
%     layersurf(ax1, xMat, yMat, zMat);
surf(ax1, xMat, yMat, zMat, zMat);
shading(ax1, 'interp');
%    
end
%
% -----------------------------------------------------------------------------------------------------
%
if ~isempty(se)
    scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'filled');
    plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 2.5);
end
%
if ~isempty(intersections)
    scatter3(ax1, intersections(:, 1), intersections(:, 2), intersections(:, 3), 50, 'filled');
end
xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');
%
%
%

%% -----------------------------------------------------------------------------------------------------




