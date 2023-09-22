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
function zArray = computelayerz(layerCoeffModel, layerGridModel, layerRangeModel, xyArray, idxLayer)
% -----------------------------------------------------------------------------------------------------
%  INPUT: 
% layerCoeffModel: nomLayer* 1 cell. each cell contains (m -1)* (n -1) cell, and
% each cell contains a 1* numCoeff matrix. 
% layerGridModel: layer model. numLayer* numDim cell. The discret point set of the given surface,
% each row of cells includes  a m* n matrix containing grid points data of x, y, z - direction of the same layer;
% layer data should be stored from top to bottom.
% layerRangeModel: numLayer * 1 cell.
% each cell contains a 3 * 3 matrix.
% [ x_min, x_max, x_interval;
%   y_min, y_max, y_interval;
%   z_min, z_max, 1 ];
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
% if isa(layerGridModel{1}, 'function_handle')
%     for i = 1: num
%         layer = layerGridModel{ idxLayer(i) };
%         zArray(i, 1) = layer(xyArray(i, 1), xyArray(i, 2), 0);
%     end
%     return;
% end
%
% -----------------------------------------------------------------------------------------------------
% for i = 1: num
    % coeffMat = layerCoeffModel{idxLayer(i), 1};
    % zArray(i, 1) = zvalue(coeffMat, layerGridModel{idxLayer(i), 1}, layerGridModel{idxLayer(i), 2}, layerRangeModel{idxLayer(i)}, xyArray(i, :));
% end


% zArray(i, 1) = zvalue_new(layerCoeffModel{idxLayer(i), 1}, layerGridModel{idxLayer(i), 1}, layerGridModel{idxLayer(i), 2}, layerRangeModel{idxLayer(i)}, xyArray(i, :));


%% -------------------------------------------------------------------------------------------------

for i = 1: num
    coeffMat = layerCoeffModel{idxLayer(i), 1};
    layerRange = layerRangeModel{idxLayer(i), 1};
    x0 = xyArray(i, 1);  y0 = xyArray(i, 2);
    ir = floor((x0 - layerRange(1, 1)) / layerRange(1, 3) + 1);
    ic = floor((y0 - layerRange(2, 1)) / layerRange(2, 3) + 1);
    [maxi,maxj] = size(coeffMat);
    ir = max(1, min(maxi, ir));
    ic = max(1, min(maxj, ic));
    % relative value.
    x0 = mod(x0, layerRange(1, 3)) - layerRange(1, 3) / 2.0;
    y0 = mod(y0, layerRange(2, 3)) - layerRange(2, 3) / 2.0;
    coeff0 = coeffMat{ir, ic};
    coeffLen = length(coeff0);
    coeff = zeros(1, 10);
    coeff(1: coeffLen) = coeff0;
    if 4 == coeffLen
        zArray(i, 1) = coeff(4)*x0.*y0 + coeff(3)*x0 + coeff(2)*y0 + coeff(1)*1;
    elseif 6 == coeffLen
        zArray(i, 1) = coeff(6)*x0.*x0 + coeff(5)*y0.*y0 + coeff(4)*x0.*y0 + coeff(3)*x0 + coeff(2)*y0 + coeff(1)*1;
    else
        zArray(i, 1) = coeff(10)*x0.*x0.*x0 + coeff(9)*x0.*x0.*y0 + coeff(8)*x0.*y0.*y0 + coeff(7)*y0.*y0.*y0 + ...
                       coeff(6)*x0.*x0 + coeff(5)*y0.*y0 + coeff(4)*x0.*y0 + coeff(3)*x0 + coeff(2)*y0 + coeff(1)*1;
    end

end













end
% 
%

