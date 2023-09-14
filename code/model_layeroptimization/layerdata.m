%
%
%
%% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to convert the discrete data into grid point data
% and select a reference original point ... ...
%% -----------------------------------------------------------------------------------------------------
function [xMat, yMat, zMat, velocityMat, xTimes, yTimes] = layerdata(txtData, baseCoord, type)
%% -----------------------------------------------------------------------------------------------------
%  transform discrete point data into grid point data
% INPUT:
% txtData: numRow* numDim matrix, import data.
% type: import data type.
% type  =   'layer'  |  'fault'  |  'velocity'   %  |  'well'
% numDim =  5           5            7                     3
% ex1: type = 'layer' | fault;
%            x                        y                       z             i        j    
% 14618840.000000 4649680.000000 -2267.010010   1       1
% 14618860.000000 4649680.000000 -2266.795654   2       1
% 14618860.000000 4649680.000000 -2266.795654   3       1
%              ...                    ...                       ...            ...      ...
% ex2: type = 'velocity';
%  i     j     k          x               y               z                    v    
% 1  	1	88	14618850	4649690	-2904.608826	68.603928
% 2	    1   88	14618870	4649690	-2903.216614	68.603928
% 3	    1   88	14618890	4649690	-2901.550781	68.603928
% ...    ...    ...        ...                ...             ...                   ...              
% 
%  baseCoord: 1*3 array, base coordinate, selected original point.
% OUTPUT:
% if type == 'layer' | 'fault':
% xMat, yMat, zMat = xLen* yLen* zLen matrix;
% velocityMat = []; xTimes, yTimes =[];
% if type == 'velocity';
% xMat, yMat, zMat = xLen* yLen* zLen matrix;
% zMat, velocityMat: xLen* yLen* zLen matrix;  velocity unit: m/s.
% zMat and velocityMat is a three-dimensional matrix,
% zMat, the third dimension represents the coordinates of each point in the Z direction,
%% -----------------------------------------------------------------------------------------------------
%
%  DEBUG ! ! !
dbstop if error;
func_name = mfilename;
disp(['func_name: ', func_name]);
%% -----------------------------------------------------------------------------------------------------
% some default parameters.
if nargin < 3;  type = 'layer';  end
if nargin < 2; baseCoord = [0 0 0];   end
if isempty(baseCoord), baseCoord = [0 0 0];  end
% if txtData is empty or txtData(1, 4) is decimals ... 
if (isempty(txtData) || rem(txtData(1, 4), 1))
    disp(['func_name: ', func_name, 'ERROR FORMAT ']);
    [xMat, yMat, zMat, velocityMat, xTimes, yTimes] = deal([]); 
    return; 
end 
if contains(['layerGridModel', 'faultModel'], type)
    % --------------------------------------------------------------------------------------------------
    % xMax, xMin: 1*2 array, [xLen, yLen] = xMax - xMin + 1;
    [numRow, ~] = size(txtData);
    xyMax = max(txtData(:, end-1: end));
    xyMin = min(txtData(:, end-1: end));
    % --------------------------------------------------------------------------------------------------
    % Select the base coordinates and shift the coordinates to the reference original point
    txtData = txtData - [baseCoord, 0, 0];
    % xySize: 1*2 array, xySize = [xLen, yLen];
    xySize = floor(xyMax - xyMin + 1);
    [xMat, yMat, zMat] = deal( zeros(xySize) );
    % --------------------------------------------------------------------------------------------------
    for i = 1: numRow
        irow = txtData(i, end - 1) - xyMin(end-1) + 1;
        icol = txtData(i, end) - xyMin(end) + 1;
        xMat(irow, icol) = txtData(i, 1);
        yMat(irow, icol) = txtData(i, 2);
        zMat(irow, icol) = txtData(i, 3);
    end
    [velocityMat, xTimes, yTimes] = deal([]);
    return;
end
%% -----------------------------------------------------------------------------------------------------
% if contains('velocityMat', type)    ...  end
[xMat, yMat, zMat, velocityMat, xTimes, yTimes] = velocitydata(txtData, baseCoord, type);
%
%
%
%  conversion between different velocity units  
% 1 ft = 0.3048m;  1 us = 1e-6 s;
% 1 us/ft = 1 us/0.3048 m = 1/0.3048 us/m;
% => 1 ft/us = 0.3048 m/us = 304.8* 1000 m/s;
% => x us/ft = x* 1/304800 s/m;
% => velocity = 304800 / x  m/s;
%
%% --------------------------------------------------------------------------------------------------






