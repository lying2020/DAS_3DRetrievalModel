


%
%
%
function read_geological_model_2023_T(well_name)
%  DEBUG ! ! !
dbstop if error;
format long % short % 
%
% clear
warning off;

func_name = mfilename;

tic
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('input_data_path', 'var')
    disp(['func: ', func_name, '. ', 'Variable input_data_path exists']);
else
    disp(['func: ', func_name, '. ', 'Variable input_data_path does not exist, now importdata ... ']);
    [input_data_path, output_data_path, current_data_path] = add_default_folder_path();
end

displaytimelog(['func: ', func_name]);

if nargin < 1
    well_name = '_T106';  %  well_name = '_T131';  % 
end
% %% *****************************************************************************
geological_model_path = 'geological_model_2023';
input_geological_model_path = [input_data_path, geological_model_path, well_name];
displaytimelog(['input_geological_model_path: ', input_geological_model_path]);
geological_data_path.path_geological_model = input_geological_model_path;
geological_data_path.path_layer_data_folder = ['layers_data', well_name];
geological_data_path.path_faults_data_folder = ['faults_data', well_name];
geological_data_path.path_velocity_data = ['velocity_data', well_name];
geological_data_path.path_baseCoord_data = ['baseCoord', well_name, '.txt'];
geological_data_path.path_well_data = ['well_data', well_name, '.csv'];
geological_data_path.path_sensor_data =['sensorsCoordSet', well_name, '.csv'];





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



time_2023 = toc


end

