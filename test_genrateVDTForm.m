
%
%
%
%  DEBUG ! ! !
dbstop if error;
format long % short % 
%
% clear
func_name = mfilename;
disp(['func_name: ', func_name]);

% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data initial
% test_read_input_data();
[input_data_path, output_data_path, current_data_path] = add_default_folder_path();
diary_file_name = [output_data_path, filesep, 'LOG_INFO', showtimenow(0), '.txt'];
diary(diary_file_name);
diary on;
disp(['func_name: ', func_name, '. ', 'input_data_path: ', input_data_path]);
disp(['func_name: ', func_name, '. ', 'output_data_path: ', output_data_path]);
disp(['func_name: ', func_name, '. ', 'current_data_path: ', current_data_path]);

%
geological_model_name = 'geological_model_xinjiang_2020_XJ';
% geological_model_name = 'geological_model_2023_T106';
% geological_model_name = 'geological_model_2023_T131';
geological_model_file_path = [current_data_path, filesep, geological_model_name, '.mat'];
disp(['func_name: ', func_name, '. ', 'geological_model_file_path: ', geological_model_file_path]);
if exist('geological_model', 'var')
    disp(['func_name: ', func_name, '. ', 'Variable geological_model exists']);
else
    disp(['func_name: ', func_name, '. ', 'Variable geological_model does not exist, now importdata ... ']);
    geological_model = importdata(geological_model_file_path);
end

layerGridModel = load_mat_data('layergriddata1000.mat');
layerCoeffModel = load_mat_data('layerModel1000.mat');
velocityModel =  load_mat_data('VelModnew.mat');

layerGridModel = geological_model.layerGridModel;
layerCoeffModel = geological_model.layerCoeffModel;
velocityModel = geological_model.velocityModel;

sensorsCoord = geological_model.sensorData;
undergroundCoordsSet = sensorsCoord((sensorsCoord(:, 3) < 0), :);
% bottom_sensor_coordinate:  [-3.05915354378521,-45.6872047241777,-4050.73588976378];

% The relative coordinate origin point of sensor position is the wellhead
bottom_sensor_coordinate = undergroundCoordsSet(end, :);
sensors_num = size(undergroundCoordsSet,1);
disp(['func_name: ', func_name, '. ', 'sensors_num: ', num2str(sensors_num), 'bottom_sensor_coordinate: ', num2str(bottom_sensor_coordinate)]);

retrieval_model_area = [-2800, 3100; -2800, 3100 ; -600, 1000];

% retrieval_model_grid_size:  [delta_x; delta_y; delta_z]; % 3 * 1
retrieval_model_grid_size = [10; 10; 10];
disp(['func_name: ', func_name, '. ', 'retrieval_model_area: x = ', num2str(retrieval_model_area(1, :)), ...
                            ', y = ', num2str(retrieval_model_area(2, :)), ', z = ', num2str(retrieval_model_area(3, :))]);

x_range = ['_x_', num2str(retrieval_model_area(1,1)), '_', num2str(retrieval_model_area(1,2)), '_', num2str(retrieval_model_grid_size(1))];
y_range = ['_y_', num2str(retrieval_model_area(2,1)), '_', num2str(retrieval_model_area(2,2)), '_', num2str(retrieval_model_grid_size(2))];
z_range = ['_z_', num2str(retrieval_model_area(3,1)), '_',  num2str(retrieval_model_area(3,2)), '_', num2str(retrieval_model_grid_size(3))];
output_retrieval_model_filename = ['_RM_', 'unit_m',  x_range, y_range, z_range, '_sensors_', num2str(sensors_num)];
disp(['func_name: ', func_name, '. ', 'output_retrieval_model_filename: ', output_retrieval_model_filename]);

RMDomain_file_name =  [output_data_path, 'Domain_', output_retrieval_model_filename, '.mat'];
disp(['func_name: ', func_name, '. ', 'RMDomain_file_name: ', RMDomain_file_name]);
save(RMDomain_file_name, 'retrieval_model_area');

% retrieval_model_domain:  [x_min, x_max; y_min, y_max; z_min, z_max]; % 3*2
retrieval_model_relative_domain = [bottom_sensor_coordinate ; bottom_sensor_coordinate]' + retrieval_model_area;
retrieval_model_relative_domain_with_grid_size = [retrieval_model_relative_domain,  retrieval_model_grid_size];

VDTForm = generateVDTForm(layerCoeffModel, layerGridModel, velocityModel, undergroundCoordsSet, ...
                                     retrieval_model_relative_domain, retrieval_model_grid_size, [output_data_path, output_retrieval_model_filename]);

RMVDT_file_name   = [output_result_data_path, 'VDTForm_', output_retrieval_model_filename, '.mat'];
disp(['func_name: ', func_name, '. ', 'RMVDT_file_name: ', RMVDT_file_name]);
save(RMVDT_form_name,'VDTForm');

diary off;


