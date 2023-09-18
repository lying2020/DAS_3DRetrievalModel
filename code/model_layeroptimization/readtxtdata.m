%
%
%
%% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to read the text data and save it as a matrix
% and select a reference original point
%% -----------------------------------------------------------------------------------------------------
function txtData = readtxtdata(readFilename, type)
% -----------------------------------------------------------------------------------------------------
% read the text data and save it into txtData
% INPUT:
% readFilename: 1*num string, the file name of the data to read, a string
% type: string, read data type.
%       type = 'layer' | 'fault' | 'well' | 'velocity' | sensorCoord;
% numDim =    5         5          3           7
% default read txt data
% OUTPUT:
% txtData: a n* numDim matrix
%
%% -----------------------------------------------------------------------------------------------------
txtData = [];
% some default parameters.
if nargin < 2;  type = 'txtfile';  end
% -----------------------------------------------------------------------------------------------------
if isempty(readFilename)
    %     msg = {'func: readbindata', ' -- 文件列表为空，请重新选择读取文件路径'};
    %     hr = warndlg(msg, '读取文件异常');
    msg = {'func: readtxtdata ', ' -- the filename list is empty，please re-select the read file path. '};
    hr = warndlg(msg, 'Read file exception !');
    pause(3);     if ishandle(hr), close(hr); end
    return;
end
if ~isfile(readFilename)
    displaytimelog(['The file does not exist.', ', readFilename: ', readFilename]);
    return;
end

if iscell(readFilename),     readFilename = readFilename{1, 1};   end
%
fidRead=fopen(readFilename, 'r');                      % 打开读取文件
% if fidRead < 0
%     warndlg('打开文件失败!');
%     return;
% end
% msgbox('文件读取成功！');
%% -----------------------------------------------------------------------------------------------------
% Find a row full of values and start reading from that row.
num = 0;     tmp  = -1;
while ~feof(fidRead)                                      % Determines whether it is the end of the file
    tline=fgetl(fidRead);                                   %  Read the string line from the file
    num = num + 1;
    if ~isempty( str2num(tline) )     % Determine the number of double values is more than 1
        tmp = [tmp num];
        % If two consecutive lines are floating point data, make sure they are followed by floating point data
        if (tmp(end) - tmp(end - 1) ) == 1,  break;  end     % 如果连续出现两行都是浮点数据，则确认后面都是浮点数据
    end
end
num = max(1, num - 2);
%从指定行开始读取数据
%实际上主要是textscan的使用, 查阅matlab对应的帮助文档就清楚了
frewind(fidRead);   % fseek(fidRead, 0, 'bof')   指针移到开头位置
% txtData: 1* numDim cells, data is stored in cells
txtData = textscan(fidRead, '', 'Delimiter', {',', ';', ' ', '\b', '\t'}, 'EmptyValue', 0, 'headerlines', num);
% txtData = textscan(fidRead, '', 'EmptyValue', 0, 'headerlines', num, 'MultipleDelimsAsOne', 1);
fclose(fidRead);   % close the file
numLayer = length(txtData);
%% -----------------------------------------------------------------------------------------------------
% Converts cell data to a n* numDim matrix by type
%
if contains(['layerGridModel', 'faultModel'], type)
     if length(txtData) < 5, txtData = []; return;  end
    txtData = [txtData{1}, txtData{2}, txtData{3}, txtData{4}, txtData{5}];
elseif contains('velocityModel', type)
      if length(txtData) < 7, txtData = []; return;  end
    txtData = [txtData{1}, txtData{2}, txtData{3}, txtData{4}, txtData{5}, txtData{6}, txtData{7}];
elseif contains('wellModel', type)
      if length(txtData) < 5, txtData = []; return;  end
    % ？ 第一列全为零，不知道为什么，不管第一列
    txtData = [txtData{2}, txtData{3} txtData{4} txtData{5}];
else
    tmp1 = [];
    for i = 1:numLayer
        tmp1 = [tmp1, txtData{i}];
    end
    txtData = tmp1;
end
% -----------------------------------------------------------------------------------------------------
%     displaytimelog('GOOD JOB !!!');
%
% if fclose(fidRead) == 0
%     msgbox('文件关闭成功！');
% else
%     warndlg('关闭文件失败!');
% end

end







