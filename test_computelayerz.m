



%
%
%
%  DEBUG ! ! !
dbstop if error;
format long % short %
%
% clear

close all;

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


if exist('layerCoeffModelLY', 'var') && exist('layerGridModelLY', 'var')
    displaytimelog(['func: ', func_name, '. ', 'Variable layerCoeffModelLY exists']);
else
    displaytimelog(['func: ', func_name, '. ', 'Variable layerCoeffModelLY does not exist, now importdata ... ']);
    displaytimelog(['func: ', func_name, '. ', 'importdata layerGridModel ... ']);
    layerGridModelLY  = importdata([output_mat_data_path, filesep, 'layerGridModel.mat']);
    displaytimelog(['func: ', func_name, '. ', 'importdata layerCoeffModel ... ']);
    layerCoeffModelLY = importdata([output_mat_data_path, filesep, 'layerCoeffModel.mat']);
end

layerRangeModel = importdata([output_mat_data_path, filesep, 'layerRangeModel.mat']);

baseCoord = importdata([output_mat_data_path, filesep, 'baseCoord.mat']);
displaytimelog(['func: ', func_name, '. ', 'baseCoord: ', num2str(baseCoord)]);


% layerGridModelTY  = importdata([output_mat_data_path, filesep, 'layerGridModelTY.mat']);
% layerCoeffModelTY = importdata([output_mat_data_path, filesep, 'layerCoeffModelTY.mat']);

numLayer = size(layerRangeModel, 1);
test_num_of_each_layer = 9;
layer_offset = [3.8, 2.1];
displaytimelog(['numLayer: ', num2str(numLayer), ', test_num_of_each_layer: ', num2str(test_num_of_each_layer)]);

ax1 = axes(figure);  hold(ax1, 'on');
for iFile = 1:4:numLayer
    x = layerGridModelLY{iFile,1};
    y = layerGridModelLY{iFile,2};
    z = layerGridModelLY{iFile,3};
    layersurf(ax1, x, y, z);
    % shading(ax1, 'faceted');
end

tic

xx = [-432.522499999986,-64.5099999999859,303.502500000014,671.515000000014,1039.52750000002,-1536.55999999999,-1168.54749999999,-800.534999999986,1407.54000000001];
yy = [-220.470000000298,147.542499999702,515.554999999702,883.567499999703,-1692.52000000030,-1324.50750000030,-956.495000000298,-588.482500000298,1251.57999999970];

% for i_layer = 1 : numLayer
%     layerRange = layerRangeModel{i_layer, 1};
%     xx = linspace(layerRange(1, 1) + layer_offset(1), layerRange(1, 2) - layer_offset(2), test_num_of_each_layer);
%     yy = linspace(layerRange(2, 1) + layer_offset(1), layerRange(2, 2) - layer_offset(2), test_num_of_each_layer);
for ix = xx
    for iy = yy
        line_xy = [];
        startpoint = [ix, iy, -1000]; endpoint =  [iy, ix, -2500];
        sep = [startpoint; endpoint];
        plot3(ax1, sep(:, 1), sep(:, 2), sep(:, 3), 'b-', 'linewidth', 1.5);
        for i_layer =1:4:numLayer
            xyArray = [ix, iy]; idxLayer = i_layer;
            displaytimelog(['idxLayer: ', num2str(idxLayer), ', xyArray: ', num2str(xyArray)]);

             zArrayLY = computelayerz(layerCoeffModelLY, layerGridModelLY, layerRangeModel, [iy, ix], idxLayer);
            zArrayLY = computelayerz(layerCoeffModelLY, layerGridModelLY, layerRangeModel, xyArray, idxLayer);
            scatter3(ax1, ix, iy,zArrayLY, 40, 'blue', 'filled');
            line_xy = [line_xy; ix, iy,zArrayLY];

            [intersection0, idxLayer0, points0]  = computelayerintersectscoords(layerCoeffModelLY(i_layer, :), layerGridModelLY(i_layer, :), layerRangeModel(i_layer, :), startpoint, endpoint);
            if ~isempty(intersection0)
                 scatter3(ax1, intersection0(:, 1), intersection0(:, 2), intersection0(:, 3), 40, 'red', 'filled');
            end
            %             zArrayTY = layerz_tanyan(layerCoeffModelTY, layerGridModelTY, layerRangeModel, xyArray, idxLayer);
            %             error_TL = zArrayLY - zArrayTY;
            %             displaytimelog(['idxLayer: ', num2str(idxLayer), ', xyArray: ', num2str(xyArray), ...
            %                             ', zArrayLY: ', num2str(zArrayLY), ', zArrayTY: ', num2str(zArrayTY), ', error_TL: ', num2str(error_TL)]);
            %             if (error_TL > 0.001)
            %                 displaytimelog(['error_TL: ', num2str(error_TL)]);
            %             end
            disp("   ");
            disp("   ");
        end

        plot3(ax1, line_xy(:, 1), line_xy(:, 2), line_xy(:, 3), 'r-', 'linewidth', 2.5);
        xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');
        
    end
    
end

time_const = toc