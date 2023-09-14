clear

%  DEBUG ! ! !
dbstop if error;
format long % short % 
add_default_folder_path

layerGridModel = load_mat_data('layergriddata1000.mat');
layerCoeffModel = load_mat_data('layerModel1000.mat');
velocityModel =  load_mat_data('VelModnew.mat');

minx = layerGridModel{2,1}(1,1);
miny = layerGridModel{2,2}(1,1);

load undergroundCoord6000;
sensordo = undergroundCoord(end,:);
sensorPositions = undergroundCoord(1:1:size(undergroundCoord,1),:);
nums = size(sensorPositions,1);

faultfilename = "faultCoordSet96881";
faultPositions = importdata("faultPositions/" + faultfilename + ".mat");

faultVDTForm = generateFaultVDTForm(layerCoeffModel, layerGridModel, velocityModel, sensorPositions, faultPositions);


filenamepre = "arrivaltimedata/";
faultVDTFormname = filenamepre+ faultfilename + "_VDTForm.mat";
faultPositonsname = filenamepre + faultfilename + "_Positions.mat";
save(faultVDTFormname,'faultVDTForm');
save(faultPositonsname,'faultPositions');

