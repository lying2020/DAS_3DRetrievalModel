dbstop if error;   
format long
addpath(genpath('../../../include'));
[fileName, pathName] = uigetfile({'*.*'; '*.txt'; '*.mat'}, ' Select the TXT-file ',  'MultiSelect', 'on');
%
if  isa(fileName, 'numeric'), return;  end
%
filenameList = fullfile(pathName, fileName);
%
if isa(filenameList, 'char')
   tmp{1, 1} = filenameList;
   filenameList = tmp;
end
Detectordata{iFile} = readlayerdata(filenameList{iFile});