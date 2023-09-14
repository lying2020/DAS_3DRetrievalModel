%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% This code is used to read data of sensor position, receive time, strain signal
% from CSV data folder
%  [strainMat, position, time, flag] = readcsvdata(DasVar, filenameList)
%% -----------------------------------------------------------------------------------------------------
function  varargout = readcsvdata(DasVar, filenameList)
% -----------------------------------------------------------------------------------------------------
% function [strainMat, position, time, flag] = readcsvdata(DasVar, filenameList)
%
% INPUT:
% filenameList: List of filenames under the path pathLoadDas
% DasVar: structural variables of das data.
% 
% OUTPUT: 
% strainMat:nsensor*nmeasure matrix, nsensor sensors, and n measure
% position: 1*nsensor matrix, position of nsensor sensors
% time: 1*nmeasure matrix, nmeasure measures(sampling data)
% 
%% -----------------------------------------------------------------------------------------------------
varargout = cell(1, 3);
% SENSOR: the number of sensor of micro-seismic receive
% MEASURE: the number of sensor received signals about per 0.5 second.
% SENSOR = 1016;     MEASURE =7812;
SENSOR = DasVar.sensor;
MEASURE = DasVar.measure;
% % SENSOR = 3;   MEASURE = 6;
%
%  The line number of the position, time, mico strain data
%  POSITION = 9;    TIME= 12;     MICO_STRAIN = 15;   % default value
POSITION = DasVar.position;
TIME = DasVar.time;
MICO_STRAIN = DasVar.micoStrain;
%
% SENSOR_NUMBER: read SENSOR_NUMBER sensors.
% SENSOR_INTERVAL: pick up sensor at a distance with SENSOR_INTERVAL.
% SENSOR_BEGIN: reading das data from the SENSOR_BEGIN th sensor.
% SENSOR_NUMBER = SENSOR;   SENSOR_INTERVAL = 1;  SENSOR_BEGIN = 1;
SENSOR_NUMBER = DasVar.sensorNumber;
SENSOR_INTERVAL = DasVar.sensorInterval;
SENSOR_BEGIN = DasVar.sensorBegin;
%
% MEASURE_INTERVAL: pick up signal at a distance with MEASURE_INTERVAL
% MEASURE_INTERVAL = 1;   % default value
MEASURE_INTERVAL = DasVar.measureInterval;
%
%
%% -----------------------------------------------------------------------------------------------------  
% Filter out different suffix files
idx = [];
for ifile = 1: length(filenameList)
    [~, ~, ext] = fileparts(filenameList{ifile});
    if ~any(contains({'.csv'}, ext)), idx = [idx, ifile];   end
end
if idx, warning('readcsvdata: the wrong type was selected !');   end
filenameList(idx) = [];
% 
% -----------------------------------------------------------------------------------------------------
%
tic
if isempty(filenameList)
    msg = {'func: readcsvdata', ' -- 文件列表为空，请重新选择读取文件路径'};
    hr = warndlg(msg, '读取文件异常');
    pause(5);
    if isfield(hr, 'h'), close(hr); end
    return;
end
%% -----------------------------------------------------------------------------------------------------
sm = [3 6];
temp = zeros(1, 2);
temp(1) = csvread( filenameList{1}, sm(1), 0,  [sm(1) 0  sm(1) 0] );
temp(2) = csvread( filenameList{1}, sm(2), 0,  [sm(2) 0 sm(2) 0] );
% 
if isempty(temp)
    msg = {'func: readcsvdata ', ' -- *.das file format error, please re-select the read file path. '};
    hr = warndlg(msg, 'Read file exception !');
    [ varargout{1}, varargout{2}, varargout{3}] = deal([]);
    pause(5);     if isfield(hr, 'h'), close(hr); end
    return;
end

if temp(1) ~= DasVar.sensor
    SENSOR = temp(1);
      warning('function readcsvdata: the default value for total number of sensors is wrong !');
%     disp(['DasVar.sensor  = ', num2str(DasVar.sensor), ', SENSOR = ', num2str(SENSOR)]);
end

if temp(2) ~= DasVar.measure
    MEASURE = temp(2);
      warning('function readcsvdata: the default value for the sample rate is wrong !');
