%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to merge continuous/close time file into a file.
%% -----------------------------------------------------------------------------------------------------
function [filenameListSet, fileBeginTime, idxSequence] = mergefile(filenameList, timeInterval, tNum0)
% -----------------------------------------------------------------------------------------------------
% Merge continuous/close time file into a file.
% INPUT:
% filenameList: 1*num cell, a list of filename. each cell contains a filename
% timeInterval: scale, maximum time interval for different filename time in the same cell of filenameListSet.
% tNum0: the maximum number of das files contained in a signal segment. tNum = 3 | 4| 5;
% 
% OUTPUT:
% filenameListSet: idxLen* 1 cell, each cell may contains one or many more cells.
% each cell of filenameListSet contains no more than floor(timeInterval/50 + 1) filenames.
% fileBeginTime: idxLen*1, each cell contains a string represents a time point, to represents the start time of a continuous time file
% idxSequence: filename index sequence.
%
% ----------------------------------------------------------------------------------------------------
% ex:
% filenameList = cell(8, 1);
% filenameList{1} = 'N:\Learning_DATA\20201103\das20201103190058964.das';
% timeInterval = 600;
% ... ...
% length(idxSequence) = 4;
% idxSequence = {[1 2], [3 4 5], [6], [7 8]};
% filenameListSet = {filenameList([1 2]), filenameList([3 4 5]), ... ...};
% fileBeginTime{1} = '190058964';
%
%% -----------------------------------------------------------------------------------------------------
% some default parameters.
if nargin < 2, timeInterval = 600;    end     %  unit: ms
%
% timeBase = [24 60 60 1000];
%  hour  minute second microsecond
micro = [ 86400000 3600000 60000 1000 ];   % unit: ms
num = length(filenameList);
%
% -----------------------------------------------------------------------------------------------------
% caculate timestampe of each filename ...
timestamp = zeros(num, 1);
fileTimeList = cell(num, 1);
for ifile = 1: num
    % [FILEPATH, NAME, EXT] = fileparts(FILE)    %  returns the path, file name, and file name extension for the specified FILE.
    [~, name, ~] = fileparts(filenameList{ifile});
    nameLen = length(name);
    fileTimeList{ifile} = name((nameLen - 8) : nameLen);
    % ex: fileTimeList{1} = '190058964';  % time base: [hhmmssxxx];         length = 9;
    ts = name((nameLen - 10) : nameLen);
    % ex: ts{1} = '03190058964';                % time base: [ddhhmmssxxx];     length = 11;
    timestamp(ifile) = str2double(ts(1:2))*micro(1) + str2double(ts(3:4))*micro(2) + ...
        str2double(ts(5:6))*micro(3) + str2double(ts(7:8))*micro(4) + str2double(ts(9:11));
end
% 
%% -----------------------------------------------------------------------------------------------------
% timeInterval = 1200;  % unit: ms.
idxTmp = 1; count = 1;
idxSequence = [];
% 
 tNum = floor(timeInterval/200); 
if nargin > 2,  tNum = tNum0 -1;  end
for i = 1: (num - 1)
    % If the two file names are in continuous time or the number of files is no more than floor(timeInterval/50 + 1).
    if (abs(timestamp(i+1) - timestamp(i)) < timeInterval) && (idxTmp + tNum > i)
        if (i+1) == num,  idxSequence{count, 1} = idxTmp : (i+1); end
        continue;
    else
        idxSequence{count, 1} = idxTmp : i;
        count = count + 1;
        % If the consecutive filename time is longer than floor(timeInterval/50) files, overlap 2 filename time records
        if (idxTmp + tNum <= i) && (abs(timestamp(i+1) - timestamp(i)) < timeInterval)
            idxTmp = idxTmp + tNum;
        else   %
            idxTmp = i + 1;
        end
        if (i+1) == num,  idxSequence{count, 1} = idxTmp : (i+1); end
    end
end
if num == 1,   idxSequence{1, 1} = 1;   end
% 
%% -----------------------------------------------------------------------------------------------------
idxLen = length(idxSequence);
% 
[filenameListSet, fileBeginTime] = deal(cell(idxLen, 1));
for j = 1: idxLen
    idxArray = idxSequence{j};
    filenameListSet{j, 1} = filenameList(idxArray);
    fileBeginTime{j, 1} = fileTimeList{idxArray(1)};
end












