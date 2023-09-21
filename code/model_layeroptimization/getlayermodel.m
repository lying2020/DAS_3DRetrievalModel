%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log: 
% 2020-10-29: Modify the description and comments
% this code is used to transform the data points into different models
%% -----------------------------------------------------------------------------------------------------
function  [baseCoord, layerCoeffModel, layerGridModel, layerRangeModel, layerCoeffModelTY, layerCoeffModel_zdomainTY] = getlayermodel(filenameList, baseCoord, layerModelParam)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% filenameList: num*1 cell, a list of filenames for the layer file
% baseCoord: 1*3 array, base coordinate, selected original point.
% layerModelParam: gridFlag | gridType | fittingType | layerType | pathSave
% fittingType: fitting type: 'cubic'  | 'quad'  |  'linear' | 'nonlinear'.
% layerType: import data type.
% layerType  =   'layer'  |  'fault'
%    numDim =       5           5
% gridFlag: true | false,   gridrefined or not
% !!!!!    fault's fitting type must be 'linear'.
%
% OUTPUT:
% layerGridModel: num* 3 cell, each row contains xMat, yMat, zMat grid point data.
% layer data should be stored from top to bottom.
%
% layerCoeffModel: num* 1 cell, each row contains (m-1)*(n-1) small cell,
% and each small cell contains 1*numCoeff coeff matrix.
% 
% layerRangeModel: num * 6, num layers * [x_min, x_max, y_min, y_max, z_min, z_max]

%% -----------------------------------------------------------------------------------------------------
%
%  DEBUG ! ! !
dbstop if error;

func_name = mfilename;
displaytimelog(['func: ', func_name]);
%% some default parameters.
gridFlag = false;
gridType = 'linear';
gridStepSize = [10, 10];
gridRetractionDist = [10, 10];
fittingType = 'nonlinear';
layerType = 'layer';
pathSave = [];
if nargin == 3
   gridFlag = layerModelParam.gridFlag;
   gridType = layerModelParam.gridType;
   gridStepSize = layerModelParam.gridStepSize;
   gridRetractionDist = layerModelParam.gridRetractionDist;

   fittingType = layerModelParam.fittingType;
   layerType = layerModelParam.layerType;
   pathSave = layerModelParam.pathSave;

end

% if nargin < 2, baseCoord = [0, 0, -1e5];   end
if nargin < 1,  filenameList = getfilenamelist(layerType);  end

% -----------------------------------------------------------------------------------------------------
%% getfilenamelist: gets a list of filenames for the target file
% filenameList is a cell array
numLayer = length(filenameList);
% type = 'layer';
layerGridModel = cell(numLayer, 3);
layerCoeffModel = cell(numLayer, 1);
layerRangeModel = cell(numLayer, 1);
meanZ = zeros(numLayer, 1);
%
if nargin < 2 || isempty(baseCoord)
    baseCoord = [0, 0, -1e5];
    for iFile = 1:numLayer
        %% layerTmp is a n*5 matrix.
        layerTmp = readtxtdata(filenameList{iFile}, layerType);
        if isempty(layerTmp)
            continue;
        end
        if baseCoord(1, 3) < layerTmp(1, 3),   baseCoord = layerTmp(1, 1:3);    end
    end
end
%% -----------------------------------------------------------------------------------------------------
displaytimelog(['func: ', func_name, '. ', 'baseCoord: ', num2str(baseCoord) ]);
displaytimelog(['func: ', func_name, '. ', 'layerModelParam: ' ]);
displaytimelog(layerModelParam);

