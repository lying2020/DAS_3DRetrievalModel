%
%
%% ------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to read the layer data and save it as a matrix file
function layerData = readlayerdata(readFileName, saveFileName, pathSave)
% read layer data and save as txt file, called after [saveFileName, '.txt'] .
% INPUT:
% readFileName: the file name of the data to read
% savefileName: the file name of the data to save
%% ----------------------------------------------------------------------
if nargin < 3, pathSave = pwd;  end
if nargin < 2, saveFileName =  ['layer', showtimenow, '.txt'];  end
fidRead=fopen(readFileName);                               % 打开读取文件   

info = [pathSave, filesep, saveFileName];
fidSave=fopen(info, 'wb');                % 创建要保存文件
while ~feof(fidRead)                                      % 判断是否为文件末尾               
    tline=fgetl(fidRead);                                 % 从文件读行   
       if length(str2num(tline)) > 2      % 判断数值个数是否连续大于2
       fprintf(fidSave, '%s\n\n', tline);                  % 如果是数字行，把此行数据写入文件MKMATLAB.txt
%        continue                                         % 如果是非数字继续下一次循环
    end
end
fclose(fidSave);
layerData=importdata(info);      % 将生成的文件导入工作空间，变量名为layerData，实际上它不显示出来 
if nargin < 3,   delete(info);   end
