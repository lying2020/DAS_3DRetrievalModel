%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% 2020-11-06: debug.
% This code is used to read data of sensor position, receive time, strainsignal
% from DAS data folder
%% -----------------------------------------------------------------------------------------------------
function  varargout = readopendata(DasFormat, pathLoadDas, postfixName)
%                               function  filenameList = readopendata(DasFormat, pathLoadDas,  postfixName)
% function  [strainMat, position, time, flag] = readopendata(DasFormat, pathLoadDas,  postfixName)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% DasFormat: structural variables of das data.
% pathLoadDas: the path to load all DAS data
% pathLoadDas = ['.', filesep, 'DAS data', filesep];  % default path
% filesep: return the file separator for current platform
%  fileformat: get a file format (csv or das)
% postfixName: '*.das'   |   '*.csv'
%
% OUTPUT:
% strainMat: nsensor*nmeasure matrix, ns ensor sensors, and n measure
% position: 1*nsensor matrix, position of nsensor sensors
% time: 1*nmeasure matrix, nmeasure measures(sampling data)
% filenameList: List of filenames under the path pathLoadDas
%% -----------------------------------------------------------------------------------------------------
% displaytimelog('Select the open file path ...');
if nargin < 2
    defaultDir = pwd;
    dirName = uigetdir(defaultDir, '选择文件打开路径');
    if ~dirName
        [ varargout{1}, varargout{2}, varargout{3}, varargout{4}] = deal([]);
        hr1 = errordlg(' 请重新选择读取文件夹！', '无效文件夹');
        pause(3);
        if ishghandle(hr1 ), close(hr1);   end
        return;
    end
    pathLoadDas = dirName;
end
%
if nargin < 3
    lst1 = dir([pathLoadDas, filesep, '*.das']);     nLength(1) = length(lst1);
    lst2 = dir([pathLoadDas, filesep, '*.csv']);     nLength(2) = length(lst2);
    [~, idx] = max(nLength);
    idxName = {'*.das', '*.csv'};
    postfixName = idxName{idx};
end
%
% -----------------------------------------------------------------------------------------------------
iStar = strfind(postfixName, '*') ;
% Get the function name handle
% fn =  ['bin', 'xls', 'mat'];
idxSeq = (iStar + 2) : (iStar+4);  % idx sequence
funcName = str2func(['read',  postfixName(idxSeq), 'data']);
%  [pathstr, name, ext] = fileparts(psotfixName);
% funcName = str2func(['read',  ext(2:end), 'data']);
%% -----------------------------------------------------------------------------------------------------
% lst: a filename list
lst = dir([pathLoadDas, filesep, postfixName]);
nLength1= length(lst);

if isempty(lst)
    msg = {'func: readopendata', ' -- 文件列表为空，请重新选择读取文件路径'};
    hr = warndlg(msg, '读取文件异常');
    [ varargout{1}, varargout{2}, varargout{3}, varargout{4}] = deal([]);
    pause(5);
    if isfield(hr, 'h'), close(hr); end
    return;
end

%% -----------------------------------------------------------------------------------------------------
% Get the filename of all target files in descending order
DasFormat.file = nLength1;
DasFormat.fileNumber = min(DasFormat.fileNumber, nLength1 );
fileArray = DasFormat.fileBegin : (DasFormat.fileNumber + DasFormat.fileBegin - 1);
%
nLength2 = length(fileArray);  % nLength2 = 124; there are 124 *das files in path 'patLoadDas'
nameCell = cell(nLength2, 1);
% lstFolder = {lst.folder}'
% lstName = {lst.name}'
%  nameCell = fullfile(lstFolder{1}, lstName{fileArray});
for j = 1:nLength2
    nameCell{j} = [lst(fileArray(j)).folder,  filesep, lst(fileArray(j)).name];
end
%
%  sort of cell array of strings in descending order
filenameList = sortfilename(nameCell);
% [selectedNum,ok]=listdlg('Liststring',  filenameList,'PromptString','请选择文件','SelectionMode','Multiple');
% filenameList = filenameList(selectedNum);
varargout{1} = filenameList;
%% -----------------------------------------------------------------------------------------------------
if nargout > 1
    [strainMat, position, time] = funcName(DasFormat, filenameList);
    %     switch  postfixName
    %         case '*.das'
    %             [strainMat, position, time, flag] = readdasdata(DasFormat, filenameList);
    %         case '*.csv'
    %             [strainMat, position, time, flag] = readcsvdata(DasFormat, filenameList);
    %     end
    varargout{1} = strainMat;
    varargout{2} = position;
    varargout{3} = time;
    varargout{4} = filenameList;
end

end





