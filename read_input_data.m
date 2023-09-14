

function geological_model = read_input_data(geological_data_path, output_data_path)

%% input:
% geological_data_path.path_geological_model = input_geological_model_path;
% geological_data_path.path_layer_data_folder = 'layers_data_106';
% geological_data_path.path_faults_data_folder = 'faults_data_106'
% geological_data_path.path_velocity_data = 'velocity_data';
% geological_data_path.path_well_data = 'well_data_T106';
% output_data_path: result to save path

func_name = mfilename;
disp(['func_name: ', func_name]);

%% 
geological_model = [];

time_start = showtimenow;
disp(['func_name: ', func_name, '. ', 'time_start: ' time_start]);

% ** baseCoord / sensorData / wellData / ***************************************************************************
% baseCoord = [14620550.3,4650200.4,1514.78];
path_baseCoord_data = [geological_data_path.path_geological_model, filesep, geological_data_path.path_baseCoord_data];
baseCoord = importdata(path_baseCoord_data);
disp(['func_name: ', func_name, '. ', 'baseCoord size: ', num2str(size(baseCoord)), ', baseCoord: ', num2str(baseCoord)]);
savedata(baseCoord, output_data_path, 'baseCoord', '.mat');
geological_model.baseCoord = baseCoord;

path_sensor_coords_data = [geological_data_path.path_geological_model, filesep, geological_data_path.path_sensor_data];
sensorData = importdata(path_sensor_coords_data);
% [welllength, sensorscoords] = compute_sensor_coord_with_well_data(sensorData - baseCoord);
disp(['func_name: ', func_name, '. ', 'sensorData size: ', num2str(size(sensorData))]);
savedata(sensorData, output_data_path, 'sensorData', '.mat');
geological_model.sensorData = sensorData;

path_well_data = [geological_data_path.path_geological_model, filesep, geological_data_path.path_well_data];
wellData = importdata(path_well_data);
disp(['func_name: ', func_name, '. ', 'wellData size: ', num2str(size(wellData))]);
savedata(wellData, output_data_path, 'wellData', '.mat');
geological_model.wellData = wellData;

coords_idx = [1 2 3];
% baseCoord = wellData(1, coords_idx);
baseCoord_top = wellData(1, coords_idx);
baseCoord_bottom = wellData(end, coords_idx);
disp(['func_name: ', func_name, '. ', 'baseCoord_top: ', num2str(baseCoord_top)]);
disp(['func_name: ', func_name, '. ', 'baseCoord_bottom: ', num2str(baseCoord_bottom)]);
savedata(baseCoord_top, output_data_path, 'baseCoord_top', '.mat');
savedata(baseCoord_bottom, output_data_path, 'baseCoord_bottom', '.mat');
geological_model.baseCoord_top = baseCoord_top;
geological_model.baseCoord_bottom = baseCoord_bottom;

% ** layerGridModel / faultModel ***************************************************************************
path_layer_data_folder = [geological_data_path.path_geological_model, filesep, geological_data_path.path_layer_data_folder];
disp(['func_name: ', func_name, '. ', 'path_layer_data_folder: ', path_layer_data_folder]);
filename_list_layers = getfilenamelistfromfolder(path_layer_data_folder, '');

gridFlag = true; gridType = 'linear'; gridStepSize = [10, 10]; gridRetractionDist = [10, 10]; fittingType = 'nonlinear'; layerType = 'layer';
layerModelParam = struct('gridFlag', gridFlag, 'gridType', gridType, 'gridStepSize', gridStepSize, 'gridRetractionDist', gridRetractionDist, ...
                                                  'fittingType', fittingType, 'layerType', layerType, 'pathSave', output_data_path);
[baseCoord, layerCoeffModel, layerGridModel] = getlayermodel(filename_list_layers, baseCoord, layerModelParam);

savedata(baseCoord, output_data_path, 'baseCoord', '.txt');
% geological_model.baseCoord = baseCoord;
geological_model.layerGridModel = layerGridModel;
geological_model.layerCoeffModel = layerCoeffModel;

time_layers = showtimenow;
disp(['func_name: ', func_name, '. ', 'time_layers: ', time_layers]);

axs= axes(figure);
sourceplot3D(axs, layerGridModel, wellData(:, [1, 2, 3])) ; % , sensorCoord);
% if strcmp(type, 'fault'),    colormap(axs, 'jet');    end

path_faults_data_folder = [geological_data_path.path_geological_model, filesep, geological_data_path.path_faults_data_folder];
disp(['func_name: ', func_name, '. ', 'path_faults_data_folder: ', path_faults_data_folder]);
filename_list_faults = getfilenamelistfromfolder(path_faults_data_folder, '');
gridFlag = true; gridType = 'linear'; gridStepSize = [10, 10]; gridRetractionDist = [10, 10]; fittingType = 'linear'; layerType = 'fault';
faultModelParam = struct('gridFlag', gridFlag, 'gridType', gridType, 'gridStepSize', gridStepSize, 'gridRetractionDist', gridRetractionDist, ...
                                                 'fittingType', fittingType, 'layerType', layerType, 'pathSave', output_data_path);
[baseCoord, faultCoeffModel, faultModel] = getlayermodel(filename_list_faults, baseCoord, faultModelParam);

% savedata(baseCoord, output_data_path, ['baseCoord'], '.txt');
% geological_model.baseCoord = baseCoord;
geological_model.faultModel = faultModel;
geological_model.faultCoeffModel = faultCoeffModel;

time_faults = showtimenow;
disp(['func_name: ', func_name, '. ', 'time_faults: ', time_faults]);

% ** velocityData ***************************************************************************
path_velocity_data = [geological_data_path.path_geological_model, filesep, geological_data_path.path_velocity_data];
disp(['func_name: ', func_name, '. ', 'path_velocity_data: ', path_velocity_data]);
txtData = readtxtdata(path_velocity_data, 'velocity');
velocityData = txtData;

[velocityModel, velocityCount, xMat, yMat, zMat, velocityMat]= getvelocitymodel(path_velocity_data, baseCoord, layerCoeffModel, layerGridModel, output_data_path);

geological_model.velocityModel = velocityModel;
geological_model.velocityCount = velocityCount;
geological_model.velocityMat = velocityMat;
% geological_model.xMat = xMat;
% geological_model.yMat = yMat;
% geological_model.zMat = zMat;
%% 
% xMat, yMat, zMat format is as follows ...
% size(xMat) == size(yMat) == size(zMat) == (m, n);
% xMat = [   
%     x1, x1, ..., x1, x1; ...
%     x2, x2, ..., x2, x2; ...
%     x3, x3, ..., x3, x3; ...
%     ...
%     xm, xm, ..., xm, xm
% ];
% 
% yMat = [
%     y1, y2, ..., yn-1, yn; ...
%     y1, y2, ..., yn-1, yn; ...
%     ...
%     y1, y2, ..., yn-1, yn
% ];
% zMat = [
%     z11, z12, ..., z1n-1, z1n; ...
%     z21, z22, ..., z2n-1, z2n; ...
%     ...
%     zm1, zm2, ..., zmn-1, zmn
% ];
%% 

time_velocity = showtimenow;
disp(['func_name: ', func_name, '. ', 'time_velocity: ', time_velocity]);
%% input data path: geological model data path








end
