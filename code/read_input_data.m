

function geological_model = read_input_data(geological_data_path, output_result_data_path)

%% input:
% geological_data_path.path_geological_model = input_geological_model_path;
% geological_data_path.path_layer_data_folder = 'layers_data_106';
% geological_data_path.path_faults_data_folder = 'faults_data_106'
% geological_data_path.path_velocity_data = 'velocity_data';
% geological_data_path.path_well_data = 'well_data_T106';
% output_result_data_path: result to save path

func_name = mfilename;
displaytimelog(['func: ', func_name]);

%% ---------------------------------------------------------------------------------------
time_start = showtimenow;
displaytimelog(['func: ', func_name, '. ', 'time_start: ' time_start]);

displaytimelog(['func: ', func_name, '. ', 'input_geological_model_path: ', geological_data_path.path_geological_model]);
geological_model.input_geological_model_path = geological_data_path.path_geological_model;

displaytimelog(['func: ', func_name, '. ', 'output_result_data_path: ', output_result_data_path]);
geological_model.output_result_data_path = output_result_data_path;

% some intermediate result data, such as layer / velocity-model mesh refinement data, well coords.
output_mat_data_path = [output_result_data_path, filesep, 'mat_data'];
mkdir(output_mat_data_path);
disp('output_mat_data_path: some intermediate result data, such as layer / velocity-model mesh refinement data, well coords.');
displaytimelog(['func: ', func_name, '. ', 'output_mat_data_path: ', output_mat_data_path]);
geological_model.output_mat_data_path = output_mat_data_path;

geological_model.data_form = 'mat';
geological_model.data_name = {'baseCoord', 'baseCoord_top', 'baseCoord_bottom', 'sensorData', 'wellData', ...
        'layerModelParam', 'layerGridModel', 'layerCoeffModel', 'layerCoeffModelTY', 'layerCoeffModel_zdomainTY', 'layerRangeModel', ...
        'faultModelParam', 'faultGridModel', 'faultCoeffModel', 'velocityModel', 'velocityModelTY', 'velocityCount'};

%% ** baseCoord / sensorData / wellData / ***************************************************************************
% baseCoord = [14620550.3,4650200.4,1514.78];
path_baseCoord_data = [geological_data_path.path_geological_model, filesep, geological_data_path.path_baseCoord_data];
baseCoord = importdata(path_baseCoord_data);
displaytimelog(['func: ', func_name, '. ', 'baseCoord size: ', num2str(size(baseCoord)), ', baseCoord: ', num2str(baseCoord)]);
savedata(baseCoord, output_mat_data_path, 'baseCoord', '.mat');
DATA_MODEL.baseCoord = baseCoord;

path_sensor_coords_data = [geological_data_path.path_geological_model, filesep, geological_data_path.path_sensor_data];
sensorData = importdata(path_sensor_coords_data);
% [welllength, sensorscoords] = compute_sensor_coord_with_well_data(sensorData - baseCoord);
displaytimelog(['func: ', func_name, '. ', 'sensorData size: ', num2str(size(sensorData))]);
savedata(sensorData, output_mat_data_path, 'sensorData', '.mat');
DATA_MODEL.sensorData = sensorData;

path_well_data = [geological_data_path.path_geological_model, filesep, geological_data_path.path_well_data];
wellData = importdata(path_well_data);
displaytimelog(['func: ', func_name, '. ', 'wellData size: ', num2str(size(wellData))]);
savedata(wellData, output_mat_data_path, 'wellData', '.mat');
DATA_MODEL.wellData = wellData;

coords_idx = [1 2 3];
% baseCoord = wellData(1, coords_idx);
baseCoord_top = wellData(1, coords_idx);
baseCoord_bottom = wellData(end, coords_idx);
displaytimelog(['func: ', func_name, '. ', 'baseCoord_top: ', num2str(baseCoord_top)]);
displaytimelog(['func: ', func_name, '. ', 'baseCoord_bottom: ', num2str(baseCoord_bottom)]);
savedata(baseCoord_top, output_mat_data_path, 'baseCoord_top', '.mat');
savedata(baseCoord_bottom, output_mat_data_path, 'baseCoord_bottom', '.mat');
DATA_MODEL.baseCoord_top = baseCoord_top;
DATA_MODEL.baseCoord_bottom = baseCoord_bottom;

%% ** layerGridModel ***************************************************************************
path_layer_data_folder = [geological_data_path.path_geological_model, filesep, geological_data_path.path_layer_data_folder];
displaytimelog(['func: ', func_name, '. ', 'path_layer_data_folder: ', path_layer_data_folder]);
filename_list_layers = getfilenamelistfromfolder(path_layer_data_folder, '');

