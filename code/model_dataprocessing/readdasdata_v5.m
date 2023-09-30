
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% File by Lingmei Ma @ Sentek Instrument LLC

% Oct 31, 2019

% Edited by Dyon Buitenkamp @ Sentek Instrument LLC

% Jun 25, 2021

% March 9, 2023

% Edited by Logan Theis

% Feb 1, 2023

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Results = readdasdata_v5(FilePath, FileName)

% This file reads the log file (.das files) of DASnova system

% Output:

%   Result: a structure containing the following fields:

%       SensorNumber: number of sensor in the sensing fiber

%       MeaNumber: number of measurements in the file

%       Position: sensor positions, in meter

%       Time: time of the measurements, in second

%       Strain: signal in micro strain, SensorNumber x Meanumber matrix

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filenameList = [];
mpath = [];
mfiles = [];

if nargin  == 1
    filenameList = FilePath;

    if(~iscell(filenameList))
        filenameList = {filenameList};
    end

else
    if nargin == 2
        mpath = FilePath;
        mfiles = FileName;
    else
        [mfiles, mpath] = uigetfile('*.das','MultiSelect','on');
    end

    if(~iscell(mfiles))
        mfiles = {mfiles};
    end
    
    filenameList = fullfile(mpath, mfiles);
    
end

[SensorNum, MeaNum, TmpMeaNum] = deal(0);

[SampInt, StrainRate, TrigPos, DecFact] = deal(0);

[SensorCoordinate, SensorIndex, Position, Time, Strain] = deal([]);

Results = struct('filenameList', {filenameList}, 'SensorNum', SensorNum, 'MeaNum', MeaNum, ...
    'SampInt', SampInt, 'StrainRate', StrainRate, 'TrigPos', TrigPos, 'DecFact', DecFact, ...
    'SensorCoordinate', SensorCoordinate, 'SensorIndex', SensorIndex', 'Position', Position, 'Time', Time', 'Strain', Strain);

tmpfilenameList = {};
cnt = 1;
filenameListLen = length(filenameList);
for i = 1: filenameListLen
    
    fid = fopen(filenameList{i});
    
    if fid==-1
        
        disp('Failed to open file, please check file path and file name.');
        
        return;
        
    end
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    
    tmpSensorNum = fread(fid, 1, 'float');
    
    tmpMeaNum = fread(fid, 1, 'float');
    
    tmpSampInt = fread(fid, 1, 'float');
    
    tmpStrainRate = fread(fid, 1, 'float');
    
    tmpTrigPos = fread(fid, 1, 'float');
    
    tmpDecFact = fread(fid, 1, 'float');
    
    try
        tmpPosition = fread(fid, tmpSensorNum, 'float');
        time = fread(fid, tmpMeaNum, 'float');
        strain = fread(fid, tmpMeaNum*tmpSensorNum, 'float');
        
    catch ME
        disp(['file: ', filenameList{i}, '. Failed to read das file, please check file format and das version, 4 / 5?']);
        continue;
    end
    
    fclose(fid);
    
    if length(strain) ~= tmpMeaNum* tmpSensorNum
        disp(['file: ', filenameList{i}, '. length(strain) = ', num2str(length(strain)), ', MeaNum*SensorNum = ', num2str(tmpMeaNum*tmpSensorNum), ...
            '. Failed to read strain, please check file format and das version, 4 / 5?']);
        continue;
    end
    
    SensorNum = tmpSensorNum;
    
    MeaNum = tmpMeaNum;
    
    SampInt = tmpSampInt;
    
    StrainRate = tmpStrainRate;
    
    TrigPos = tmpTrigPos;
    
    DecFact = tmpDecFact;
    
    SensorCoordinate = zeros(tmpSensorNum, 3);
    
    SensorIndex = 1 : tmpSensorNum;
    
    Position = tmpPosition;
    
    Time = [Time; time];
    
    strain = reshape(strain, SensorNum, MeaNum);
    
    Strain = [Strain, strain];
    
    TmpMeaNum = TmpMeaNum + MeaNum;
    tmpfilenameList{cnt} = filenameList{i};
    cnt = cnt + 1;
end

filenameList = {tmpfilenameList};
MeaNum = TmpMeaNum;
Results = struct('filenameList', filenameList, 'SensorNum', SensorNum, 'MeaNum', MeaNum, ...
    'SampInt', SampInt, 'StrainRate', StrainRate, 'TrigPos', TrigPos, 'DecFact', DecFact, ...
    'SensorCoordinate', SensorCoordinate, 'SensorIndex', SensorIndex', 'Position', Position, 'Time', Time', 'Strain', Strain);


end
