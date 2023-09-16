%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to convert the velocity discrete data into grid point data
% and select a reference original point
%% -----------------------------------------------------------------------------------------------------
function [xMat, yMat, zMat, velocityMat, xTimes, yTimes, iTimes, jTimes, kTimes] = velocitydata(txtData, baseCoord , type)
% -----------------------------------------------------------------------------------------------------
%  transform discrete point data into grid point data
% INPUT:
% txtData: numRow* numDim matrix, import data.
% type: import data type.
% type  =   'layer'  |  'fault'  |  'velocity'   %  |  'well'
% numDim =  5           5            7                     3
% ex2: type = 'velocity';
%  i     j     k          x (m)           y               z                  v (unit: us/ft)
% 1  	1	88	14618850	4649690	-2904.608826	68.603928
% 2	    1   88	14618870	4649690	-2903.216614	68.603928
% 3	    1   88	14618890	4649690	-2901.550781	68.603928
% ...    ...    ...        ...                ...             ...                   ...
%
%  baseCoord: 1*3 array, base coordinate, selected original point.
%
% OUTPUT:
% velocityMat: m*n*k matrix,
%
% if type == 'layer' | 'fault':
% xMat, yMat, zMat = xLen* yLen matrix;
% velocityMat = []; xTimes, yTimes =[];
% if type == 'velocity';
% xMat, yMat, zMat = xLen* yLen matrix;
% each element represents the coordinates in the x and Y directions for each position in the geological model
%
% zMat and velocityMat is a three-dimensional matrix,
% zMat = xLen* yLen* zLen matrix, zLen parallel geologic strata.
% the third dimension represents the coordinates of each point in the Z direction,
%
% velocityMat = xLen* yLen* zLen matrix
% velocity unit: m/s, each element represents a velocity value for each position.
%
%% -----------------------------------------------------------------------------------------------------
% in this code, the type is 'velocity';
% -----------------------------------------------------------------------------------------------------
% some default parameters.
if nargin < 3, type = 'velocity';  end
if nargin < 2; baseCoord = [0 0 0];   end
if isempty(baseCoord), baseCoord = [0 0 0];  end
% -----------------------------------------------------------------------------------------------------
if ~contains('velocityModel', type)
    [xMat, yMat, zMat] = layerdatatransform(txtData, baseCoord, type);
    [velocityMat, xTimes, yTimes] = deal([]);
    return;
end
% if contains('velocityMat', type)    ...  end
% xMax, xMin: 1*2 array, [xLen, yLen] = xMax - xMin + 1;
[numRow, ~] = size(txtData);
xyzMax = max(txtData(:, 1:3));
xyzMin = min(txtData(:, 1:3));
% -----------------------------------------------------------------------------------------------------
% Select the base coordinates and shift the coordinates to the reference original point
txtData = txtData - [0, 0, 0, baseCoord, 0];
% zSize: 1*3 array, xyzSize = [xLen, yLen, zLen];
xyzSize = xyzMax - xyzMin + 1;
[xMat, yMat] = deal( zeros( xyzSize(1), xyzSize(2) ) );
[zMat, velocityMat] = deal( zeros(xyzSize) );
% -----------------------------------------------------------------------------------------------------
for i = 1: numRow
    irow = txtData(i, 1) - xyzMin(1) + 1;
    icol = txtData(i, 2) - xyzMin(2) + 1;
    idepth = txtData(i, 3) - xyzMin(3) + 1;
    xMat(irow, icol) = txtData(i, 4);
    yMat(irow, icol) = txtData(i, 5);
    zMat(irow, icol, idepth) = txtData(i, 6);
     velocityMat(irow, icol, idepth) = txtData(i, 7);   %  unit: m /s.
    if (txtData(i, 7) < 1000)
        velocityMat(irow, icol, idepth) = 304800 / txtData(i, 7);   %  unit: m /s.
    end
end
% 
[z0, idx] = max(txtData(:, 6));
v0 = 304800 / txtData(idx, 7);   %  unit: m /s.

for i = 1: xyzSize(1)
    for j = 1:xyzSize(2)
        for k = 1:xyzSize(3)
            if ~zMat(i, j, k)
                zMat(i, j, k) = z0;
                velocityMat(i, j, k) = v0;
            end
        end
    end
end

%% Verify that it is normal grid point data, if in case, each element must be equal in xTimes, yTimes
xTimes = zeros(1, xyzSize(1));
yTimes = zeros(1, xyzSize(2));
for it = 1: xyzSize(1)
    xTimes(it) = length(find( txtData(:, 4) == xMat(it, 1) ) );
end
% 
for it = 1: xyzSize(2)
    yTimes(it) = length(find( txtData(:, 5) == yMat(1, it) ) );
end

iTimes = zeros(1, xyzSize(1));
jTimes = zeros(1, xyzSize(2));
kTimes = zeros(1, xyzSize(3));
for it = 1: xyzSize(1)
    iTimes(it) = length(find( txtData(:, 1) == it ) );
end
%
for it = 1: xyzSize(2)
    jTimes(it) = length(find( txtData(:, 2) == it ) );
end
% 
for it = 1: xyzSize(3)
    kTimes(it) = length(find( txtData(:, 3) == it ) );
end


%
%
%  conversion between different velocity units
% 1 ft = 0.3048m;  1 us = 1e-6 s;
% 1 us/ft = 1 us/0.3048 m = 1/0.3048 us/m;
% => 1 ft/us = 0.3048 m/us = 304.8* 1000 m/s;
% => v us/ft = v* 1/304800 s/m;
% => velocity = 304800 / v  m/s;




end










