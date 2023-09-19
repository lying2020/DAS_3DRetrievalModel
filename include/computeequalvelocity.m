
% function [equalVelocity, equalDistance, equalDeltaTime]= computeequalvelocity(layerCoeffModel, layerGridModel, velocityModel, sensorPositions,  sourceLocationCoord, usefulRange)
function [equalVelocity, equalDistance, equalDeltaTime, refractionPointSets, numrefractionPointSets,Vel] = computeequalvelocity(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorPositions,  sourceLocationCoord, usefulRange)
% 
% INPUT:
%  layerGridModel: numLayer* 3  cell
%  --  水平地层信息， 每行储存一个交界面的位置信息
%  velocityModel: (numLayer-1)* 1  matrix
%  --  地层速度信息，每行储存一个地层的速度信息
%  sensorPositions: numSensor* numDim matrix
%  --  检波器的位置，每行储存一个检波器的坐标
%  sourceLocationCoord: 1* numDim matrix
%  --  震源位置
%   usefulRange: scalar
%  --  计算区域\Omega = [0,Rang]\times[0,-Rang]

% OUTPUT:
%   equalVelocity:  numSensor* 1 matrix   每个检波器到震源的对应的等效速度
%   equalDistance:  numSensor* 1 matrix   每一个检波器对应的等效时间
%   equalDeltaTime: numSensor* 1 matrix   获取震源到检波器的旅时，
%   refractionPointSets: NumLayer*(2*NumDet) matrix  折射点的位置信息，
%   第[2*n-1,2n] 列储存第n个检波器对应的折射点位置, 坐标位置为[0,0]表示该检波器接收的地震波没有经过对应的地层
%% ------------------------------------------------------------------------------------

if nargin > 5
    if any (abs(sourceLocationCoord) > abs(usefulRange) )
        displaytimelog(['the initial guess position the ', num2str(iEvents), ' th seismic event: ', num2str( inversionLocation)]);
        warn('The  source location is outside the specified useful range !');
    end
end

%
% numSensor: 检波器数量; numDim: 维数
[numSensor, numDim] = size(sensorPositions);
% 初始化 输出参数 
[equalVelocity, equalDistance, equalDeltaTime] = deal(zeros(numSensor, 1));
%
%refractionPointSets=zeros( length(layerCoeffModel), numDim* numSensor);
%%
for iSensor = 1 : numSensor
    % 拾取与震源和第iSensor个检波器之间的地层模型和速度模型。
    %     [relatedLayerModel, relatedVelocityModel] = computelayerinfo(layerCoeffModel, velocityModel, sensorPositions(iSensor, :), sourceLocationCoord);
    % 计算第iSensor个检波器接收到的地震波与震源之间的折射点的坐标
    % refractionPoints = computeraytrace(relatedLayerModel,  relatedVelocityModel, sensorPositions(iSensor, :), sourceLocationCoord);
    % refractionPoints: the refraction point between the source and the iSensor th sensor

    %%% 新射线反演算法的接口 %%%%
    %     relatedLayerModel([1,end])=[];
    %     relatedLayerFun = cell(length(relatedVelocityModel)-1, 1);
    %     for i = 1: length(relatedLayerFun)
    %         layer = @(x,y,z)  relatedLayerModel(i) - z;
    %         relatedLayerFun{i} = layer;
    %     end
    %     refractionPoints = computeraytrace_curve_shubo(relatedLayerFun,  relatedVelocityModel,   sensorPositions(iSensor, :),  sourceLocationCoord);
    [Position, markX0, initialguessVel, errort, trivalt] = RayTrace3D_layerModel(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorPositions(iSensor,:),sourceLocationCoord);
    %%%%%%%%%%%%%%%%%%%%%

    % 计算地震波与在每层地层所用的时间与总旅时的比值
%     [ratioTime, totalTime] = getratiotime(relatedVelocityModel, refractionPoints);
    equalDeltaTime(iSensor) = trivaltime(initialguessVel, Position);
    % 计算第i个检波器与震源之间的等效距离
    tmpDist = computedistance(Position');
    equalDistance(iSensor) = sum(tmpDist);
    % 计算第i个检波器接收到的地震波的等效速度
    equalVelocity(iSensor) = equalDistance(iSensor) / equalDeltaTime(iSensor);

    tmp = size(Position', 1);
    idxArray = ((numDim+1)* (iSensor - 1) + 1) : ((numDim+1)* iSensor);
    refractionPointSets(1:tmp,  idxArray) = Position(1:4,:)';
    numrefractionPointSets(iSensor) = tmp;
    Vel(1:tmp-1,iSensor) = initialguessVel';
end

end
%
%
%%  ------------------------------------------------------------------------------
%
function distRefractionPoints = computedistance(refractionPoints)
%%
% Calculate the distance of the refraction point between the source and the sensor
% INPUT:
% refractionPoints: n* dim matrix
% --  the refraction point between the source and the sensor
% distRefractionPoints: (n - 1)* dim matrix
% the distance of the refraction point between the source and the sensor
%
%% 相邻两个折射点的位置向量
% the position vector of two agjacent refracting points
layerVector = refractionPoints(1 : end-1, :) - refractionPoints(2 : end, :);
%
% the distance between refracting points
distRefractionPoints = sqrt( sum( (layerVector).^2, 2) );
end


