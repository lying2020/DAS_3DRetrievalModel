%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to obtain the equivalent velocity between the different layers
%% -----------------------------------------------------------------------------------------------------
function [velocityModel, velocityCount, velocityModelTY, xMat, yMat, zMat, velocityMat]= getvelocitymodel(filenameList, baseCoord, layerCoeffModel, layerGridModel, layerRangeModel, pathSave)  %  , type)
% -----------------------------------------------------------------------------------------------------
% INPUT: 
% filenameList: 1*1 cell, a list of filenames for the velocity file
%
% layerCoeffModel: numLayer* 1 cell. each cell contains (m -1)* (n -1) cell,
% and each cell contains a 1* numCoeff matrix.
%
% layerGridModel: numLayer* numDim cell. The discret point set of the given surface,
% each row of cells includes  a m* n matrix containing grid points data of x, y, z - direction of the same layer;
% layer data should be stored from top to bottom.
%
% baseCoord: 1*3 array, base coordinate, selected original point.
% type: import data type.
% type  =   'layer'  |  'fault'  |  'velocity'   %  |  'well'
% numDim =  5           5            7                     3
% OUTPUT:
% velocityModel: (numLayer + 1)* (numLayer + 1) matrix.
% ex:
% each element is the equivalent velocity between the different layers
% the first column is (numLayer + 1) valid velocity values in numLayer layers;
% the second column is numLayer valid velocity values in (numLayer - 1) layers (except the top layer);
% the 3th column is (numLayer -1) valid velocity values in  (numLayer -2) layers (except the top 2 layers);
% ... ...
% the penultimate() column is 2 valid velocity values in  1 layer (just keep the bottom layer);
% the last column is 1 valid velocity value for the entire geological model.
%% -----------------------------------------------------------------------------------------------------
% some default parameters.
% if nargin < 5, type = 'velocity';   end
if nargin < 5
    if nargin < 1
        filenameList = getfilenamelist('layer');
    end
    if nargin < 2
        baseCoord =zeros(1, 3);
    end

    [baseCoord, layerCoeffModel, layerGridModel, layerRangeModel] = getlayermodel(filenameList, baseCoord);
end

type = 'velocity';
if nargin <1,   filenameList = getfilenamelist(type);     end
% -----------------------------------------------------------------------------------------------------
% getfilenamelist: gets a list of filenames for the target file
% filenameList is a cell array
if isempty(filenameList)
    %     msg = {'func: readbindata', ' -- '};
    %     hr = warndlg(msg, ' there is a warning');
    msg = {'func: getvelocitymodel ', ' -- the filename list is empty, please re-select the read file path. '};
    hr = warndlg(msg, 'Read file exception !');
   velocityModel = [];  velocityCount = [];
   [xMat, yMat, zMat, velocityMat] = deal(0);
    pause(3);     if ishandle(hr), close(hr); end
    return;
end

if ~iscell(filenameList),  filenameList = {filenameList};   end

if ~contains(filenameList{1, 1}, 'velocity')
    velocityModel = [];  velocityCount = [];
    warning('error filename, reselect velocity file !!!');
    return;
end
%% -----------------------------------------------------------------------------------------------------
% layerTmp is a n*7 matrix.
layerTmp = readtxtdata(filenameList, type);
% layerTmp = readlayerdata(filenameList{1, 1});
%
[xMat, yMat, zMat, velocityMat] = layerdatatransform(layerTmp, baseCoord, type);
% [xMat, yMat, zMat, velocityMat] = velocitydata(txtData, baseCoord);     % for velocity model
%% There may be a problem with the outermost data interpolation
xMat = xMat(2:end-1, 2:end-1);
yMat = yMat(2:end-1, 2:end-1);
zMat = zMat(2:end-1, 2:end-1, :);
velocityMat = velocityMat(2:end-1, 2:end-1, :);
%% -------------------------------------------------------------------------------------
[xLen, yLen, zLen] = size(zMat);
%% 
% xMat, yMat, zMat = xLen* yLen matrix;
% each element represents the coordinates in the x and Y directions for each position in the geological model
%
% zMat and velocityMat is a three-dimensional matrix,
% zMat = xLen* yLen* zLen matrix, zLen parallel geologic strata.
% the third dimension represents the coordinates of each point in the Z direction,
%
% velocityMat = xLen* yLen* zLen matrix
% velocity unit: m/s, each element represents a velocity value for each position.
% [xLen, yLen, zLen] = size(zMat);
%% -----------------------------------------------------------------------------------------------------
numLayer = length(layerCoeffModel);
%
% velocityData: (numLayer + 1)* 1 cell, each cell contains many data points.
% velocityData is used to store velocity value between the different layers.
% velocityData = cell(numLayer+1, 1);
%
% layerzMat: xLen* yLen cell, each cell contains numLayer* 1 matrix,
% layerzMat is used to store the z values of x, y coordinates in different layers.
% layerzMat = cell(xLen, yLen);
%
velocityModel = zeros(numLayer + 1, numLayer + 1);
velocityModel(1, end) = mean(velocityMat(:));
velocityCount =  zeros(numLayer + 1, numLayer + 1);
velocityCount(1, end) = xLen*yLen*zLen;
%
% idxLayer: numLayer* 1matrix, layer index.
idxLayer = (1:numLayer)';

