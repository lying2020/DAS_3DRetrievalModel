function [apSensor] = apropSensor(layerCoeffModel, layerGridModel, Sensorcell, inversionLocation, numOver, numUnder)
%% 

numLayer = size(layerCoeffModel,1);
tol = 100;
num = [numOver numUnder];

xyArray(1:numLayer,1) = inversionLocation(1,1);
xyArray(1:numLayer,2) = inversionLocation(1,2);
idx = (1:numLayer)';
z = [layerz(layerCoeffModel, layerGridModel,xyArray,idx);inversionLocation(1,3)];
z = sortrows(z,1);
[row,~] = find(z == inversionLocation(1,3));
DSensor = [];
idSensor = cell(2,1);
for iou = 2:2
    Sensor = Sensorcell{iou};
    numSensor = size(Sensor,1);
    idSensor{iou} = 1:numSensor;
    for iSensor = 1:numSensor
        if row == 1
            if  Sensor(iSensor,3) < layerz(layerCoeffModel(row),layerGridModel(row),Sensor(iSensor,1:2),1)+tol
                DSensor(end+1) = iSensor;
            end
        elseif row == numLayer+1 || row == numLayer
            %         if Sensor(iSensor,3) > layerz(layerCoeffModel(row-1),layerGridModel(row-1),Sensor(iSensor,1:2),1)-tol
            %             DSensor(end+1) = iSensor;
            %         end
        else
            if  Sensor(iSensor,3) < layerz(layerCoeffModel(row),layerGridModel(row),Sensor(iSensor,1:2),1)+100 ...
                    && Sensor(iSensor,3) > layerz(layerCoeffModel(row-1),layerGridModel(row-1),Sensor(iSensor,1:2),1)-100
                DSensor(end+1) = iSensor;
            end
        end
    end
    Sensorcell{iou}(DSensor,:) = [];
    idSensor{iou}(DSensor) = [];
end
apSensor = cell(2,1);
for iou = 1:2
    if num(iou) == 0
        apSensor{iou} = [];
    else
        numout = min(num(iou),size(Sensorcell{iou},1));
        inter = floor(size(Sensorcell{iou},1)/numout);
        iSensor = 1:inter:numout*inter;
        advance = floor(rand(1)*(inter - 1));
        if iou == 1
            apSensor{iou} = iSensor + advance;
        elseif iou == 2
            apSensor{iou} = idSensor{iou}(iSensor + advance);
        end
    end
end
% tmpSensor = Sensor;
% tmpSensor(DSensor,:) = [];
end
