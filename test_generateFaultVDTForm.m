
%
%
% nohup /usr/local/Matlab/R2020a/bin/matlab  -batch test_generateVDTForm &
%  DEBUG ! ! !
dbstop if error;
format long % short %
%
% clear
func_name = mfilename;

if exist('input_data_path', 'var') && exist('output_data_path', 'var')
    displaytimelog(['func: ', func_name, '. ', 'Variable input_data_path / output_data_path exists']);
else
    [input_data_path, output_data_path, ~] = add_default_folder_path();
end

% test_generateVDTForm
% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% import data model

% read_geological_model_2023_T('_T106')
geological_model_name = 'geological_model_2023_T106';

% read_geological_model_2023_T('_T131')
% geological_model_name = 'geological_model_2023_T131';

% read_geological_model_xinjiang_2020;
% geological_model_name = 'geological_model_xinjiang_2020_XJ';

%%
[addpath_name, ~]=fileparts(mfilename('fullpath'));
current_data_path = addpath_name;
displaytimelog(['func: ', func_name, '. ', 'current_data_path: ', current_data_path]);
geological_model_mat_file_path = [current_data_path, filesep, geological_model_name, '.mat'];
displaytimelog(['func: ', func_name, '. ', 'geological_model_mat_file_path: ', geological_model_mat_file_path]);

% if exist('geological_model', 'var')
%     displaytimelog(['func: ', func_name, '. ', 'Variable geological_model exists']);
% else
    % displaytimelog(['func: ', func_name, '. ', 'Variable geological_model does not exist, now importdata ... ']);
    geological_model = importdata(geological_model_mat_file_path);
% end


%% ###################################################################
output_result_data_path = geological_model.output_result_data_path;
diary_file_name = [output_result_data_path, filesep, 'LOG_INFO_', geological_model_name, '_', showtimenow(0), '.txt'];
diary(diary_file_name);
diary on;

displaytimelog(['func: ', func_name]);

displaytimelog(['func: ', func_name, '. ', 'current_data_path: ', current_data_path]);
displaytimelog(['func: ', func_name, '. ', 'geological_model_mat_file_path: ', geological_model_mat_file_path]);

displaytimelog(['func: ', func_name, '. ', 'output_result_data_path: ', output_result_data_path]);

input_geological_model_path = geological_model.input_geological_model_path;
displaytimelog(['func: ', func_name, '. ', 'input_geological_model_path: ', input_geological_model_path]);

output_mat_data_path = geological_model.output_mat_data_path;
displaytimelog(['func: ', func_name, '. ', 'output_mat_data_path: ', output_mat_data_path]);

if exist('layerGridModel', 'var') && exist('layerCoeffModel', 'var') &&exist('velocityModel', 'var')
    displaytimelog(['func: ', func_name, '. ', 'Variable layerGridModel / velocityModel exists']);
else
    displaytimelog(['func: ', func_name, '. ', 'importdata layerGridModel ... ']);
    layerGridModel  = importdata([output_mat_data_path, filesep, 'layerGridModel.mat']);
    displaytimelog(['func: ', func_name, '. ', 'importdata layerCoeffModel ... ']);
    layerCoeffModel = importdata([output_mat_data_path, filesep, 'layerCoeffModel.mat']);
    displaytimelog(['func: ', func_name, '. ', 'importdata velocityModel ... ']);
    velocityModel   = importdata([output_mat_data_path, filesep, 'velocityModel.mat']);
    displaytimelog(['func: ', func_name, '. ', 'importdata faultGridModel ... ']);
    faultGridModel  = importdata([output_mat_data_path, filesep, 'faultGridModel.mat']);
end

% % displaytimelog(['func: ', func_name, '. ', 'importdata layerGridModelTY ... ']);
% layerGridModel  = importdata([output_mat_data_path, filesep, 'layerGridModelTY.mat']);
% layerCoeffModel = importdata([output_mat_data_path, filesep, 'layerCoeffModelTY.mat']);
% velocityModel   = importdata([output_mat_data_path, filesep, 'velocityModelTY.mat']);

% displaytimelog(['func: ', func_name, '. ', 'importdata layergriddata1000 / layerModel1000 / VelModnew ... ']);
% layerGridModel = load_mat_data('layergriddata1000.mat');
% layerCoeffModel = load_mat_data('layerModel1000.mat');
% velocityModel =  load_mat_data('VelModnew.mat');
%
%
layerRangeModel = importdata([output_mat_data_path, filesep, 'layerRangeModel.mat']);

