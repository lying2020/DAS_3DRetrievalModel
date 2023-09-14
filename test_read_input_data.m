


%
%
%
%  DEBUG ! ! !
dbstop if error;
format long % short % 
%
% clear
warning off;

func_name = mfilename;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('input_data_path', 'var')
    disp(['func_name: ', func_name, '. ', 'Variable input_data_path exists']);
else
    disp(['func_name: ', func_name, '. ', 'Variable input_data_path does not exist, now importdata ... ']);
    [input_data_path, output_data_path, current_data_path] = add_default_folder_path();
end

diary_file_name = [output_data_path, filesep, 'LOG_INFO', showtimenow(0), '.txt'];
diary(diary_file_name);
diary on;

disp(['func_name: ', func_name]);
%% input data path: geological model data path
% geological_model_path = 'geological_model_xinjiang_2020';
% input_geological_model_path = [input_data_path, geological_model_path];
% disp(['input_geological_model_path: ', input_geological_model_path]);
% well_name = '_XJ';
% geological_data_path.path_geological_model = input_geological_model_path;
% geological_data_path.path_layer_data_folder = 'complexmodel_layers_new';
% geological_data_path.path_faults_data_folder = 'complexmodel_faults';
% geological_data_path.path_velocity_data = 'velocityModel';
% geological_data_path.path_baseCoord_data = 'baseCoord.txt';
% geological_data_path.path_well_data = 'wellModel4.csv';
% geological_data_path.path_sensor_data = 'sensorCoord217.csv';

%% *****************************************************************************
geological_model_path = 'geological_model_2023';
well_name = '_T131';  % well_name = '_T106';  % 
input_geological_model_path = [input_data_path, geological_model_path, well_name];
disp(['input_geological_model_path: ', input_geological_model_path]);
geological_data_path.path_geological_model = input_geological_model_path;
geological_data_path.path_layer_data_folder = ['layers_data', well_name];
geological_data_path.path_faults_data_folder = ['faults_data', well_name];
geological_data_path.path_velocity_data = ['velocity_data', well_name];
geological_data_path.path_baseCoord_data = ['baseCoord', well_name, '.txt'];
geological_data_path.path_well_data = ['well_data', well_name, '.csv'];
geological_data_path.path_sensor_data =['sensorsCoordSet', well_name, '.csv'];
disp(geological_data_path);
% *****************************************************************************

%% output mat_data path. 
% some intermediate result data, such as layer / velocity-model mesh refinement data, well coords.
output_mat_data_path = [current_data_path, filesep, 'mat_data', well_name];
disp(['output_mat_data_path: ', output_mat_data_path]);
mkdir(output_mat_data_path);

%% output result data path. 3D retrieval model path
output_result_data_path = [output_data_path, filesep, geological_model_path, well_name, '_retrieval_result_data'];
disp(['output_result_data_path: ', output_result_data_path]);
mkdir(output_result_data_path);

geological_model = read_input_data(geological_data_path, output_mat_data_path);

geological_model.output_result_data_path = output_result_data_path;
geological_model.output_mat_data_path = output_mat_data_path;
geological_model.input_data_path = input_geological_model_path;

savedata(geological_model, [current_data_path, filesep], [geological_model_path, well_name], '.mat');

diary off;

