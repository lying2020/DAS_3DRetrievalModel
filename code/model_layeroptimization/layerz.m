%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to obtain the z coordinates of the corresponding layer
%% -----------------------------------------------------------------------------------------------------
function zArray = layerz(layerCoeffModel, layerGridModel, xyArray, idxLayer)
% -----------------------------------------------------------------------------------------------------
%  INPUT: 
% layerCoeffModel: nomLayer* 1 cell. each cell contains (m -1)* (n -1) cell, and
% each cell contains a 1* numCoeff matrix. 
% layerGridModel: layer model. numLayer* numDim cell. The discret point set of the given surface,
% each row of cells includes  a m* n matrix containing grid points data of x, y, z - direction of the same layer;
% layer data should be stored from top to bottom.
% xyArray: num* 2 matrix. 每一行代表的是在对应层的x和y值.    eg: xyArray = [1 2; 2 3; 4 5; 4 3; 4 3; 3 3];
% idxLayer: num* 1. 代表的是xy 的每一行对应的层索引。eg: idxLayer = [1 2 3 3 4 4]';
%
% OUTPUT:
% zArray: num* 1. 对应的输入的xy变量的每一行的x, y坐标与所在层的z坐标。
%% -----------------------------------------------------------------------------------------------------
%
num = length(idxLayer);
zArray = zeros(num, 1);
if isempty(layerGridModel), return;  end
% -----------------------------------------------------------------------------------------------------
if isa(layerGridModel{1}, 'function_handle')
    for i = 1: num
        layer = layerGridModel{ idxLayer(i) };
        zArray(i, 1) = layer(xyArray(i, 1), xyArray(i, 2), 0);
    end
    return;
end
%
% -----------------------------------------------------------------------------------------------------
for i = 1: num
    coeffMat = layerCoeffModel{idxLayer(i), 1};
    zArray(i, 1) = zvalue(coeffMat, layerGridModel{idxLayer(i), 1}, layerGridModel{idxLayer(i), 2}, xyArray(i, :));
end

end
% 
%
% 
%
% %% -----------------------------------------------------------------------------------------------------
% function [z0, sol, rc] = zvalue(coeffMat, xMat, yMat, xy0)
% % -----------------------------------------------------------------------------------------------------
% % this code is used to obtain the z0 value after fixing x0 and y0 on the discrete surface
% %  INPUT: 
% % coeffMat: (m -1)*(n -1) cell matrix. the fitting polynomial coefficients set of the corresponding layer.
% % each cell contains 1* numCoeff array fitting polynomial coefficients for each grid point. 
% % xMat, yMat: m* n matrix, grid point data of x, y-direction.
% % xy0: 1*2 array. the x, y coordinates of a point on a stratigraphic interface. (地层界面)
% % OUTPUT:
% % z0: z coordinate of a point with fixed x, y on a stratigraphic interface.               
% %% -----------------------------------------------------------------------------------------------------
% %
% x0 = xy0(1);    y0 = xy0(2);
% % find the max interval of x, y
% intervalX = max( max( abs(xMat(2:end, 1) - xMat(1:end-1, 1)) ), max( abs(xMat(1, 2:end) - xMat(1, 1:end-1)) ) ) ;
% intervalY = max( max( abs(yMat(2:end, 1) - yMat(1:end-1, 1)) ), max( abs(yMat(1, 2:end) - yMat(1, 1:end-1)) ) ) ;
% % -----------------------------------------------------------------------------------------------------
% % find the grid points, sx, sy, sol is global indexes: sol = xLen*(col - 1) + row;               
% sx1 = find(xMat >= (x0 - intervalX - 1));
% sx2 = find(xMat <= (x0 + intervalX + 1));
% sx = intersect(sx1, sx2);
% sy1 = find(yMat >= (y0 - intervalY - 1));
% sy2 = find(yMat <= (y0 + intervalY + 1));
% sy = intersect(sy1, sy2);
% sol = intersect(sx, sy);
% % -----------------------------------------------------------------------------------------------------
% % 
% [xLen, ~] = size(xMat);
% r =  sol - (ceil(sol / xLen) - 1) * xLen;
% c = ceil(sol / xLen);    %% ceil: round up to an integer
% rowArray = min(r): max(r);
% colArray = min(c): max(c);
% rc0 = [min(r), min(c)];
% %
% % -----------------------------------------------------------------------------------------------------
% if isempty(rowArray) || isempty(colArray)
%     z0 = [];  rc = [];
%     return;
% end
% %
% %% -----------------------------------------------------------------------------------------------------
% % A more detailed search, finds the unique grid point that contains the target point      
% xMat = xMat(rowArray, colArray);
% yMat = yMat(rowArray, colArray);
% %
% np = 1;
% for ir = 1: length(rowArray)-1
%     for ic = 1:length(colArray)-1
%         px = [xMat(ir, ic), xMat(ir, ic+1), xMat(ir+1, ic+1), xMat(ir, ic+1)]';
%         py = [yMat(ir, ic), yMat(ir, ic+1), yMat(ir+1, ic+1), yMat(ir, ic+1)]';
%         flagX = (x0 >= min(px) ) && (x0 < max(px));
%         flagY = (y0 >= min(py) ) && (y0 < max(py));
%         if (flagX && flagY)
%             rc(np, :) = rc0 + [ir, ic] - [1, 1];
%             np = np +1;
%         end
%     end
% end
% %
% %% -----------------------------------------------------------------------------------------------------
% % get z0 !!!
% coeff = zeros(1, 10);
% coeffLen = length(coeffMat{1, 1}); 
% z0 = zeros(size(rc, 1), 1);
% % the normal condition, size(rc, 1) == 1;
% for i = 1: size(rc, 1)
% coeff0 = coeffMat{rc(i, 1), rc(i, 2)};
% coeff(1: coeffLen) = coeff0;
% %
% % Linear | Quadric | Cubic function fitted at mesh point
% gridsfunc = @(x, y) coeff(10)*x.*x.*x + coeff(9)*x.*x.*y + coeff(8)*x.*y.*y + coeff(7)*y.*y.*y ...
%     + coeff(6)*x.^2+coeff(5)*y.^2+coeff(4)*x.*y+coeff(3)*x+coeff(2)*y+coeff(1);
% % gridsfunc = @(x, y) coeff(1)*x.*x.*x + coeff(2)*x.*x.*y + coeff(3)*x.*y.*y + coeff(4)*y.*y.*y ...
% %     + coeff(5)*x.^2+coeff(6)*y.^2+coeff(7)*x.*y+coeff(8)*x+coeff(9)*y+coeff(10);
% z0(i) = gridsfunc(x0, y0);
% end
% %
% %
% %
% end





