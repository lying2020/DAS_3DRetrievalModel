clear

addpath ../layer_new_tanyan/
addpath ../layer_new_tanyan/layerModel
addpath ./arrivaltimedata/

%% Data initial?
% load layerGridModelold;
% load layerModelold;
layerGridModel = importdata('layergriddata1000.mat');
layerModel = importdata('layerModel1000.mat');
numLayer = size(layerModel, 1);
layerRangeModel = cell(numLayer, 1);
% layerModel_zdomain = importdata('layerModel_zdomainnew.mat');
VelMod = importdata('VelModnew.mat');
baseCoordin = importdata('baseCoordin.mat');
sourceLocationDomain = importdata('Domain_200,200,-200-900m_10m_139sensors.mat');
VDTForm = importdata('VDTForm_200,200,-200-900m_10m_139sensors.mat');
layerModelCombine(:,1:3) = layerGridModel(:,:);
layerModelCombine(:,4) = layerModel(:);
% layerModelCombine(:,5) = layerModel_zdomain(:);
minx = layerGridModel{2,1}(1,1);
miny = layerGridModel{2,2}(1,1);
overgroundCoord = importdata('overgroundCoordnew.mat');
undergroundCoord = importdata('undergroundCoordnew.mat');
sensordo = undergroundCoord(end,:);
sensorPositions = undergroundCoord(1:1:size(undergroundCoord,1),:);

allsourcePositions = [];
for i=-155:23:155
    for j = -163:29:163
        for k = 57:27:621
    allsourcePositions...
        = [allsourcePositions ; sensordo + [j i k]];
        end
    end
end
optional.DeleteOddresidual = 2;
optional.residualway = 1;
optional.acceptresi = 2;
optional.numUnSensor = 10;
optional.numOvSensor = 0;
optional.numoutput = 100;


% resi = zeros(size(allsourcePositions, 1),1);
% distance =  zeros(4,20,size(allsourcePositions, 1));
% apSensor = cell(size(allsourcePositions,1),2);
% maxresitol = 0;
% markmaxresitil = 0;
% markiminnorm = zeros(size(allsourcePositions, 1),1);
% numresult = zeros(size(allsourcePositions, 1),1);
% normdist = cell(size(allsourcePositions, 1),1);
% startmatlabpool(4,300);
numsource = size(allsourcePositions, 1);
for isource = 1:numsource
    %  -------------------------------------------------------------------------------------------------------------------------------------------------------------------
    sourcePosition = allsourcePositions(isource, :);% + [testArray(i), testArray(j),  -testArray(k)];
    tmpSensor = sensorPositions;
    tmparrivalTime = gettraveltime(layerCoeffModel, layerGridModel, layerRangeModel, VelMod, tmpSensor,   sourcePosition);
    [retrievalLocation] = sourceRetrieval(VDTForm,sourceLocationDomain,tmparrivalTime,optional);
    result = retrievalLocation(:,1:4) + [sensordo 0];
    distance{isource} =  result' - [sourcePosition 0]';
    [Retrievalresult(isource,:),resultnearest(isource,:),dist(isource), resi(isource), mindist(isource), resinearest(isource),numresult(isource),markiminnorm(isource),distance{isource},mindistoutput(isource), iminnormoutput(isource)] ...
        = output(distance{isource},optional);
end
% closematlabpool;


file=fopen(['./Retrievalresult/result_',num2str(optional.numUnSensor),'d',num2str(optional.numOvSensor),'u_' ...
    ,num2str(allsourcePositions(1,3)),'-',num2str(allsourcePositions(end,3)),'m_',...
    num2str(sourceLocationDomain(4,1)),'minter_',num2str(optional.acceptresi),'acceptresi_',num2str(optional.numoutput),'numoutput' ,'.txt'], 'w');
fprintf(file, '%10s \t\t\t\t\t\t\t\t \t\t\t  %10s  \t\t\t\t\t\t\t\t\t\t%10s \t\t\t\t\t\t\t\t\t\t %10s \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t \r\n', 'exactLocation', 'inversionLocation', 'error','iterate times');


for isource = 1:numsource
    fprintf(file,  '#%d  %6.4f  %6.4f  %6.4f \t\t\t\t\t %6.4f  %6.4f  %6.4f \t\t\t\t\t %6.4f  %6.4f  %6.4f  \t\t\t\t\t %6.4f  %6.4f  %6.4f  \t\t\t\t\t  %6.4f \t\t\t\t\t %6.4f \t\t\t\t  %6.4f \t\t\t\t  %6.4f \t\t\t\t %d \t\t\t\t %6.4f \t\t\t\t %d \t\t\t\t',isource, allsourcePositions(isource,:),distance{isource}(1:3,iminnormoutput(isource)), Retrievalresult(isource,:),resultnearest(isource,:),dist(isource), resi(isource), mindist(isource), resinearest(isource),numresult(isource),mindistoutput(isource), iminnormoutput(isource));
    fprintf(file, '\r\n');
end

fclose(file);