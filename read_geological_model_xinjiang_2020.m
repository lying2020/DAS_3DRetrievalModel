


%
%
%
%  DEBUG ! ! !
dbstop if error;
format long % short % 
%
% clear
warning off;
tic

func_name = mfilename;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('input_data_path', 'var')
    disp(['func_name: ', func_name, '. ', 'Variable input_data_path exists']);
else
    disp(['func_name: ', func_name, '. ', 'Variable input_data_path does not exist, now importdata ... ']);
    [input_data_path, output_data_path, current_data_path] = add_default_folder_path();
end

disp(['func_name: ', func_name]);

%% input data path: geological model data path
geological_model_path = 'geological_model_xinjiang_2020';
well_name = '_XJ';
input_geological_model_path = [input_data_path, geological_model_path];
disp(['input_geological_model_path: ', input_geological_model_path]);
geological_data_path.path_geological_model = input_geological_model_path;
geological_data_path.path_layer_data_folder = 'complexmodel_layers_new';
geological_data_path.path_faults_data_folder = 'complexmodel_faults';
geological_data_path.path_velocity_data = 'velocityModel';
geological_data_path.path_baseCoord_data = 'baseCoord.txt';
geological_data_path.path_well_data = 'wellModel4.csv';
geological_data_path.path_sensor_data = 'sensorCoord217.csv';




%% ********************************************************************************************************************

% output mat_data path. 
% some intermediate result data, such as layer / velocity-model mesh refinement data, well coords.
output_mat_data_path = [current_data_path, filesep, 'mat_data', well_name];
mkdir(output_mat_data_path);
% creat a log file.
diary_file_name = [output_mat_data_path, filesep, 'LOG_INFO_', geological_model_path, well_name, showtimenow(0), '.txt'];
diary(diary_file_name);
diary on;

disp(['func_name: ', func_name, '. ', 'input_geological_model_path: ', input_geological_model_path]);
disp(['func_name: ', func_name, '. ', 'output_mat_data_path: ', output_mat_data_path]);
disp(['func_name: ', func_name, '. ', 'geological_data_path: ']);
disp(geological_data_path);
%% output result data path. 3D retrieval model path
output_result_data_path = [output_data_path, filesep, geological_model_path, well_name, '_retrieval_result_data'];
disp(['func_name: ', func_name, '. ', 'output_result_data_path: ', output_result_data_path]);
mkdir(output_result_data_path);

% results data
geological_model = read_input_data(geological_data_path, output_mat_data_path);

geological_model.output_result_data_path = output_result_data_path;
geological_model.output_mat_data_path = output_mat_data_path;
geological_model.input_geological_model_path = input_geological_model_path;

savedata(geological_model, [current_data_path, filesep], [geological_model_path, well_name], '.mat');

diary off;



time_2020 = toc
