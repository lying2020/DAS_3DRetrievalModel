clear

addpath ../layer_new_tanyan/
addpath ../layer_new_tanyan/layerModel
addpath ./arrivaltimedata/

%% Data initial?
layerGridModel = importdata('layergriddata1000.mat');
layerCoeffModel = importdata('layerModel1000.mat');
VelMod = importdata('VelModnew.mat');
baseCoordin = importdata('baseCoordin.mat');
baseCoordout = importdata('baseCoordout.mat');

minx = layerGridModel{2,1}(1,1);
miny = layerGridModel{2,2}(1,1);
% overgroundCoord = importdata('overgroundCoordnew.mat');
undergroundCoord = importdata('undergroundCoord6000.mat');
sensordo = undergroundCoord(end,:);
sensorPositions = undergroundCoord(1:1:size(undergroundCoord,1),:);

optional.DeleteOddresidual = 2;
optional.residualway = 1;
optional.acceptresi = 2;
optional.numUnSensor = 10;
optional.numOvSensor = 0;
optional.numoutput = 20;

faultfilename = "faultCoordSet3";
filenamepre = "arrivaltimedata/";
faultVDTFormname = filenamepre+ faultfilename + "_VDTForm.mat";
faultPositonsname = filenamepre + faultfilename + "_Positions.mat";
faultPositions = importdata(faultPositonsname);
faultVDTForm = importdata(faultVDTFormname);

arrivalname = "arrivaldata/";
arrivalTime = importdata(arrivalname + "wd1.mat");
arrivalTime = arrivalTime/1000;
sensorid = importdata(arrivalname + "seq1.mat");
sensorid = sensorid - 78;
tempfaultVDTForm = faultVDTForm(:,sensorid,:);


[retrievalLocation] = FaultRetrieval(tempfaultVDTForm,faultPositions,arrivalTime,optional);
[Retrievalresult,resultnearest,dist, resi, mindist, resinearest,numresult,markiminnorm,distance,mindistoutput, iminnormoutput] ...
    = output(retrievalLocation',optional);


% retrievalLocation = retrievalLocation(1:optional.numoutput,:);


