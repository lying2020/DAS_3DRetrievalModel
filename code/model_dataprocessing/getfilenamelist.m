%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to get the list of file names
%% -----------------------------------------------------------------------------------------------------
function [filenameList,  pathName]= getfilenamelist(fileType, isMulti)
% -----------------------------------------------------------------------------------------------------
% Gets a list of filenames for the target file
% INPUT: 
% fileType: 1*n string, select data type
% isMulti:  'on'  |  'off', whether to choose one or more file. 
% OUTPUT: 
% filenameList: num*1 cell array.
% -----------------------------------------------------------------------------------------------------
if nargin < 2,  isMulti = 'on';   end
if nargin < 1,  fileType = '*.*';    end
%
currentpath = mfilename('fullpath');
[pathname] = fileparts(currentpath);
addpath(genpath(pathname));
            
typeArray = { '*.*'; '*.das'; '*.txt'; '*.mat'; '*.csv'; '*.bin'; '*.dsr'};
if any(contains(typeArray, fileType)),  typeArray = {fileType; '*.*'};  end
[fileName, pathName] = uigetfile(typeArray, [' Select target file -- ', fileType, ' type data. '],  'MultiSelect', isMulti);
%
% if isequal(fileName, 0)
%     displaytimelog('User selected Cancel');
%     return;
% else
%     displaytimelog(['User selected: ', fullfile(pathName, fileName)]);
% end
%
if  isa(fileName, 'numeric'), filenameList = cell(0); return;  end
% 
filenameList = fullfile(pathName, fileName);
% 
if isa(filenameList, 'char')
    tmpFilename{1, 1} = filenameList;
    filenameList = tmpFilename;
end
% 
if size(filenameList, 1) == 1, filenameList = filenameList';   end
% default ascending order.  
filenameList = sortfilename(filenameList);
% 
% 
% 
% 
end
% 
% 