for ir = 1: xLen
    for ic = 1:yLen
        xy = [xMat(ir, ic), yMat(ir, ic)];
        xyArray = repmat(xy, numLayer, 1);
        % zArray: numLayer*1 matrix, z value for the same horizontal position and different layers
        zArray = computelayerz(layerCoeffModel, layerGridModel, layerRangeModel, xyArray, idxLayer);
        zArrayMat = get_z_array_mat(zArray, numLayer);
        for idepth = 1: zLen
            %% -----------------------------------------------------------------------------------------------------
            % % idx:  z0-value is between the (idx-1)-th and idx-th layer
            % %  idx = find(zArray <= zMat(ir, ic, idepth), 1);
            % % if isempty(idx),  idx = numLayer + 1;  end
%             idx = zlocation(zArrayMat, zMat(ir, ic, idepth), numLayer);
%                 for i = 1: numLayer  % length(idx)
%                     velocityModel(idx(i), i) = velocityModel(idx(i), i) + velocityMat(ir, ic, idepth);
%                     %  velocityModel(idx(i), i) =  (velocityModel(idx(i), i)* velocityCount(idx(i), i) + velocityMat(ir, ic, idepth)) / (velocityCount(idx(i), i) + 1);
%                     velocityCount(idx(i), i) = velocityCount(idx(i), i) + 1;
%                 end
            %% -----------------------------------------------------------------------------------------
            % average the data points between the two layers
            for i = 1: numLayer  % length(idx)
                tmp = find(zArrayMat(:, i) <= zMat(ir, ic, idepth), 1);
                if isempty(tmp), tmp = (numLayer - i + 1) + 1;   end
                velocityModel(tmp, i) = velocityModel(tmp, i) + velocityMat(ir, ic, idepth);
                velocityCount(tmp, i) = velocityCount(tmp, i) + 1;
            end
            %             if (velocityCount(2, 1) - velocityCount(1, 2))
            %                 displaytimelog(['error is here: ',  num2str(ir), ', ', num2str(ic)]);
            %                 pause(10);
            %             end
        end  % idepth = 1: zLen
    end   % ic = 1:yLen
    %     pause(2);
end  % ir = 1: xLen

velocityCount = max(velocityCount, 1);
velocityModel = velocityModel./ velocityCount;
%
%
if (velocityModel(1, 1) < 0.001),  velocityModel(1, 1) = velocityModel(2, 1);   end

velocityModelTY = velocityModel(:, 1);

%% save velocityModel into folder geologicaldata.
if nargin > 5
    currentpath = mfilename('fullpath');
    [pathname] = fileparts(currentpath);
    % pathname = [pathname, filesep, '..', filesep, '..', filesep, 'geologicaldata'];
    if isfolder(pathSave), pathname = pathSave;  end
    % savedata(velocityModel, pathname, ['velocityModel_', num2str(numLayer+1)], '.mat');
    % savedata(velocityCount, pathname, ['velocityCount_', num2str(numLayer+1)], '.mat');
    savedata(velocityModelTY, pathname, 'velocityModelTY', '.mat');
    savedata(velocityModel, pathname, 'velocityModel', '.mat');
    savedata(velocityCount, pathname, 'velocityCount', '.mat');

    savedata(velocityModelTY, pathname, ['velocityModelTY', num2str(numLayer+1)], '.csv');
    savedata(velocityModel, pathname, ['velocityModel', num2str(numLayer+1)], '.csv');
    savedata(velocityCount, pathname, ['velocityCount', num2str(numLayer+1)], '.csv');
end
%
end
%
%
%
%% -----------------------------------------------------------------------------------------------------
function zArrayMat = get_z_array_mat(zArray, numLayer)
%
% INPUT:
% zArray: numLayer* 1 matrix, z value for the same horizontal position and different layers
% num = length(zArray);
%
% OUTPUT:
% % zArrayMat: numLayer* numLayer matrix.
% the i column contains the (i: num) row z value of zArray.
% ex: zArray: [1 2 3 4 5]';
% zArrayMat:
% 1  2  3  4  5
% 2  3  4  5  0
% 3  4  5  0  0
% 4  5  0  0  0
% 5  0  0  0  0
% -----------------------------------------------------------------------------------------------------
% numLayer = length(zArray);
zArrayMat = zeros(numLayer, numLayer);
for i = 1: numLayer
    zArrayMat(1: (numLayer - i + 1), i) = zArray(i: numLayer);
    %
end
%
%
end
%
%
%
%% -----------------------------------------------------------------------------------------------------
function idx = zlocation(zArrayMat, z0, numLayer)
% -----------------------------------------------------------------------------------------------------
% this code is used to determine what layers the z0-value is between.
% INPUT:
% zArrayMat: numLayer*numLayer matrix, z value of different layer.
% z0: a scale
% num = size(zArrayMat);  (num = numLayer).
% OUTPUT:
% idx: 1* numLayer array,
% -----------------------------------------------------------------------------------------------------
idx = zeros(1, numLayer);
for i = 1:numLayer
    tmp = find(zArrayMat(:, i) <= z0, 1);
    if isempty(tmp), tmp = (numLayer - i + 1) + 1;   end
    idx(i)  = tmp;
end


end






