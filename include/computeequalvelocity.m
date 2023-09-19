
% function [equalVelocity, equalDistance, equalDeltaTime]= computeequalvelocity(layerCoeffModel, layerGridModel, velocityModel, sensorPositions,  sourceLocationCoord, usefulRange)
function [equalVelocity, equalDistance, equalDeltaTime, refractionPointSets, numrefractionPointSets,Vel] = computeequalvelocity(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorPositions,  sourceLocationCoord, usefulRange)
% 
% INPUT:
%  layerGridModel: numLayer* 3  cell
%  --  ˮƽ�ز���Ϣ�� ÿ�д���һ���������λ����Ϣ
%  velocityModel: (numLayer-1)* 1  matrix
%  --  �ز��ٶ���Ϣ��ÿ�д���һ���ز���ٶ���Ϣ
%  sensorPositions: numSensor* numDim matrix
%  --  �첨����λ�ã�ÿ�д���һ���첨��������
%  sourceLocationCoord: 1* numDim matrix
%  --  ��Դλ��
%   usefulRange: scalar
%  --  ��������\Omega = [0,Rang]\times[0,-Rang]

% OUTPUT:
%   equalVelocity:  numSensor* 1 matrix   ÿ���첨������Դ�Ķ�Ӧ�ĵ�Ч�ٶ�
%   equalDistance:  numSensor* 1 matrix   ÿһ���첨����Ӧ�ĵ�Чʱ��
%   equalDeltaTime: numSensor* 1 matrix   ��ȡ��Դ���첨������ʱ��
%   refractionPointSets: NumLayer*(2*NumDet) matrix  ������λ����Ϣ��
%   ��[2*n-1,2n] �д����n���첨����Ӧ�������λ��, ����λ��Ϊ[0,0]��ʾ�ü첨�����յĵ���û�о�����Ӧ�ĵز�
%% ------------------------------------------------------------------------------------

if nargin > 5
    if any (abs(sourceLocationCoord) > abs(usefulRange) )
        displaytimelog(['the initial guess position the ', num2str(iEvents), ' th seismic event: ', num2str( inversionLocation)]);
        warn('The  source location is outside the specified useful range !');
    end
end

%
% numSensor: �첨������; numDim: ά��
[numSensor, numDim] = size(sensorPositions);
% ��ʼ�� ������� 
[equalVelocity, equalDistance, equalDeltaTime] = deal(zeros(numSensor, 1));
%
%refractionPointSets=zeros( length(layerCoeffModel), numDim* numSensor);
%%
for iSensor = 1 : numSensor
    % ʰȡ����Դ�͵�iSensor���첨��֮��ĵز�ģ�ͺ��ٶ�ģ�͡�
    %     [relatedLayerModel, relatedVelocityModel] = computelayerinfo(layerCoeffModel, velocityModel, sensorPositions(iSensor, :), sourceLocationCoord);
    % �����iSensor���첨�����յ��ĵ�������Դ֮�������������
    % refractionPoints = computeraytrace(relatedLayerModel,  relatedVelocityModel, sensorPositions(iSensor, :), sourceLocationCoord);
    % refractionPoints: the refraction point between the source and the iSensor th sensor

    %%% �����߷����㷨�Ľӿ� %%%%
    %     relatedLayerModel([1,end])=[];
    %     relatedLayerFun = cell(length(relatedVelocityModel)-1, 1);
    %     for i = 1: length(relatedLayerFun)
    %         layer = @(x,y,z)  relatedLayerModel(i) - z;
    %         relatedLayerFun{i} = layer;
    %     end
    %     refractionPoints = computeraytrace_curve_shubo(relatedLayerFun,  relatedVelocityModel,   sensorPositions(iSensor, :),  sourceLocationCoord);
    [Position, markX0, initialguessVel, errort, trivalt] = RayTrace3D_layerModel(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorPositions(iSensor,:),sourceLocationCoord);
    %%%%%%%%%%%%%%%%%%%%%

    % �����������ÿ��ز����õ�ʱ��������ʱ�ı�ֵ
%     [ratioTime, totalTime] = getratiotime(relatedVelocityModel, refractionPoints);
    equalDeltaTime(iSensor) = trivaltime(initialguessVel, Position);
    % �����i���첨������Դ֮��ĵ�Ч����
    tmpDist = computedistance(Position');
    equalDistance(iSensor) = sum(tmpDist);
    % �����i���첨�����յ��ĵ��𲨵ĵ�Ч�ٶ�
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
%% ��������������λ������
% the position vector of two agjacent refracting points
layerVector = refractionPoints(1 : end-1, :) - refractionPoints(2 : end, :);
%
% the distance between refracting points
distRefractionPoints = sqrt( sum( (layerVector).^2, 2) );
end


