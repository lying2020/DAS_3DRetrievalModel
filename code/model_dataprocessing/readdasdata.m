%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2019-09-24: Complete
% 2020-05-24: Modify the description and comments
% 2020-07-06: add das format read function(binary storage)
% 2020-11-04: do some bug fixes
% This code is used to read data of sensor position, receive time, strain signal
% from DAS data folder
% function [strainMat, position, time, flag] = readdasdata(DasFormat, filenameList)
%% -----------------------------------------------------------------------------------------------------
function  varargout = readdasdata(DasFormat, filenameList)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% DasFormat: 1*1 struct, a structural variables of das data.
% filenameList: num* 1 cell, a list of filenames under the path pathLoadDas
%
% OUTPUT:
% strainMat:numSensor* numMeasure matrix, numSensor sensors, and numMeasure measure
% position: numSensor* 1 matrix, position of numSensor sensors
% time: 1*numMeasure matrix, nmeasure measures(sampling data)
% flag: a flag that determines the output run time
% 
%% -----------------------------------------------------------------------------------------------------
varargout = cell(1, 3);
% -----------------------------------------------------------------------------------------------------
% STORAGEBYTES, STORAGETYPE:
% Version 2: data is storage in 4-byte single-precision floating-point Numbers
% Version 1: data is storage in 8-byte double-precision floating-point Numbers
% SKIP: skip the first two values (row 4: 1017, row 7:7812)
% Default value: STORAGEBYTES = 4;   STORAGETYPE = 'single';   SKIP = 2;    % single is 4 bytes
STORAGEBYTES = DasFormat.storageBytes;
STORAGETYPE = DasFormat.storageType;
SKIP = DasFormat.skip;
%
% -----------------------------------------------------------------------------------------------------
% SENSOR: the number of sensor of micro-seismic receive
% MEASURE: the number of sensor received signals about per 0.5 second.
% Default value: SENSOR = 1016;     MEASURE =7812;
SENSOR = DasFormat.sensor;
MEASURE = DasFormat.measure;
%
% -----------------------------------------------------------------------------------------------------
% SENSOR_NUMBER: read SENSOR_NUMBER sensors.
% SENSOR_INTERVAL: pick up sensor at a distance with SENSOR_INTERVAL.
% SENSOR_BEGIN: reading das data from the SENSOR_BEGIN th sensor.
% Default value: SENSOR_NUMBER = SENSOR;   SENSOR_INTERVAL = 1;  SENSOR_BEGIN = 1;
SENSOR_NUMBER = DasFormat.sensorNumber;
SENSOR_INTERVAL = DasFormat.sensorInterval;
SENSOR_BEGIN = DasFormat.sensorBegin;
%
% -----------------------------------------------------------------------------------------------------
% MEASURE_INTERVAL: pick up signal at a distance with MEASURE_INTERVAL
% Default value: MEASURE_INTERVAL = 1;   MEASURE_BEGIN = 1;
MEASURE_INTERVAL = DasFormat.measureInterval;
MEASURE_BEGIN = DasFormat.measureBegin;
%
%% -----------------------------------------------------------------------------------------------------
% Filter out different suffix files
idx = [];
for ifile = 1: length(filenameList)
    [~, ~, ext] = fileparts(filenameList{ifile});
    if ~(any(contains({'.dsr', '.das'}, ext)) && exist(filenameList{ifile}, 'file')), idx = [idx, ifile];   end
end
if idx, warning('function readdasdata: the wrong type was selected !');   end
filenameList(idx) = [];
tic 
%% -----------------------------------------------------------------------------------------------------
% if isempty(filenameList),  warning(': why is there no file name ?');   return;  end
if isempty(filenameList)
    %     msg = {'func: readdasdata', ' -- 文件列表为空，请重新选择读取文件路径'};
    %     hr = warndlg(msg, '读取文件异常');
    msg = {'func: readdasdata ', ' -- the filename list is empty，please re-select the read file path. '};
    hr = warndlg(msg, 'Read file exception !');
    [ varargout{1}, varargout{2}, varargout{3}] = deal([]);
    pause(3);     if ishandle(hr), close(hr); end
    return;
