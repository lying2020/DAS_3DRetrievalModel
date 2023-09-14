%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to obtain the location coordinates of the underground sensors
%% -----------------------------------------------------------------------------------------------------
function [undergroundCoord, overgroundCoord, Posi, Pz] = getsensorcoord(well0, position, pathSave)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% well0: num* (numDim+1) matrix,  3D coordinate points of well.
% position: num* 1 matrix, the relative position of the sensor on the cable
%
% lastPoint: a scale, the distance from the last sensor to the bottom of the well.   unit: m
% numSensor: 1*2, number of sensor overground and underground.
% baseCoord: 1* numDim array, base coord. Generally choose the coordinates of the well head as the base coordinates
%
% OUTPUT:
% undergroundCoord: the coordinates of the underground das sensor.
% overgroundCoord: the coordinates of the overground das sensor.
% Posi: the coordinates of the electric sensor.
% Pz: the coordinates of the iron 100kg.
%% -----------------------------------------------------------------------------------------------------
%
%% space dimension.
numDim = 3;
%% number of sensor over and underground.
numSensor = [78, 139];
%% distance from the last sensor to the bottom of the well.
lastPoint = 32.0;   % unit: m
%
%% surface z-coord of sensor overground.
Z0 = well0(1, 1) + well0(1, 4) - 0.2;

%% 电子检波器的坐标。
Posi = zeros(7, numDim);
Posi(:, 3) =  Z0;
Posi(:, [1 2]) = [-41.8, 39.8; 7.5, 47.6; 56.9, 55.4; 50.6, 4.5; 43.2, -34.2; -7.1, -42.4; -56.4, -50.7];
%                                1             2                3                4               5                 6                   7

%% 铁块的坐标
Pz = [-7.8, -29.0, Z0];

% -----------------------------------------------------------------------------------------------------
sensorBegin = 7;
if length(position) == 218
    numSensor =  [79, 139];
    sensorBegin = 8;
end
%
%% Location of overground sensors.
overgroundCoord = zeros(numSensor(1), numDim);
overgroundCoord(:, 3) = Z0;
%
overgroundCoord(1:sensorBegin, :) = repmat(Posi(1, :), sensorBegin, 1);
overgroundCoord(1:2, :) = repmat(Posi(1, :), 2, 1) + [0, -5, 0; 0, -10, 0];
lw = [20, 18, 20];
for i = 1:3
    overgroundCoord(sensorBegin:(sensorBegin + lw(i)), 1) = linspace(Posi(2*i -1, 1), Posi(2*i +1, 1), lw(i) + 1);
    overgroundCoord(sensorBegin:(sensorBegin + lw(i)), 2) = linspace(Posi(2*i -1, 2), Posi(2*i +1, 2), lw(i) + 1);
    sensorBegin = sensorBegin + lw(i);
end
overgroundCoord(sensorBegin:end, :) = repmat(Posi(7, :), numSensor(1) - sensorBegin + 1, 1);
overgroundCoord(end-2:end, :) = repmat(Posi(7, :), 3, 1) + [0, 5, 0; 0, 10, 0; 0, 15, 0];
% overgroundCoord(sensorBegin:(sensorBegin + lw(1)), 1) = linspace(Posi(1, 1), Posi(3, 1), lw(1) + 1);
% overgroundCoord(sensorBegin:(sensorBegin + lw(1)), 2) = linspace(Posi(1, 2), Posi(3, 2), lw(1) + 1);
% sensorBegin = sensorBegin + lw(1);
% overgroundCoord(sensorBegin:(sensorBegin + lw(2)), 1) = linspace(Posi(3, 1), Posi(5, 1), lw(2) + 1);
% overgroundCoord(sensorBegin:(sensorBegin + lw(2)), 1) = linspace(Posi(3, 2), Posi(5, 2), lw(2) + 1);
% sensorBegin = sensorBegin + lw(2);
% overgroundCoord(sensorBegin:(sensorBegin + lw(3)), 1) = linspace(Posi(5, 1), Posi(7, 1), lw(3) + 1);
% overgroundCoord(sensorBegin:(sensorBegin + lw(3)), 1) = linspace(Posi(5, 2), Posi(7, 2), lw(3) + 1);
%
%% caculate sensor position underground.
undergroundCoord = zeros(numSensor(2), numDim);
posi = position(end)  - flip(position) + lastPoint;
posi = well0(end, 1) - posi;
%
for icoord = 1: numSensor(2)
    undergroundCoord(numSensor(2) - icoord + 1, :) = getcoord(well0, posi(icoord));
end
%
% 计算井深
% diffWell = well0(1:(end-1), :) - well0(2:end, :);
% tmp1 = sqrt( sum( diffWell.^2, 2) );
%  wellDepth = sum(tmp1);
%% save sensor coordinates into folder geologicaldata.
if nargin > 2
    sensorCoordSet = [overgroundCoord; undergroundCoord];
    currentpath = mfilename('fullpath');
    [pathname] = fileparts(currentpath);
    if isfolder(pathSave), pathname = pathSave;  end
    pathname = [pathname, filesep, '..', filesep, '..', filesep, 'geologicaldata'];
    savedata(sensorCoordSet, pathname, ['sensorCoordSet', num2str(length(position))], '.csv');
end
%
end
%
%
%% -----------------------------------------------------------------------------------------------------
function coord = getcoord(well, m0)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% well: num* (numDim+1) matrix,  3D coordinate points of well.
% z0: a scale.
%
% OUTPUT:
% coord:
% -----------------------------------------------------------------------------------------------------
idx1 = find(well(:, 1) >= m0, 1, 'first');
idx2 = find(well(:, 1) <= m0, 1, 'last');
if idx1 == idx2, coord = well(idx1, [2:4]);  return;   end
% -----------------------------------------------------------------------------------------------------
ratio = (m0 - well(idx2, 1)) / (well(idx1, 1) - well(idx2, 1));
%
coord = well(idx2, 2: 4)*(1 - ratio) + well(idx1, 2:4)*ratio;
%
end
%
%
%
%





