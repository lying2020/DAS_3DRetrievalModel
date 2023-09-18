


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
    disp(['func: ', func_name, '. ', 'Variable input_data_path exists']);
else
    disp(['func: ', func_name, '. ', 'Variable input_data_path does not exist, now importdata ... ']);
    [input_data_path, output_data_path, current_data_path] = add_default_folder_path();
end


%% input data path: geological model data path
geological_model_path = 'geological_model_xinjiang_2020';
well_name = '_XJ';
input_geological_model_path = [input_data_path, geological_model_path];
geological_data_path.path_geological_model = input_geological_model_path;
geological_data_path.path_layer_data_folder = 'complexmodel_layers_new';
geological_data_path.path_faults_data_folder = 'complexmodel_faults';
geological_data_path.path_velocity_data = 'velocityModel';
geological_data_path.path_baseCoord_data = 'baseCoord.txt';
geological_data_path.path_well_data = 'wellModel4.csv';
geological_data_path.path_sensor_data = 'sensorCoord217.csv';






%% ********************************************************************************************************************
% creat a log file.
diary_file_name = [current_data_path, filesep, geological_model_path, well_name, '_LOG_INFO_', showtimenow(0), '.txt'];
diary(diary_file_name);
diary on;

displaytimelog(['func: ', func_name]);

displaytimelog(['input_geological_model_path: ', input_geological_model_path]);

% geological_data_path
displaytimelog(['func: ', func_name, '. ', 'geological_data_path: ']);
displaytimelog(geological_data_path);

% output result data path. 3D retrieval model path
output_result_data_path = [output_data_path, filesep, geological_model_path, well_name, '_retrieval_result_data'];
displaytimelog(['func: ', func_name, '. ', 'output_result_data_path: ', output_result_data_path]);
mkdir(output_result_data_path);

% results data
geological_model = read_input_data(geological_data_path, output_result_data_path);

savedata(geological_model, [current_data_path, filesep], [geological_model_path, well_name], '.mat');

diary off;



time_2020 = toc