layer_cnt = 0;
for iFile = 1 : numLayer
    %% layerTmp is a n*5 matrix.
    displaytimelog(['func: ', func_name, '. ', 'numLayer: ', num2str(numLayer), ', layer_cnt: ', num2str(layer_cnt), ', iFile: ', num2str(iFile), ', filename: ', filenameList{iFile} ]);
    layerTmp = readtxtdata(filenameList{iFile}, layerType);
    if isempty(layerTmp)
        displaytimelog(['func: ', func_name, '. ', 'isempty(layerTmp) == true.']);
        continue;
    end
    layer_cnt = layer_cnt + 1;
    %% xMat is a m* n matrix.
    [xMat, yMat, zMat] = layerdatatransform(layerTmp, baseCoord, layerType);
    if isempty(xMat)
        displaytimelog(['func: ', func_name, '. ', 'isempty(xMat) == true.']);
        continue;
    end
    %% Record the average of the z coordinates
    meanZ(layer_cnt, 1) = mean(mean(zMat));
   %   There is incorrect data in the coordinates of the edge
    xMat = xMat(2:end-1, 2:end-1);
    yMat = yMat(2:end-1, 2:end-1);
    zMat = zMat(2:end-1, 2:end-1);

    %% If you need further grid refinement
    if gridFlag
        [xMat, yMat, zMat] = gridrefined(xMat, yMat, zMat,  gridStepSize, gridType, gridRetractionDist);
    end
    %     % [xMat, yMat, zMat] = gridrefined(xMat, yMat, zMat, 5, 'natural');

    %% if layerType == 'fault', we nead linear interpolation
    if contains('faultModel', layerType)
        [xMat, yMat, zMat] = gridrefined(xMat, yMat, zMat);
    end
    %% coeffMat is a (m-1)*(n-1) cell.
    if contains('faultModel', layerType), fittingType = 'linear'; end
    coeffMat = layerdatafitting(xMat, yMat, zMat, gridStepSize, fittingType);
    %
    layerGridModel(layer_cnt, 1:3)= {xMat, yMat, zMat};
    %
    layerCoeffModel{layer_cnt, 1} = coeffMat;
    %
    tmpM = [min(xMat(:)), max(xMat(:)), abs(xMat(2, 1) - xMat(1, 1)); ...
            min(yMat(:)), max(yMat(:)), abs(yMat(1, 2) - yMat(1, 1)); ...
            min(zMat(:)), max(zMat(:)), 1];

    layerRangeModel{layer_cnt, 1} = tmpM;
    displaytimelog(['func: ', func_name, '. ', 'layer_cnt = ', num2str(layer_cnt), ', layerRange_X: ', num2str([min(xMat(:)), max(xMat(:)), abs(xMat(2, 1) - xMat(1, 1))])]);
    displaytimelog(['func: ', func_name, '. ', 'layer_cnt = ', num2str(layer_cnt), ', layerRange_Y: ', num2str([min(yMat(:)), max(yMat(:)), abs(yMat(1, 2) - yMat(1, 1))])]);
    displaytimelog(['func: ', func_name, '. ', 'layer_cnt = ', num2str(layer_cnt), ', layerRange_Z: ', num2str([min(zMat(:)), max(zMat(:)), abs(max(zMat(:)) - min(zMat(:)))])]);

    %
end

displaytimelog(['func: ', func_name, '. ', 'layer_cnt: ', num2str(layer_cnt), ', layerType: ', layerType]);
if( 0 == layer_cnt), return; end

% -----------------------------------------------------------------------------------------------------
%%  sequence the layer from top to bottom
[~, idxZ] = sort(meanZ(1 : layer_cnt), 'descend');
layerGridModel = layerGridModel(idxZ, :);
layerCoeffModel = layerCoeffModel(idxZ, :);
layerRangeModel = layerRangeModel(idxZ, :);

 [layerCoeffModelTY, layerCoeffModel_zdomainTY] = fitting_tanyan(layerGridModel);
%
%
%
%% save velocityModel into folder geologicaldata.
if ~isempty(pathSave)
    if isfolder(pathSave)
        pathlayerModelParam = [layerType, 'ModelParam'];
        displaytimelog(['func: ', func_name, '. ', 'pathlayerModelParam: ', pathSave, pathlayerModelParam]);
        savedata(layerModelParam, pathSave, pathlayerModelParam, '.mat');

        % pathlayerGridModel = [layerType, 'GridModel_', num2str(numLayer)];
        pathlayerGridModel = [layerType, 'GridModel'];
        displaytimelog(['func: ', func_name, '. ', 'pathlayerGridModel: ', pathSave, pathlayerGridModel]);
        savedata(layerGridModel, pathSave, pathlayerGridModel, '.mat');

        % pathlayerCoeffModel = [layerType, 'CoeffModel_', num2str(numLayer)];
        pathlayerCoeffModel = [layerType, 'CoeffModel'];
        displaytimelog(['func: ', func_name, '. ', 'pathlayerCoeffModel: ' , pathSave, pathlayerCoeffModel]);
        savedata(layerCoeffModel, pathSave, pathlayerCoeffModel, '.mat');

        pathlayerCoeffModelTY = [layerType, 'CoeffModelTY'];
        displaytimelog(['func: ', func_name, '. ', 'pathlayerCoeffModelTY: ', pathSave, pathlayerCoeffModelTY]);
        savedata(layerCoeffModelTY, pathSave, pathlayerCoeffModelTY, '.mat');

        pathlayerCoeffModel_zdomainTY = [layerType, 'CoeffModel_zdomainTY'];
        displaytimelog(['func: ', func_name, '. ', 'pathlayerCoeffModel_zdomainTY: ', pathSave, pathlayerCoeffModel_zdomainTY]);
        savedata(layerCoeffModel_zdomainTY, pathSave, pathlayerCoeffModel_zdomainTY, '.mat');

        pathlayerRangeModel = [layerType, 'RangeModel'];
        displaytimelog(['func: ', func_name, '. ', 'pathlayerRangeModel: ', pathSave, pathlayerRangeModel]);
        savedata(layerRangeModel, pathSave, pathlayerRangeModel, '.mat');

    end
end