%     disp(['DasVar.measure  = ', num2str(DasVar.measure), ', MEASURE = ', num2str(MEASURE)]);
end
%
%% -----------------------------------------------------------------------------------------------------
% funtiong csvread, read all pisition binary das data.
% read position of sensor we need,  is equal to the number of target sensor
% --------------------------------------------------------------------------
if (SENSOR_NUMBER-1)*SENSOR_INTERVAL + SENSOR_BEGIN > SENSOR
    disp('  Sensor index out of range, Reset to default value of DasVar ! ! !');
    SENSOR_NUMBER = SENSOR;
    SENSOR_BEGIN = 1;    SENSOR_INTERVAL = 1;
end
%% 
% the number of upload sensor,
nSensor = SENSOR_NUMBER;
position = zeros(nSensor, 1);
nSensorArray = (1:nSensor)* SENSOR_INTERVAL - SENSOR_INTERVAL + SENSOR_BEGIN;

% funtiong csvread reads data frome index [0]. 
% this is the first csv_file's name
% filename= strcat(pathLoadDas, filesep, filenameList{1});
 filename = filenameList{1};
 nLength = length(filenameList);
sensor = min(SENSOR - 1, nSensorArray(1, end));    % POSITION = 9, SENSOR = 1017
temp = csvread( filename, POSITION, 0,  [POSITION 0  POSITION  sensor] );
position(:) = temp(1, nSensorArray);
varargout{1, 2} = position;
%  info_position = 'position';     save([pathSaveDas, info_position], 'position');
%% -----------------------------------------------------------------------------------------------------
% read all time-point of signal we picked up
measure = MEASURE - 1;   %   TIME = 12;   MEASURE = 7812;  nLength = 124;
nMeasure = floor(MEASURE/MEASURE_INTERVAL);
time = zeros(1, nLength* nMeasure);
timeBegin = 0;    
timeInterval = 1000/(2*MEASURE);   %   unit: ms
% 
nMeasureArray = (1:nMeasure) * MEASURE_INTERVAL;
for iLength = 1:nLength
    %     filename= strcat(pathLoadDas, filesep, filenameList{iLength});
    filename = filenameList{iLength};
    temp = csvread(filename, TIME, 0, [TIME 0  TIME measure]);
    time(1, (1 + (iLength - 1)* nMeasure):(iLength* nMeasure)) = temp(1, nMeasureArray) + timeBegin;
      if temp(1, 1)<0.1,  timeBegin = time(1, iLength* nMeasure);  end  %  + timeInterval;   end
end
varargout{1, 3} = time;
%  info_time = 'time';    save([pathSaveDas, info_time] , 'time');
% tt = toc;
% info = ['# the cost of reading all time-point is: ', num2str(tt), ' s.' ];
% disp(info);
%% -----------------------------------------------------------------------------------------------------
% read strain-data of lst(1:124)*.csv files, and save into strain
strainMat = zeros(nSensor,  nLength* nMeasure);
micoStrain = sensor + MICO_STRAIN;
% micoStrain = SENSOR - 1 + MICO_STRAIN = 1016 + 15 = 1031; measure =7811;
% 
% parpool('local', 4)
% spmd
% hr1 = waitbar(0.01, 'reading seismic data in csv format ......', 'Name', 'read data'); % Show progress bar
% hr1 = msgbox({'Please wait...', 'reading seismic data in csv format ......'}, 'running'); % , 'Position', [0.8 0.5 0.2 0.1]);
for jLength =1:nLength
    %     % Update waitbar and message
    %     if ishghandle(hr1)
    %         waitbar(jLength/nLength, hr1, sprintf('%s %4.2f %s', 'reading seismic data in csv format  ......  ', 100* jLength/nLength, '%  '))
    %     end
    %     filename= strcat(pathLoadDas, filesep, filenameList{jLength});
    filename = filenameList{jLength};
    temp =  csvread(filename, MICO_STRAIN, 0, [MICO_STRAIN 0 micoStrain measure]);
    strainMat(1:nSensor, (1 + (jLength - 1)* nMeasure):(jLength* nMeasure)) = temp(nSensorArray, nMeasureArray);
    %     % Count the time cost on each read
    %         tt1 = toc;    info1 = ['# the cost of reading the ',int2str(jLength) ,'th strain data file is: ' ,num2str( tt1), ' s;' ];
    %         disp(info1);
end
% if ishghandle(hr1), close(hr1);  end
varargout{1, 1} = strainMat;

% delete(gcp('nocreate'))
if nargout > 3
    flag = toc;
    varargout{1, 4} = flag;
    info = ['# the cost of reading ', int2str(nSensor), ' strain csv data is: ', num2str(flag), ' s.' ];
    disp(info);
end

end




