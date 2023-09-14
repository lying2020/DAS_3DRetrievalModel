%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% % Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to copy the target file to the specified folder
%% -----------------------------------------------------------------------------------------------------
function  status = copyobjectfile(filenameList, targetFolder)
% INPUT:
% filenameList: num* 1 cell, a list of destination filenames to copy
% folder: a string, target folder to move
% 
% OUTPUT:
% status: if success, output 1, else output 0.
%% -----------------------------------------------------------------------------------------------------
% set default parameters. 
if nargin < 2
    nowtime = showtimenow;
    folderName = 'validsignal';
    targetFolder =  [pwd, filesep, folderName, nowtime];
    mkdir(targetFolder);
end
%
if isa(filenameList, 'char')
    tmpFilename{1, 1} = filenameList;
    filenameList = tmpFilename;
end
num = length(filenameList);
for ifile = 1: num
    status = copyfile(filenameList{ifile, 1}, targetFolder);
    
end


%
%
%





