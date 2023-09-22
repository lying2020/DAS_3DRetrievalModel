%
%
%% ----------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to obtain the z coordinates of the corresponding layer
function zArray = layerz_tanyan(layerCoeffModel,layerGridModel, layerRangeModel, xyArray, idxLayer)
%% --------------------------------------------------------------------------------
%  INPUT:
% layerCoeffModel: layer model, numLayer* 1 cell array.  
% layerGridModel :  Mat yMat zMat
% xyArray: num* 2 matrix.  .    eg: xyArray = [1 2; 2 3; 4 5; 4 3; 4 3; 3 3];
% idxLayer: num* 1.  eg: idxLayer = [1 2 3 3 4 4]';
%
% OUTPUT:
% zArray: num* 1.  
%
%  DEBUG ! ! !
dbstop if error;
format long % short % 
%
% clear
func_name = mfilename;

%% -------------------------------------------------------------------------------
%

num = length(idxLayer);
zArray = zeros(num, 1);
%
if isa(layerCoeffModel{1}, 'function_handle')
    for i = 1: num
        layer = layerCoeffModel{ idxLayer(i) };
        zArray(i, 1) = layer(xyArray(i, 1), xyArray(i, 2), 0);
    end
    return;
end
%
for i = 1: num
    coeffMat = layerCoeffModel{ idxLayer(i) };
    xMat = layerGridModel{ idxLayer(i),1 };
    yMat = layerGridModel{ idxLayer(i),2 };
    inter = xMat(2,2) - xMat(1,1);
    displaytimelog(['func: ', func_name, '. ', 'idxLayer(i): ', num2str(idxLayer(i)), ', layerRangeX: ', num2str([xMat(1,1), xMat(end, end), inter]), ', layerRangeY: ', num2str([yMat(1,1), yMat(end, end), inter])]);
    id = floor((xyArray(i, 2) - yMat(1,1))/inter+1);
    jd = floor((xyArray(i, 1) - xMat(1,1))/inter+1);
    [maxi, maxj] = size(coeffMat);
    id = max(1, min(maxi, id));
    jd = max(1, min(maxj, jd));
    displaytimelog(['func: ', func_name, '. ', 'ir: ', num2str(jd), ', ic: ', num2str(id), ', xx: ', num2str(xyArray(i, 1)), ', yy: ', num2str(xyArray(i, 2))]);

%     displaytimelog(['id: ', num2str(id), ', jd: ', num2str(jd), ', size: ', num2str(size(coeffMat))]);
    coeff0 = coeffMat{id,jd};
    % Linear | Quadric | Cubic function fitted at mesh point
    % % function: layerdatafitting
    % Linear | Quadric | Cubic function fitted at mesh point
    % gridsfunc = @(x, y) coeff0(10)*x.*x.*x + coeff0(9)*x.*x.*y + coeff0(8)*x.*y.*y + coeff0(7)*y.*y.*y + ...
    %             coeff0(6)*x.^2 + coeff0(5)*y.^2 + coeff0(4)*x.*y + coeff0(3)*x + coeff0(2)*y + coeff0(1);

    % % function: fitting_tanyan
    gridsfunc = @(x, y) coeff0(1)*x.*x.*x + coeff0(2)*x.*x.*y + coeff0(3)*x.*y.*y + coeff0(4)*y.*y.*y + ...
                coeff0(5)*x.^2 + coeff0(6)*y.^2 + coeff0(7)*x.*y + coeff0(8)*x + coeff0(9)*y + coeff0(10) * 1;

    zArray(i, 1) = gridsfunc(xyArray(i, 1) - xMat(id, jd)+ inter/2, xyArray(i,2) - yMat(id,jd)+inter/2);
    x0 = xyArray(i, 1) - xMat(id, jd) + inter/2;
    y0 = xyArray(i, 2) - yMat(id, jd) + inter/2;
    displaytimelog(['func: ', func_name, '. ', 'x0: ', num2str(x0), ', y0: ', num2str(y0), ', xMat(id, jd): ', num2str(xMat(id, jd)), ', yMat(id, jd): ', num2str(yMat(id, jd)), ', zArray: ', num2str(zArray(i, 1))]);

end

end
%
%
%
