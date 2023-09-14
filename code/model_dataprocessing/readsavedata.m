%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% This function is used to read the bin file
% function [outputVar,  flag] =  readbindata(filenameList, storageFormat)
%% -----------------------------------------------------------------------------------------------------
function [matData] =  readsavedata(readFilename, postfixName, storageFormat)
% function [outputVar,  flag] =  readbindata(filenameList, storageFormat)
% INPUT:
% filenameList: List of filenames under the path pathLoadDas
% postfix: postfix = '.txt' | '.csv' | '.bin' | '.mat'.       
% storageFormat: 'single' | 'double'.
% 
% OUTPUT:
% matData: a n* numDim matrix. 
% 
%% -----------------------------------------------------------------------------------------------------
tic
if nargin < 3,    storageFormat = 'single';   end % STORAGEBYTES = 4;
if nargin < 2,  postfixName = '.csv';   end
%
if isempty(readFilename)
    %     msg = {'func: readbindata', ' -- 文件列表为空，请重新选择读取文件路径'};
    %     hr = warndlg(msg, '读取文件异常');
    msg = {'func: readsavedata ', ' -- the filename list is empty，please re-select the read file path. '};
    hr = warndlg(msg, 'Read file exception !');
    matData = [];
    pause(3);     if ishandle(hr), close(hr); end
    return;
end
%
postfixNameSet = {'.bin', '.txt', '.csv', '.mat'};  
if iscell(readFilename),     readFilename = readFilename{1, 1};   end
[~, ~, ext] = fileparts(readFilename);
if ~any(contains(postfixNameSet, ext)),  matData = [];   return;  end
% if strcmp(storageFormat, 'double'),  STORAGEBYTES = 8;    end
% 
% add path.  
currentpath = mfilename('fullpath');
[pathname] = fileparts(currentpath);
pathname = [pathname, filesep, '..', filesep, '..', filesep, 'include'];
addpath(genpath(pathname));
%% -----------------------------------------------------------------------------------------------------
seq = 1:4;
logicalArray = contains(postfixNameSet, postfixName);
enum = seq(logicalArray);
postfixName = postfixNameSet{enum};
switch postfixName
    case '.bin'
        matData = readbindata(readFilename, storageFormat);
    case '.mat'
        matData = importdata(readFilename);
    otherwise   % '.csv' | '.txt'
        matData = importdata(readFilename); 
end

% -----------------------------------------------------------------------------------------------------
% if nargout > 1
%     flag = toc;
%     info = ['# the cost of reading result data is: ', num2str(flag), ' s.' ];
%     disp(info);
% end


end



%% ----------------------------------------------------------------------------------------------------
function binData = readbindata(readFilename, storageFormat)
%从数据文件读取二维数据
fip=fopen(readFilename, 'rb');
rowCol = fread(fip, [1 2], storageFormat);  % read row and column
[ binData, num]=fread(fip, [rowCol(1)  rowCol(2)], storageFormat);
%
if(num ~=rowCol(1)* rowCol(2))
    msg = {'func: readbindata',  '  --  数据未成功读取，请重新读取数据 ！！！'};
    hr4 = errordlg(msg, '数据读取异常');
    pause(5);
    if ishghandle(hr4 ), close(hr4);   end
end
fclose(fip);

end


% offset = SKIP* STORAGEBYTES; % SKIP =2, STORAGEBYTES = 4;   % TYPE = 'single',
%  origin = 'bof';
% fseek(fip, offset, origin) sets the file position indicator offset bytes from origin in the specified file.
%{
    % offset = 0;
    % 'bof' or -1   Beginning of file
    % 'cof' or 0      Current position in file
    %  'eof' or 1  end of file
    % % Move the file location indicator to the position data
%}