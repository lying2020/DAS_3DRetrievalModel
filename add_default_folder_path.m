

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [input_data_path, output_data_path, current_data_path] = add_default_folder_path()

func_name = mfilename;
displaytimelog(['func: ', func_name]);

fullpath_name = mfilename('fullpath');
[addpath_name, ~]=fileparts(fullpath_name);

current_data_path = addpath_name;
input_data_path = [addpath_name, filesep, '..', filesep, 'input_data', filesep];
output_data_path =  [addpath_name, filesep, '..', filesep, 'output_data', filesep];

% addpath_recursive([addpath_name, filesep, 'code']);
addpath_recursive(current_data_path);
addpath_recursive(input_data_path);

addpath_arrivaltimedata = [input_data_path, 'arrivaltimedata'];
displaytimelog(['func: ', func_name, '. ', 'addpath_arrivaltimedata: ', addpath_arrivaltimedata]);
addpath(genpath(addpath_arrivaltimedata));

addpath_layerModel = [input_data_path, 'layerModel'];
displaytimelog(['func: ', func_name, '. ', 'addpath_layerModel: ', addpath_layerModel]);
addpath(genpath(addpath_layerModel));

addpath_include = [addpath_name, filesep, 'include'];
displaytimelog(['func: ', func_name, '. ', 'addpath_include: ', addpath_include]);
addpath(genpath(addpath_include));

end

function addpath_recursive(folder)
    % ��ӵ�ǰ�ļ��е�·��
    addpath(genpath(folder));
    if (contains(folder, '.git'))
        return;
    end
    displaytimelog(['addpath folder: ', folder]);
    % ��ȡ�ļ����е��������ļ���
    subfolders = dir(fullfile(folder, '*'));

    % ѭ������ÿ�����ļ���
    for i = 1:length(subfolders)
        if subfolders(i).isdir && ~strcmp(subfolders(i).name, '.') && ~strcmp(subfolders(i).name, '..')
            % �����һ�����ļ��У��ݹ�����������
            addpath_recursive(fullfile(folder, subfolders(i).name));
        end
    end
end

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
