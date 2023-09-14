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
function  [baseCoord, wellModel] = getwellmodel(filenameList, basetype, pathSave)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% filenameList: 1*1 cell, a list of filenames for the layer file
% basetype: 'top' | 'bottom'.
% 
% OUTPUT:
% baseCoord: 1*3 array, base coordinate, selected original point.
% wellModel: n*4 matrix, [md, x, y, z].
% 
% add path.
currentpath = mfilename('fullpath');
[pathname] = fileparts(currentpath);
pathname = [pathname, filesep, '..', filesep, '..', filesep, 'include'];
addpath(genpath(pathname));
%% -----------------------------------------------------------------------------------------------------
% some default parameters.
if nargin < 2, basetype = 'top';   end
type = 'well';
if nargin < 1,  filenameList = getfilenamelist(type, 'off');  end
% -----------------------------------------------------------------------------------------------------
% getfilenamelist: gets a list of filenames for the target file
%
enum = contains({'top', 'bottom'}, basetype);
if ~any(enum), warning('Error input base coordinate type !'); basetype = 'top';  end

%% z coordinate correction.
zCorrection = [0, 0, 10.5];

%% layerTmp: n*4 matrix, [md, x, y, z]. md is the cumulative depth of well
layerTmp = readtxtdata(filenameList, type);

%% the coordinate of drilling platform.
baseCoord = [14620550.3, 4650200.4, 1525.28];
% 
%% baseCoord is the top coordinates of the well.  (default)
baseCoord = baseCoord - zCorrection;

wellModel = [10.5, baseCoord; layerTmp];
%
%% Coordinates based on the bottom or top of the well.
if strcmp(basetype, 'bottom'), baseCoord = wellModel(end, 2:4);   end

%% well model after adjusting the reference frame
wellModel = wellModel - [10.5, baseCoord];

%% save wellModel into folder geologicaldata.
if nargin > 2
    if isempty(pathSave), pathSave = '';  end
    currentpath = mfilename('fullpath');
    [pathname] = fileparts(currentpath);
    pathname = [pathname, filesep, '..', filesep, '..', filesep, 'geologicaldata'];
    if isfolder(pathSave), pathname = pathSave;  end
    savedata(wellModel, pathname, ['wellModel_4'], '.csv');
    savedata(baseCoord, pathname, ['baseCoord_', basetype], '.txt');
    % addpath(genpath(pathname));
end












