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
% xyArray: num* 2 matrix. ÿһ�д�������ڶ�Ӧ���x��yֵ.    eg: xyArray = [1 2; 2 3; 4 5; 4 3; 4 3; 3 3];
% idxLayer: num* 1. �������xy ��ÿһ�ж�Ӧ�Ĳ�������eg: idxLayer = [1 2 3 3 4 4]';
%
% OUTPUT:
% zArray: num* 1. ��Ӧ�������xy������ÿһ�е�x, y���������ڲ��z���ꡣ
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

