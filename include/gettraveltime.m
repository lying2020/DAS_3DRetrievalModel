
function deltaTime = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions,  sourcePosition)
%% 获取震源到检波器的旅时， deltaTime,
%INPUT:
%   layerCoeffModel: 1*NumLayer  matrix 水平地层信息， 每列储存一个交界面的位置
%   VelMod: 1*(NumLayer-1) matrix 地层速度信息，每行储存一个地层的速度信息
%   sourcePosition: 1*Dim matrix  震源位置；
%   sensorPosition: NumDet*Dim matrix  检波器的位置，每行储存一个检波器的坐标
%   type: 0  or 1. 0: whether to consider the refraction
% OUTPUT:
% deltaTime: nSensor* 1, 获取震源到检波器的旅时，
%% ---------------------------------------------------------------
numSensor = size(sensorPositions, 1);
deltaTime=zeros(numSensor, 1);

for jsensor=1: numSensor
    %  计算发生在地层交界面的折射点位置和地层之间的速度
    % [relatedLayerModel, relatedVelocityModel] = computelayerinfo(layerCoeffModel, velocityModel, sensorPositions(j, :), sourcePosition);
    % [~, totalTime] = computeraytrace(relatedLayerModel, relatedVelocityModel, sensorPositions(j, :), sourcePosition);
    %%% 新射线追踪算法的接口 %%%%
    %     relatedLayerModel([1,end])=[];
    %     relatedLayerFun = cell(length(relatedVelocityModel)-1, 1);
    %     for i = 1: length(relatedLayerFun)
    %         layer = @(x,y,z)  relatedLayerModel(i) - z;
    %         relatedLayerFun{i} = layer;
    %     end
    %     [~, totalTime, ~, ~] = computeraytrace_curve_shubo(relatedLayerFun,  relatedVelocityModel,   sensorPositions(j, :),  sourcePosition);
    [Position, markX0, initialguessVel, errort,trivalt] = ...
        RayTrace3D_layerModel(layerCoeffModel, layerGridModel, VelMod,sensorPositions(jsensor,:),sourcePosition);
    totalTime = trivaltime(initialguessVel,Position);
    %%%%%%%%%%%%%%%%%%%
    deltaTime(jsensor) = totalTime;
end

end



    

