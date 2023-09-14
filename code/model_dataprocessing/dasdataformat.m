%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-10-14: Modify the description and comments
% 2020-11-06: debug. 
% datestr(clock)
% '18-Jun-2020 10:48:29'
% This code is used to :
% -- explain the DAS data format
% -- define and initialize some global variables related to the DAS data format
% -- define file path of DAS data
%% -----------------------------------------------------------------------------------------------------
function [DasFormat, LowPass, DisplayFormat] = dasdataformat
% -----------------------------------------------------------------------------------------------------
% -- explain the DAS data format
% row  detail
% -----------------------------------------------------------------------------------------------------
%  1   D:\新建文件夹\das-data11120190813155659389.csv
%  3   Number of Sensors:
%  4   1017
%  5
%  6   Number of Measurements:
%  7   7812
%  8
%  9   Poistion(m):
% 10   510.4082 ... ...   [9 0  9 1016]
% 11
% 12   Time（ms)
% 13   230985.3    [12 0 12 7811]
% 14
% 15   Mico Strain:
% 16   -0.00021 ... ...  [15  0  15   7811]
% ...  all strain data   [15  0  1031 7811]
%% -----------------------------------------------------------------------------------------------------
% ASCII --- textscan
% Binary ---  memmapfile
% -----------------------------------------------------------------------------------------------------
% -- define and initialize some global variables related to the DAS data format
% global STORAGEBYTES TYPE SKIP;
% STORAGEBYTES, TYPE:
% Version 2: data is storage in 4-byte single-precision floating-point Numbers
% Version 1: data is storage in 8-byte double-precision floating-point Numbers
% SKIP: skip the first two values (row 4: 1017, row 7:7812)
STORAGEBYTES = 4;   STORAGETYPE = 'single';   SKIP = 2;    % single is 4 bytes
%
% -----------------------------------------------------------------------------------------------------
% global SENSOR MEASURE;
% SENSOR: the number of sensor of micro-seismic receive
% MEASURE: the number of sensor received signals about per 0.5 second.
SENSOR = 217;     MEASURE =7812;
% SENSOR  = 3;   MEASURE = 6;
%
% -----------------------------------------------------------------------------------------------------
% global POSITION TIME MICO_STRAIN;
% The line number of the position,time, mico_strain data
POSITION = 9;    TIME= 12;     MICO_STRAIN = 15;   % default value
%
% -----------------------------------------------------------------------------------------------------
% global SENSOR_NUM SENSOR_INTERVAL SENSOR_BEGIN
% SENSOR_NUM: read SENSOR_NUM sensors.
% SENSOR_INTERVAL: pick up sensor at a distance with SENSOR_INTERVAL.
% SENSOR_BEGIN: reading das data from the SENSOR_BEGIN th sensor.
% initializing ----------    default value  -----------------------------
SENSOR_NUM = SENSOR;
SENSOR_INTERVAL = 1;
SENSOR_BEGIN = 1;
% we just select SENSOR_INTERVAL = 1 is ok;
% SENSOR_INTERVAL = [ 1 2 4 10 20 50 ...].
%
% -----------------------------------------------------------------------------------------------------
% global MEASURE_INTERVAL;
% MEASURE_INTERVAL: pick up signal at a distance with MEASURE_INTERVAL
MEASURE_INTERVAL = 1;   % default value
% (15624 ./ interval(i)) data points are collected per second
% MEASURE_INTERVAL = [1       2      4     12    36    62     93      124   186    252    372    434     651];
% sample_period    = [0.0625, 0.125, 0.25, 0.75, 2.25, 3.875, 5.8125, 7.75, 11.62, 15.75, 23.25, 27.125, 40.6875]
% sample_frequency = [15624， 7812,  3906, 1302, 434,  252,   168,    126,  84,    62,    42,    36      24]；
% sample_frequency：the number of signal collected per second, unit:Hz.
%
% 7812 =1* 2 * 2 * 3 * 3 * 7 * 31. 0.5 seconde is divided into 7812 parts
% why choose these number?
% Make sure we can get data at regular intervals
% and make time-strain graphic looks the same with difference time-interval and sensor-interval
%
% -----------------------------------------------------------------------------------------------------
% -- define file path of DAS data
% global PATH_LOAD_DAS; % pathSaveDas;
% pathLoadDas: the path to load all DAS data
% pathLoadDas = 'N:\Learning_DATA\19_Autumn\SeismicWave\DAS data';
PATH_LOAD_DAS = pwd;  % ['.', filesep, 'DAS data'];
% filesep: return the file separator for current platform
%
% -----------------------------------------------------------------------------------------------------
% path_SaveDas: the path to save all DAS data we load
% pathSaveDas = ['.', filesep, 'sensor', int2str(SENSOR_NUM) ,filesep];
% mkdir(pathSaveDas);
%% -----------------------------------------------------------------------------------------------------
% define structural variables of das data.
% Set the FORMAT of the DAS file ----   default value   ------------
DasFormat.position = POSITION;
DasFormat.time = TIME;
DasFormat.micoStrain = MICO_STRAIN;
%
% initializing sensor ----------------------------------------------------
DasFormat.sensor = SENSOR;
DasFormat.sensorNumber = SENSOR_NUM;
DasFormat.sensorBegin = SENSOR_BEGIN;
DasFormat.sensorInterval = SENSOR_INTERVAL;
%
% storage format instruction ----------------------------------------------
DasFormat.skip = SKIP;
DasFormat.storageBytes = STORAGEBYTES;
DasFormat.storageType = STORAGETYPE;
% sta-lta threshold
DasFormat.threshold = 3.44;
%
% Initialize the sampling parameter ---------------------------------------
DasFormat.measure = MEASURE;
DasFormat.measureInterval = MEASURE_INTERVAL;
DasFormat.measureBegin = 1;
%
% Initialize file to read parameters --------------------------------------
DasFormat.file = 124;
% DasFormat.fileNumber = floor(DasFormat.file  / 2);
DasFormat.fileNumber = 16;
DasFormat.fileBegin = 1;
%
% Initialize the file path ------------------------------------------------
DasFormat.pathLoadDas = PATH_LOAD_DAS;
%
%% -----------------------------------------------------------------------------------------------------
% DasFormat =
%   包含以下字段的 struct:
%
%                skip: 2
%            position: 9
%                time: 12
%          micoStrain: 15
%              sensor: 1017
%        sensorNumber: 300
%         sensorBegin: 1
%      sensorInterval: 1
%         storageBytes: 4
%          storageType: 'single'
%           threshold: 3.44
%             measure: 7812
%     measureInterval: 1
%                file: 124
%          fileNumber: 16
%           fileBegin: 1
%         pathLoadDas: '.\DAS data'

%% -----------------------------------------------------------------------------------------------------
%  Initialize filtering parameters ---------------------------------
LowPass.wp = 10;  % [20  20 4 ]    % wp: 通带截止频率, Passband cutoff frequency
LowPass.ws = 100; % [300 50 50]  % ws: 阻带起始频率, Stopband start frequency
LowPass.rp = 2;   % [2   5  4 ]    % rp: 通带波纹, passband ripple
LowPass.rs = 30;  % [30  45 40]   % rs: 阻带衰减, stopband attenuation
LowPass.isFiltering = true;

% LowPass =
%
%   包含以下字段的 struct:
%
%              wp: 600
%              ws: 1000
%              rp: 2
%              rs: 30
%     isFiltering: 1
%% -----------------------------------------------------------------------------------------------------
%  Set seismic wave display parameters -----------------------------
DisplayFormat = DasFormat;
%  Display format default parameters
% DisplayFormat.sensorNumber = 20;
DisplayFormat.sensorBegin = 1;
% DisplayFormat.sensorInterval = 2;
DisplayFormat.measureInterval = 1;
DisplayFormat.fileNumber = 31;
DisplayFormat.fileBegin = 1;


%% -----------------------------------------------------------------------------------------------------