gridFlag = true;  gridType = 'linear';  gridStepSize = [10, 10];  gridRetractionDist = [10, 10];   fittingType = 'cubic';  layerType = 'layer';
% gridFlag = true;  gridType = 'linear';  gridStepSize = [10, 10];  gridRetractionDist = [10, 10];   fittingType = 'nonlinear';  layerType = 'layer';
layerModelParam = struct('gridFlag', gridFlag, 'gridType', gridType, 'gridStepSize', gridStepSize, 'gridRetractionDist', gridRetractionDist, ...
                                                  'fittingType', fittingType, 'layerType', layerType, 'pathSave', output_mat_data_path);
[baseCoord, layerCoeffModel, layerGridModel, layerRangeModel, layerCoeffModelTY, layerCoeffModel_zdomainTY] = getlayermodel(filename_list_layers, baseCoord, layerModelParam);

savedata(baseCoord, output_mat_data_path, 'baseCoord', '.txt');
% DATA_MODEL.baseCoord = baseCoord;
DATA_MODEL.layerModelParam = layerModelParam;
DATA_MODEL.layerCoeffModel = layerCoeffModel;
DATA_MODEL.layerGridModel = layerGridModel;
DATA_MODEL.layerRangeModel = layerRangeModel;
% ** TANYAN layerGridModel  ***************************************************************************
DATA_MODEL.layerCoeffModelTY = layerCoeffModelTY;
DATA_MODEL.layerCoeffModel_zdomainTY = layerCoeffModel_zdomainTY;

time_layers = showtimenow;
displaytimelog(['func: ', func_name, '. ', 'time_layers: ', time_layers]);

% axs= axes(figure);
% sourceplot3D(axs, layerGridModel, wellData(:, [1, 2, 3])) ; % , sensorCoord);
% % if strcmp(type, 'fault'),    colormap(axs, 'jet');    end
%% **  faultModel ***************************************************************************
path_faults_data_folder = [geological_data_path.path_geological_model, filesep, geological_data_path.path_faults_data_folder];
displaytimelog(['func: ', func_name, '. ', 'path_faults_data_folder: ', path_faults_data_folder]);
filename_list_faults = getfilenamelistfromfolder(path_faults_data_folder, '');
gridFlag = true; gridType = 'linear'; gridStepSize = [10, 10]; gridRetractionDist = [10, 10]; fittingType = 'linear'; layerType = 'fault';
faultModelParam = struct('gridFlag', gridFlag, 'gridType', gridType, 'gridStepSize', gridStepSize, 'gridRetractionDist', gridRetractionDist, ...
                                                 'fittingType', fittingType, 'layerType', layerType, 'pathSave', output_mat_data_path);
[baseCoord, faultCoeffModel, faultGridModel] = getlayermodel(filename_list_faults, baseCoord, faultModelParam);
% savedata(baseCoord, output_mat_data_path, ['baseCoord'], '.txt');
% DATA_MODEL.baseCoord = baseCoord;
DATA_MODEL.faultModelParam = faultModelParam;
DATA_MODEL.faultGridModel = faultGridModel;
DATA_MODEL.faultCoeffModel = faultCoeffModel;

time_faults = showtimenow;
displaytimelog(['func: ', func_name, '. ', 'time_faults: ', time_faults]);

%% ** velocityData ***************************************************************************
path_velocity_data = [geological_data_path.path_geological_model, filesep, geological_data_path.path_velocity_data];
displaytimelog(['func: ', func_name, '. ', 'path_velocity_data: ', path_velocity_data]);
txtData = readtxtdata(path_velocity_data, 'velocity');
velocityData = txtData;

[velocityModel, velocityCount, velocityModelTY, xMat, yMat, zMat, velocityMat]= getvelocitymodel(path_velocity_data, baseCoord, layerCoeffModel, layerGridModel, output_mat_data_path);

% %%%
DATA_MODEL.velocityModel = velocityModel;
DATA_MODEL.velocityCount = velocityCount;
DATA_MODEL.velocityModelTY = velocityModelTY;

% DATA_MODEL.velocityMat = velocityMat;
% DATA_MODEL.xMat = xMat;
% DATA_MODEL.yMat = yMat;
% DATA_MODEL.zMat = zMat;

savedata(DATA_MODEL, output_mat_data_path, 'DATA_MODEL', '.mat');
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
displaytimelog(['func: ', func_name, '. ', 'time_velocity: ', time_velocity]);
%% input data path: geological model data path








end
