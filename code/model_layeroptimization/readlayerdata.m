%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to read the layer data and save it as a matrix file
% and select a reference original point
%% -----------------------------------------------------------------------------------------------------
function layerData = readlayerdata(readFilename, saveFileName, pathSave)
% -----------------------------------------------------------------------------------------------------
% this code is used to read the layer data and save it into layerData 
% read layer data and save as txt file, called after [saveFileName, '.txt'] .
% INPUT:
% readFileName: the file name of the data to read
% savefileName: the file name of the data to save
% pathSave: The path where the layer data save 
%% -----------------------------------------------------------------------------------------------------
% some default parameters.
if nargin < 3, pathSave = pwd;  end
if nargin < 2, saveFileName =  ['layer', showtimenow, '.txt'];  end
% -----------------------------------------------------------------------------------------------------
if isempty(readFilename)
    %     msg = {'func: readbindata', ' -- �ļ��б�Ϊ�գ�������ѡ���ȡ�ļ�·��'};
    %     hr = warndlg(msg, '��ȡ�ļ��쳣');
    msg = {'func: readlayerdata ', ' -- the filename list is empty��please re-select the read file path. '};
    hr = warndlg(msg, 'Read file exception !');
    layerData = [];
    pause(3);     if isfield(hr, 'h'), close(hr); end
    return;
end
if iscell(readFilename),     readFilename = readFilename{1, 1};   end
%
% -----------------------------------------------------------------------------------------------------
fidRead=fopen(readFilename, 'r');                               % �򿪶�ȡ�ļ�   

info = [pathSave, filesep, saveFileName];
fidSave=fopen(info, 'wb');                % ����Ҫ�����ļ�
while ~feof(fidRead)                                      % �ж��Ƿ�Ϊ�ļ�ĩβ               
    tline=fgetl(fidRead);                                 % ���ļ�����   
       if length(str2num(tline)) > 2      % �ж���ֵ�����Ƿ���������2
       fprintf(fidSave, '%s\n\n', tline);                  % ����������У��Ѵ�������д���ļ�MKMATLAB.txt
%        continue                                         % ����Ƿ����ּ�����һ��ѭ��
    end
end
% -----------------------------------------------------------------------------------------------------
fclose(fidSave);
layerData = importdata(info);      % �����ɵ��ļ����빤���ռ䣬������ΪlayerData��ʵ����������ʾ���� 
if nargin < 3,   delete(info);   end
% 
% 
% 
end








