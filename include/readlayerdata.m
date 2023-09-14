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
fidRead=fopen(readFileName);                               % �򿪶�ȡ�ļ�   

info = [pathSave, filesep, saveFileName];
fidSave=fopen(info, 'wb');                % ����Ҫ�����ļ�
while ~feof(fidRead)                                      % �ж��Ƿ�Ϊ�ļ�ĩβ               
    tline=fgetl(fidRead);                                 % ���ļ�����   
       if length(str2num(tline)) > 2      % �ж���ֵ�����Ƿ���������2
       fprintf(fidSave, '%s\n\n', tline);                  % ����������У��Ѵ�������д���ļ�MKMATLAB.txt
%        continue                                         % ����Ƿ����ּ�����һ��ѭ��
    end
end
fclose(fidSave);
layerData=importdata(info);      % �����ɵ��ļ����빤���ռ䣬������ΪlayerData��ʵ����������ʾ���� 
if nargin < 3,   delete(info);   end