end
filenameList = sortfilename(filenameList);
%% -----------------------------------------------------------------------------------------------------
% import filename, open the file, and check the  value  of  the initialized variable
% nLength = length(filenameList);
filename = filenameList{1};      %  this is the first das_file's name
fileID = fopen(filename);
temp = fread(fileID, [1  2], STORAGETYPE);
%
flag0 = tempisempty(temp, 140);
if flag0,  [ varargout{1}, varargout{2}, varargout{3}] = deal([]); return;  end

% -----------------------------------------------------------------------------------------------------
if temp(1) ~= DasFormat.sensor
    SENSOR = temp(1);        
    warning('function readdasdata: the default value for total number of sensors is wrong !');
    %     disp(['DasFormat.sensor  = ', num2str(DasFormat.sensor), ', SENSOR = ', num2str(SENSOR)]);
end
%
% -----------------------------------------------------------------------------------------------------
if temp(2) ~= DasFormat.measure
    MEASURE = temp(2);
    warning('function readdasdata: the default value for the sample rate is wrong !');
    %     disp(['DasFormat.measure  = ', num2str(DasFormat.measure), ', MEASURE = ', num2str(MEASURE)]);
end
%
% -----------------------------------------------------------------------------------------------------
if (SENSOR_NUMBER - 1)*SENSOR_INTERVAL + SENSOR_BEGIN > SENSOR
    %     disp('(SENSOR_NUMBER-1)*SENSOR_INTERVAL + SENSOR_BEGIN > SENSOR !');
    warning('function readdasdata: sensor index is out of range, Reset to default value of DasFormat !');
    SENSOR_NUMBER = SENSOR;
    SENSOR_BEGIN = 1;          SENSOR_INTERVAL = 1;
end
% 
% -----------------------------------------------------------------------------------------------------
if MEASURE_INTERVAL + MEASURE_BEGIN > MEASURE
    %     disp('MEASURE_INTERVAL + MEASURE_BEGIN > MEASURE !');
    warning('function readdasdata: measure index is out of range, Reset to default value of DasFormat !');
    MEASURE_BEGIN = 1;       MEASURE_INTERVAL = 1;
end
if SENSOR == 218
    SENSOR_BEGIN = 2; SENSOR_NUMBER = SENSOR - 1; 
    warning off; warning('An unstable number of sensors !!!');
