
%
%
%
%
close all;
% clear
%clear points intersection
%%  -----------------------------------------------------------
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
%
func_name = mfilename;
displaytimelog(['func: ', func_name]);



wellCoordSet = importdata('wellData.mat');
baseCoord = [14620550.3 4650200.4 1514.78];
%% --------------------------------------------
sp =  [14621234 4650653 2000; 14619460 4650140 -110;   14619580 4650100 2030; 14619460,4650100,-2110; 14619460 4650140 -2110; 14619430 4650140 -2000; 14620022 4650108 1200; 14619240 4650620 -800];  %
ep =   [14619869 4649742 -2990; 14619070 4649700 -2300; 14619000 4649720 -7250; 14619100,4649720,-2340; 14619170 4649700 -2300; 14618920 4649740 -2300];
n = 3;
startpoint = sp(n, :);
endpoint = ep(n, :);
seCoords = [startpoint; endpoint] - baseCoord;
% filenameList is a cell array

if  ~exist('layerGridModel', 'var')
     [layerGridModel, layerCoeffModel, layerRangeModel, layerCoeffModel_zdomain, layerCoeffModelLY, layerGridModelLY] = test_get_layerMat(baseCoord);

end

ax1 = axes(figure);  hold(ax1, 'on');
scatter3(ax1, seCoords(:, 1), seCoords(:, 2), seCoords(:, 3), 50, 'filled');
plot3(ax1, seCoords(:, 1), seCoords(:, 2), seCoords(:, 3), 'b-', 'linewidth', 4.5);

for iFile = 1:num   
    x = layerGridModel{iFile,1};
    y = layerGridModel{iFile,2};
    z = layerGridModel{iFile,3};
    layersurf(ax1, x, y, z);
    % shading(ax1, 'faceted');
end
endpoint = endpoint - startpoint;
startpoint = [0 0 0];

%%  ----------------------------------
% 
tic
% # test 1
for k = [-500: 2:500]
    for s = 1:10
%         displaytimelog(['k: ', num2str(k), '  s: ', num2str(s)]);
        ep = endpoint - [5*k, 2*k, -1000*s];
        % ep = endpoint - [96 48 -2000]; iLayer = 8;  这里直线从拟合多项式之间的缝隙中穿过了。
        [intersection, idxLayer, points]  = layerintersects_tanyan(layerCoeffModel, layerGridModel, layerRangeModel, startpoint, ep);
        [intersection0, idxLayer0, points0]  = computelayerintersectscoords(layerCoeffModelLY, layerGridModelLY, layerRangeModel, startpoint, ep);
        if size(intersection, 1) ~= size(intersection0, 1)
%             continue;
            displaytimelog(['k: ', num2str(k), '  s: ', num2str(s)]);
            displaytimelog('intersectionTY: '); displaytimelog(intersection);
            displaytimelog('intersectionLY: '); displaytimelog(intersection0);

            ax11 = axes(figure);  hold(ax11, 'on');
            for iFile = 1:num
                x = layerGridModel{iFile,1};
                y = layerGridModel{iFile,2};
                z = layerGridModel{iFile,3};
                layersurf(ax11, x, y, z);
                % shading(ax1, 'faceted');
            end
            if ~isempty(intersection)
                 scatter3(ax11, intersection(:, 1), intersection(:, 2), intersection(:, 3), 40, 'blue', 'filled');
            end
            if ~isempty(intersection0)
                 scatter3(ax11, intersection0(:, 1), intersection0(:, 2), intersection0(:, 3), 40, 'red', 'filled');
            end

            sep = [startpoint; ep];
            scatter3(ax11, sep(:, 1), sep(:, 2), sep(:, 3), 40, 'filled');
            plot3(ax11, sep(:, 1), sep(:, 2), sep(:, 3), 'b-', 'linewidth', 1.5);
            xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');

            continue;
        end

        intersects_diff = norm(intersection - intersection0);
        if (intersects_diff) > 1.0
%             continue;
            displaytimelog(['k: ', num2str(k), '  s: ', num2str(s), ', intersects_diff: ', num2str(intersects_diff)]);
            displaytimelog('intersectionTY: '); displaytimelog(intersection);
            displaytimelog('intersectionLY: '); displaytimelog(intersection0);

        end

    end
end

toc

function [layerGridModelTY, layerCoeffModelTY, layerRangeModel, layerCoeffModel_zdomainTY, layerCoeffModelLY, layerGridModelLY] = test_get_layerMat(baseCoord, filenameList_layer)

type = 'layer';
if exist('filenameList_layer', 'var')
    displaytimelog(['func: ', func_name, '. ', 'Variable filenameList_layer exists']);
else
    displaytimelog(['func: ', func_name, '. ', 'Variable filenameList_layer does not exist, now importdata ... ']);
     filenameList_layer = getfilenamelist(type);
end

num = length(filenameList_layer);
layerdata = cell(num, 1);
type = 'layer';
inter = 10;
%
for iFile = 1:num
    layerdata{iFile} = readtxtdata(filenameList_layer{iFile}, type);
end
%     baseCoord =  startpoint;
% layerGridModel = grid_tanyan(layerdata,baseCoord,inter,150,300);
layerGridModelTY = grid_tanyan(layerdata,baseCoord,inter,20,20); % new data
[layerCoeffModelTY, layerCoeffModel_zdomainTY] = fitting_tanyan(layerGridModelTY);

gridFlag = true; gridType = 'linear'; gridStepSize = [10, 10]; gridRetractionDist = [10, 10]; fittingType = 'cubic'; layerType = 'layer';
layerModelParam = struct('gridFlag', gridFlag, 'gridType', gridType, 'gridStepSize', gridStepSize, 'gridRetractionDist', gridRetractionDist, ...
                                                  'fittingType', fittingType, 'layerType', layerType, 'pathSave', []);
[baseCoord, layerCoeffModelLY, layerGridModelLY, layerRangeModel] = getlayermodel(filenameList_layer, baseCoord, layerModelParam);


end

