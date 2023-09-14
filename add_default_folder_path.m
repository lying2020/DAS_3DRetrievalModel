

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [input_data_path, output_data_path, current_data_path] = add_default_folder_path()
fullpath_name = mfilename('fullpath');
[addpath_name, ~]=fileparts(fullpath_name);

current_data_path = addpath_name;
input_data_path = [addpath_name, filesep, '..', filesep, 'input_data', filesep];
output_data_path =  [addpath_name, filesep, '..', filesep, 'output_data', filesep];

% addpath_recursive([addpath_name, filesep, 'code']);
addpath_recursive(current_data_path);
addpath_recursive(input_data_path);

addpath_arrivaltimedata = [input_data_path, 'arrivaltimedata'];
disp(['addpath_arrivaltimedata: ', addpath_arrivaltimedata]);
addpath(genpath(addpath_arrivaltimedata));

addpath_layerModel = [input_data_path, 'layerModel'];
disp(['addpath_layerModel: ', addpath_layerModel]);
addpath(genpath(addpath_layerModel));

addpath_include = [addpath_name, filesep, 'include'];
disp(['addpath_include: ', addpath_include]);
addpath(genpath(addpath_include));

end

function addpath_recursive(folder)
    % 添加当前文件夹到路径
    addpath(genpath(folder));
    disp(['addpath folder: ', folder]);
    % 获取文件夹中的所有子文件夹
    subfolders = dir(fullfile(folder, '*'));

    % 循环遍历每个子文件夹
    for i = 1:length(subfolders)
        if subfolders(i).isdir && ~strcmp(subfolders(i).name, '.') && ~strcmp(subfolders(i).name, '..')
            % 如果是一个子文件夹，递归调用这个函数
            addpath_recursive(fullfile(folder, subfolders(i).name));
        end
    end
end

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
