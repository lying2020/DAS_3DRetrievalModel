
function deltaTime = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions,  sourcePosition)
%% ��ȡ��Դ���첨������ʱ�� deltaTime,
%INPUT:
%   layerCoeffModel: 1*NumLayer  matrix ˮƽ�ز���Ϣ�� ÿ�д���һ���������λ��
%   VelMod: 1*(NumLayer-1) matrix �ز��ٶ���Ϣ��ÿ�д���һ���ز���ٶ���Ϣ
%   sourcePosition: 1*Dim matrix  ��Դλ�ã�
%   sensorPosition: NumDet*Dim matrix  �첨����λ�ã�ÿ�д���һ���첨��������
%   type: 0  or 1. 0: whether to consider the refraction
% OUTPUT:
% deltaTime: nSensor* 1, ��ȡ��Դ���첨������ʱ��
%% ---------------------------------------------------------------
numSensor = size(sensorPositions, 1);
deltaTime=zeros(numSensor, 1);

for jsensor=1: numSensor
    %  ���㷢���ڵز㽻����������λ�ú͵ز�֮����ٶ�
    % [relatedLayerModel, relatedVelocityModel] = computelayerinfo(layerCoeffModel, velocityModel, sensorPositions(j, :), sourcePosition);
    % [~, totalTime] = computeraytrace(relatedLayerModel, relatedVelocityModel, sensorPositions(j, :), sourcePosition);
    %%% ������׷���㷨�Ľӿ� %%%%
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



    

