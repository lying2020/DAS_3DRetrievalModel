clear

addpath ../layer_new_tanyan/
addpath ../layer_new_tanyan/layerModel
addpath ./arrivaltimedata/

%% Data initial?
sensorPositions = importdata('undergroundCoord6000.mat');
sensordo = sensorPositions(end,:);

optional.DeleteOddresidual = 2;
optional.residualway = 1;
optional.acceptresi = 2;
optional.numUnSensor = 10;
optional.numOvSensor = 0;
optional.numoutput = 100;
optional.retrievaldomain = "cubic";

sourceLocationDomain = importdata('Domain_-450-650,400,-600-1000m_10m_139sensors.mat');
VDTForm = importdata('VDTForm_-450-650,400,-600-1000m_10m_139sensors.mat');


arrivalname = "arrivaldata/";
arrivalTime = importdata(arrivalname + "wdArray13.mat");
sensorid = importdata(arrivalname + "seqArray13.mat");
numsource = size(arrivalTime,1);

result = cell(13,1);
% star tmatlabpool(4,1000);
for isource = 1:numsource
    tmpsensorid = sensorid{isource}-78;
    [result{isource}] = arrivalTimeRetrieval(arrivalTime{isource},tmpsensorid,VDTForm,sourceLocationDomain,optional);
    figure(isource); hold on;
    plot3(sensorPositions(tmpsensorid,1),sensorPositions(tmpsensorid,2),sensorPositions(tmpsensorid,3),'o','MarkerSize',3,'Color','b');hold on;
    plot3(result{isource}(:,1),result{isource}(:,2),result{isource}(:,3),'o','MarkerSize',3,'Color','r');hold on;
    legend({'sensorPositions','result'});
end
% closematlabpool;