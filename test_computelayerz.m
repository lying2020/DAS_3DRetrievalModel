



%
%
%
%  DEBUG ! ! !
dbstop if error;
format long % short % 
%
% clear
func_name = mfilename;

add_default_folder_path();

%% test_computelayerz

geological_model_name = 'geological_model_2023_T106';

[addpath_name, ~]=fileparts(mfilename('fullpath'));
current_data_path = addpath_name;

diary_file_name = [current_data_path, filesep, 'LOG_INFO_test_computelayerz_', showtimenow(0), '.txt'];
diary(diary_file_name);
diary on;


displaytimelog(['func: ', func_name, '. ', 'current_data_path: ', current_data_path]);
geological_model_mat_file_path = [current_data_path, filesep, geological_model_name, '.mat'];
displaytimelog(['func: ', func_name, '. ', 'geological_model_mat_file_path: ', geological_model_mat_file_path]);

if exist('geological_model', 'var')
    displaytimelog(['func: ', func_name, '. ', 'Variable geological_model exists']);
else
    displaytimelog(['func: ', func_name, '. ', 'Variable geological_model does not exist, now importdata ... ']);
    geological_model = importdata(geological_model_mat_file_path);
end


output_mat_data_path = geological_model.output_mat_data_path;
displaytimelog(['func: ', func_name, '. ', 'output_mat_data_path: ', output_mat_data_path]);


displaytimelog(['func: ', func_name, '. ', 'importdata layerGridModel ... ']);
layerGridModel  = importdata([output_mat_data_path, filesep, 'layerGridModel.mat']);

displaytimelog(['func: ', func_name, '. ', 'importdata layerCoeffModel ... ']);
layerCoeffModelLY = importdata([output_mat_data_path, filesep, 'layerCoeffModel.mat']);

% layerCoeffModelTY = importdata([output_mat_data_path, filesep, 'layerCoeffModelTY.mat']);

layerRangeModel = importdata([output_mat_data_path, filesep, 'layerRangeModel.mat']);

baseCoord = importdata([output_mat_data_path, filesep, 'baseCoord.mat']);
displaytimelog(['func: ', func_name, '. ', 'baseCoord: ', num2str(baseCoord)]);




numLayer = size(layerRangeModel, 1);
test_num_of_each_layer = 3;
layer_offset = 3.8;
displaytimelog(['numLayer: ', num2str(numLayer), ', test_num_of_each_layer: ', num2str(test_num_of_each_layer)]);

for i_layer = 1 : numLayer
    layerRange = layerRangeModel{i_layer, 1};
    xx = linspace(layerRange(1, 1) + layer_offset, layerRange(1, 2) - layer_offset, test_num_of_each_layer);
    yy = linspace(layerRange(2, 1) + layer_offset, layerRange(2, 2) - layer_offset, test_num_of_each_layer);
    for ix = xx
        for iy = yy
            xyArray = [ix, iy]; idxLayer = i_layer;
            displaytimelog(['idxLayer: ', num2str(idxLayer), ', xyArray: ', num2str(xyArray)]);

            zArrayLY = computelayerz(layerCoeffModelLY, layerGridModel, layerRangeModel, xyArray, idxLayer);
            % zArrayTY = layerz_tanyan(layerCoeffModelTY, layerGridModel, layerRangeModel, xyArray, idxLayer);
            % error_TL = zArrayLY - zArrayTY;
            % displaytimelog(['idxLayer: ', num2str(idxLayer), ', xyArray: ', num2str(xyArray), ...
            %                 ', zArrayLY: ', num2str(zArrayLY), ', zArrayTY: ', num2str(zArrayTY), ', error_TL: ', num2str(error_TL)]);
            % if (error_TL > 0.001)
            %     displaytimelog(['error_TL: ', num2str(error_TL)]);
            % end
            disp("   ");
            disp("   ");
        end
    end

end