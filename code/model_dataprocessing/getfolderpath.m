%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to get folder path dir.
%% -----------------------------------------------------------------------------------------------------
function targetFolder = getfolderpath(folderName, folderString)
% -----------------------------------------------------------------------------------------------------
% Select the file path ... 
% INPUT:
% folderName: a string, default folder path.  
% OUTPUT: 
% targetFolder: a string, selected folder path.  
% 
nowTime = showtimenow;
nowPath = pwd; 
tmpPath = [nowPath, filesep, 'seismic', nowTime];
% tmp = [pwd, filesep, folderName];
if nargin
    tmpPath = folderName;
    pathName = fileparts(folderName);
    if isempty(pathName), tmpPath =  [nowPath, filesep, folderName];   end
    if  exist(tmpPath, 'dir'),  tmpPath = [tmpPath, '_', nowTime];  end
end
warning off % 消除警告
mkdir(tmpPath);
%
defaultDir = tmpPath;  % pwd
% targetFolder = defaultDir;
targetFolder = nowPath;
% -----------------------------------------------------------------------------------------------------
fS = '选择要打开的文件夹';
if nargin == 2
    fS = folderString;
end

dirName = uigetdir(defaultDir, fS);

if ~strcmp(dirName, defaultDir), rmdir(defaultDir); end
if ~ dirName
    hr4 = errordlg(' 请重新选择文件夹！', '无效文件夹');
    pause(3);
    if ishghandle(hr4 ), close(hr4);   end
    return;
end
targetFolder = dirName;