baseCoord = importdata([output_mat_data_path, filesep, 'baseCoord.mat']);
displaytimelog(['func: ', func_name, '. ', 'baseCoord: ', num2str(baseCoord)]);

% sensorsCoord = geological_model.sensorData;
sensorsCoord = importdata([output_mat_data_path, filesep, 'sensorData.mat']);

undergroundCoordsSet = sensorsCoord((sensorsCoord(:, 3) < 0), :);
% bottom_sensor_coordinate:  [-3.05915354378521,-45.6872047241777,-4050.73588976378];
% The relative coordinate origin point of sensor position is the well top
bottom_sensor_coordinate = undergroundCoordsSet(end, :);
sensors_num = size(undergroundCoordsSet,1);
displaytimelog(['func: ', func_name, '. ', 'sensors_num: ', num2str(sensors_num), ', bottom_sensor_coordinate: ', num2str(bottom_sensor_coordinate)]);

retrieval_model_default_area = [-1500, 1500; -1500, 1500 ; -2500, -300];
displaytimelog(['func: ', func_name, '. ', 'default area. retrieval_model_area: x = ', num2str(retrieval_model_default_area(1, :)), ...
    ', y = ', num2str(retrieval_model_default_area(2, :)), ', z = ', num2str(retrieval_model_default_area(3, :))]);

retrieval_model_area =compute_retrieval_model_area(layerGridModel, undergroundCoordsSet, retrieval_model_default_area);
displaytimelog(['func: ', func_name, '. ', 'updated area. retrieval_model_area: x = ', num2str(retrieval_model_area(1, :)), ...
    ', y = ', num2str(retrieval_model_area(2, :)), ', z = ', num2str(retrieval_model_area(3, :))]);

retrieval_model_grid_size = [20; 20; 15];

x_range = ['_x_', num2str(retrieval_model_area(1,1)), '_', num2str(retrieval_model_area(1,2)), '_', num2str(retrieval_model_grid_size(1))];
y_range = ['_y_', num2str(retrieval_model_area(2,1)), '_', num2str(retrieval_model_area(2,2)), '_', num2str(retrieval_model_grid_size(2))];
z_range = ['_z_', num2str(retrieval_model_area(3,1)), '_',  num2str(retrieval_model_area(3,2)), '_', num2str(retrieval_model_grid_size(3))];
output_retrieval_model_filename = ['_RM_', 'unit_m',  x_range, y_range, z_range, '_sensors_', num2str(sensors_num)];
displaytimelog(['func: ', func_name, '. ', 'output_retrieval_model_filename: ', output_retrieval_model_filename]);

%
% return;
% retrieval_model_domain:  [x_min, x_max; y_min, y_max; z_min, z_max]; % 3*2
% retrieval_model_relative_domain = [bottom_sensor_coordinate ; bottom_sensor_coordinate]' + retrieval_model_area;
top_sensor_coordinate = undergroundCoordsSet(1, :);
retrieval_model_relative_domain = [top_sensor_coordinate ; top_sensor_coordinate]' + retrieval_model_area;
retrieval_model_relative_domain_with_grid_size = [retrieval_model_relative_domain,  retrieval_model_grid_size];

% VDTForm = generateVDTForm(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, undergroundCoordsSet, ...
%     retrieval_model_relative_domain, retrieval_model_grid_size, [output_result_data_path, filesep, output_retrieval_model_filename]);

faultPositions = [];
for i = 1:length(faultGridModel)
    xMat = faultGridModel{i, 1};
    yMat = faultGridModel{i, 2};
    zMat = faultGridModel{i, 3};
    faultPositions = [faultPositions; xMat(:), yMat(:), zMat(:)];
end

numfaultPositions = length(faultPositions);
displaytimelog(['func: ', func_name, '. ', 'numfaultPositions: ', num2str(numfaultPositions)]);

RMDomain_file_name =  [output_result_data_path, filesep, 'Domain_faultGridModel', num2str(numfaultPositions), '.mat'];
displaytimelog(['func: ', func_name, '. ', 'RMDomain_file_name: ', RMDomain_file_name]);
save(RMDomain_file_name, 'faultPositions');

VDTForm = generateFaultVDTForm(layerCoeffModel, layerGridModel, velocityModel, layerRangeModel, undergroundCoordsSet, faultPositions);

RMVDT_file_name   = [output_result_data_path, filesep, 'VDTForm_faultGridModel', num2str(numfaultPositions), '.mat'];
displaytimelog(['func: ', func_name, '. ', 'RMVDT_file_name: ', RMVDT_file_name]);
save(RMVDT_file_name,'VDTForm');

diary off;


