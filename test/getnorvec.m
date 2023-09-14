function [norvec] = getnorvec(layerCoeffModel,layerGridModel,xyArray,idxLayer)


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
norvec = zeros(num,3);
for i = 1: num
    coeff = layerCoeffModel{ idxLayer(i) };
    xMat = layerGridModel{ idxLayer(i),1 };
    yMat = layerGridModel{ idxLayer(i),2 };
    inter = xMat(1,2) - xMat(1,1);
    id = floor((xyArray(i, 2) - yMat(1,1))/inter+1);
    jd = floor((xyArray(i, 1) - xMat(1,1))/inter+1);
%     func = @(x) coeff{id,jd}(1) * x(1)*x(1)*x(1) + coeff{id,jd}(2) * x(1)*x(1)*x(2) + ...
%         coeff{id,jd}(3) * x(1)*x(2)*x(2) + coeff{id,jd}(4) * x(2)*x(2)*x(2) +...
%         coeff{id,jd}(5) * x(1)*x(1)      + coeff{id,jd}(6) * x(1)*x(2)      +  coeff{id,jd}(7) * x(2)*x(2) + ...
%         coeff{id,jd}(8) * x(1)           + coeff{id,jd}(9) * x(2)           +  coeff{id,jd}(10) * 1;
    pdzdx = @(X) (coeff{id,jd}(1)*3*X(1)^2 + coeff{id,jd}(2)*2*X(1)*X(2) + coeff{id,jd}(3)*X(2)^2 + ...
        coeff{id,jd}(5)*2*X(1) + coeff{id,jd}(6)*X(2) + coeff{id,jd}(8));
    pdzdy = @(X) (coeff{id,jd}(2)*X(1)^2 + coeff{id,jd}(3)*2*X(1)*X(2) + coeff{id,jd}(4)*3*X(2)^2 + ...
        coeff{id,jd}(6)*X(1) + coeff{id,jd}(7)*2*X(2) + coeff{id,jd}(9));
    dzdx = @(X) pdzdx(X - [xMat(1,jd)  yMat(id,1) 0]' - [inter/2  inter/2  0]');
    dzdy = @(X) pdzdy(X - [xMat(1,jd)  yMat(id,1) 0]' - [inter/2  inter/2  0]');
    norvec(i, :) = [dzdx(xyArray(i,:))  dzdy(xyArray(i,:)) -1];
end

end