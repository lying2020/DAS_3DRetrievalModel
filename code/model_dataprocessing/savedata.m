%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-08-24: Readjust code
% This code is used to save sourceposition, sourcetime, sensorposition, arrivalwindow, strain signal in *** file format
% -----------------------------------------------------------------------------------------------------
% function pathSaveDas= savebindata(resultMat, pathSaveDas, varName, postfixName, storageType)
% function pathSaveDas= savematdata(resultMat, pathSaveDas,  varName, postfixName)
% function pathSaveDas= savematdata(resultMat, pathSaveDas,  postfixName)
% function pathSaveDas= savematdata(resultMat, varName,  postfixName)
%% -----------------------------------------------------------------------------------------------------
function [pathSaveDas, filename] = savedata(resultMat, varargin)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% resultMat: m*n matrix, the data matrix to save.
% varargin = {pathSaveDas,  varName, postfixName, storageType};
% pathSaveDas: the path to save all result data
%
% varName: Save variable name, a string name
%varName = 'strainMat' | 'window' | 'sourceCoord' | 'sourceTime'.
% 
% postfixName: File save postfix format
% postfixName = '.bin'  |  '.mat'  |  '.csv' | '.txt' ;
% 
% storageType: The type of data store a file is stored in (the format of the saved data)
% storageType =  'double'  |  'single'  | 'float';
%
% OUTPUT:
% pathSaveDas: the path to save all result data
%
% -----------------------------------------------------------------------------------------------------
% ex for resultMat:
% strainMat: (nsensor+1)* nmeasure matrix. strain and sampling time data
% strainTime: 1* nmeasure matrix, nmeasure measures(sampling data)
% sensorSeq: nsensor* 1 matrix.
% sensorCoord: nsensor*3 matrix.
% window: nsensor* nwindows matrix.
% sourceCoord: nwindows* 3 matrix.
% sourceTime: nwindows* 1 matrix.
%
%% -----------------------------------------------------------------------------------------------------
% showtimenow is a function that displays a string at the current time
nowtime = showtimenow;
pathSaveDas = ['.', filesep, 'microseismic', nowtime];
% mkdir(pathSaveDas);
% delete [pathSaveDas, filesep, '*.bin'];
% 
varName = sprintf('%s', inputname(1)); % string of variable 1
varName = [varName, showtimenow];
postfixName = '.txt';
storageType = 'single';
% varNameSet = {'strain', 'strainMat', 'window', 'windows', 'position', 'posi', 'time', 'source', 'sr', 'ti'};
storageTypeSet = {'double', 'single', 'float'};
postfixNameSet = {'.bin', '.mat', '.xlsx', '.txt', '.csv'};
%% -----------------------------------------------------------------------------------------------------
% Different input parameter combinations are classified and assigned
if nargin > 1
    if  exist(varargin{1}, 'dir')
        pathSaveDas = varargin{1};
    elseif any(contains(postfixNameSet, varargin{1}))
        postfixName = varargin{1};
    elseif any(contains(storageTypeSet, varargin{1}))
        storageType = varargin{1};
    else
        varName = varargin{1};
    end
end
%
if nargin > 2
    if any(contains(postfixNameSet, varargin{2}))
        postfixName = varargin{2};
        if  ~exist(varargin{1}, 'dir'),   varName = varargin{1};  end
    elseif any(contains(storageTypeSet, varargin{2}))
        storageType = varargin{2};
        if any(contains(storageTypeSet, varargin{1})),  varName = varargin{1};  end
    else
        varName = varargin{2};
    end
end
%
if nargin > 3
    if any(contains(postfixNameSet, varargin{3}))
        postfixName = varargin{3};
        varName = varargin{2};
        pathSaveDas = varargin{1};
    else
        storageType = varargin{3};
        if  ~exist(varargin{1}, 'dir')
            varName = varargin{1};  postfixName = varargin{2};
        elseif  any(contains(storageTypeSet, varargin{2}))
            varName = varargin{2};
        end
    end
end
%  
if nargin > 4, storageType = varargin{4}; end
% if any(contains(storageTypeSet, varargin{end})),  storageType = varargin{end};  end
if ~ exist(pathSaveDas, 'dir'),  mkdir(pathSaveDas);  end
%% -----------------------------------------------------------------------------------------------------
% nowtime = showtimenow;
% filename = [ varName, nowtime, postfixName];
if ~contains(postfixName, '.'),  postfixName = ['.', postfixName];  end
filename = [ varName, postfixName];
% #ex: fileName = time20200812155603.bin;
info = [pathSaveDas, filesep, filename];
% -----------------------------------------------------------------------------------------------------
switch postfixName
    case '.csv'
        writematrix(resultMat, info) ;
    case '.txt'
        writematrix(resultMat, info); % , 'Delimiter', '\t') ;
    case '.bin'
        % write to binary file
        writebindata(resultMat, info, storageType)
    case '.mat'
        % write to mat file
        % strMat=mat2str(resultMat);
        % eval( [resultName, ' = ', strMat]);
        save(info, 'resultMat', '-v7.3');
    case '.xlsx'
        % write to xls file
        % dataCell = mat2cell(data, ones(rowResultMat, 1), ones(columnResultMat, 1));
        % ½«dataÇÐ¸î³ÉrowResultMat* columnResultMatµÄcell¾ØÕó
        xlswrite(info, resultMat);       % status = ... ;
end

% fileID = fopen(filename, 'wb');
% fprintf(fileID, '%8.5f %8.5f %8.5f \n', sensorCoordSet);
% fclose all   % fclose(fileID);

end
%
%
%
%% -----------------------------------------------------------------------------------------------------
function writebindata(resultMat, info, storageType)
% -----------------------------------------------------------------------------------------------------
% write to binary file
% INPUT:
% resultMat: the data matrix to save.
% info: save the path and name
% storageType: the format of the saved data
%
% -----------------------------------------------------------------------------------------------------
[rowResultMat, columnResultMat] = size(resultMat);
fid=fopen(info, 'wb');
% # the cost of write 300 strains data is: 7.3094 s.
fwrite(fid, [rowResultMat, columnResultMat] , storageType);
count = fwrite(fid, resultMat, storageType );  % single, float
%
if(count ~= rowResultMat * columnResultMat)
    msg = {info,  ' -- FAILED TO SAVE RESULTS ...'};
    hr4 = warndlg(msg, 'WRITE EXCEPTION');
    pause(5);
    if ishghandle(hr4 ), close(hr4);   end
end
fclose(fid);


end

%% -----------------------------------------------------------------------------------------------------