end
%% -----------------------------------------------------------------------------------------------------
% funtiong fread, read all pisition binary das data.
% read position of sensor we need,  is equal to the number of target sensor
%
nSensor = SENSOR_NUMBER;
position = zeros(nSensor, 1);
nSensorArray = (1:nSensor)* SENSOR_INTERVAL - SENSOR_INTERVAL + SENSOR_BEGIN;
%
% fileID = fopen(filename);
% offset = SKIP* STORAGEBYTES;   %  % SKIP =2, STORAGEBYTES = 4;
% origin = 'bof';
% % Move the file location indicator to the position data
% fseek(fileID, offset, origin);   % STORAGETYPE = 'single', % single is 4 bytes
temp = fread(fileID, [1 SENSOR], STORAGETYPE);
%% check temp is empty.
flag0 = tempisempty(temp, 136);
if flag0,  [ varargout{1}, varargout{2}, varargout{3}] = deal([]); return;  end
%
position(:) = temp(1, nSensorArray);
varargout{1, 2} = position;
% positionIndicator = ftell(fileID); % To determine the current file location indicator
fclose(fileID);
%% -----------------------------------------------------------------------------------------------------
% funtiong fread, read all time and strain binary das data
nLength = length(filenameList);
nMeasure = floor(MEASURE/MEASURE_INTERVAL);
time = zeros(1, nLength* nMeasure);
timeBegin = 0;
%
strainMat = zeros(nSensor,  nLength* nMeasure);
nMeasureArray = (1: nMeasure)* MEASURE_INTERVAL - MEASURE_INTERVAL + MEASURE_BEGIN;
%
offset = (SKIP + SENSOR)* STORAGEBYTES;  % SKIP = 2; STORAGEBYTES = 4;
origin = 'bof'; % The initial location of the file
% -----------------------------------------------------------------------------------------------------
% hr1 = waitbar(0.01, 'reading seismic data in das format ......', 'Name', 'read data'); % Show progress bar
% hr1 = msgbox({'Please wait...', 'reading seismic data in csv format ......'}, 'running'); %, 'Position', [0.8 0.5 0.2 0.1]);
% -----------------------------------------------------------------------------------------------------
for jLength = 1:nLength
    % -----------------------------------------------------------------------------------------------------
    % Update waitbar and message
    %     if ishghandle(hr1)
    %         waitbar(jLength/nLength, hr1, sprintf('%s %4.2f %s', 'reading seismic data in das format  ......  ', 100* jLength/nLength, '%  '))
    %     end
    % -----------------------------------------------------------------------------------------------------
    columnArray =  (1 + (jLength - 1)* nMeasure):(jLength* nMeasure);
    fileID = fopen(filenameList{jLength});
    % fseek: move the file location indicator to the position data
    fseek(fileID, offset, origin);   % STORAGETYPE = 'single', % single is 4 bytes
    % read time data
    temp = fread(fileID,[1 MEASURE], STORAGETYPE);
    flag0 = tempisempty(temp, 173);
    if flag0,  [ varargout{1}, varargout{2}, varargout{3}] = deal([]);  return;  end
    time(1,columnArray) = temp(1, nMeasureArray) + timeBegin;
    % -----------------------------------------------------------------------------------------------------
    if temp(1, 1)<0.1,  timeBegin = time(1, jLength* nMeasure);  end  %  + timeInterval;   end
    % -----------------------------------------------------------------------------------------------------
    % read strain data
    temp = fread(fileID,[SENSOR MEASURE], STORAGETYPE);
    % check temp is empty.  
    if tempisempty(temp, 181),  [ varargout{1}, varargout{2}, varargout{3}] = deal([]); return;  end
    if size(temp, 2) ~= MEASURE
        msg = {'选取原始信号非同一信号片段，识别传感器数目不同，导致异常！'; '传感器数目不同的原始信号： ';filenameList{jLength-1}; filenameList{jLength}};
        hr1 = errordlg(msg, '传感器数目异常');
                pause(5);
                if ishghandle(hr1 ), close(hr1);  end
                % error('显示格式错误：索引超过检波器总数 ！');
                [ varargout{1}, varargout{2}, varargout{3}] = deal([]);
                return;
    end
    strainMat(:, columnArray) = temp(nSensorArray, nMeasureArray);
    fclose(fileID);
end
%% -----------------------------------------------------------------------------------------------------
% 在后续Dasnova软件版本更新之后，这一行记得注释掉
timeInterval = MEASURE_INTERVAL*1000/(2*MEASURE);   %   unit: ms
time = (1 : (nLength* nMeasure))*timeInterval;
%% -----------------------------------------------------------------------------------------------------
varargout{1, 1} = strainMat;
varargout{1, 3} = time;
% if ishghandle(hr1), close(hr1);  end

% parpool('local', 4)
% spmd
% delete(gcp('nocreate'))
%% -----------------------------------------------------------------------------------------------------
%
flag = toc;
if nargout > 3
    varargout{1, 4} = flag;
    info = ['# the cost of reading ', int2str(nSensor), ' strain das data is: ', num2str(flag), ' s.' ];
    disp(info);
end

end



function flag = tempisempty(temp, num)
flag = false;
if isempty(temp)
    msg = {'func: readdasdata ', ' -- *.das file format error, please re-select the read filename list !', [' -- warning in line ', num2str(num), '. ']};
    hr = warndlg(msg, 'Read file exception !');
    flag = true;
    pause(3);     if ishandle(hr), close(hr); end
    return;
end
end




