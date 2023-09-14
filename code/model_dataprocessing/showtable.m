%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2019-09-24: Complete
% 2020-05-24: Modify the description and comments
% 2020-11-06: debug. 
%  this function is used to display the data in the user interface table
%% -----------------------------------------------------------------------------------------------------
function showtable(uiT, tabArray, varName)
% -----------------------------------------------------------------------------------------------------
% INPUT: 
% uiT: the name of uitable
% tabArray: data sent into uitable
% varName: a string parameter, includes 'strain', 'position', 'source', 'window'.
%
% varName = { strainMat, position, time, source, window};
% strainMat:  (nsensor+1) * (nmeasure), nsensor sensor points, nmeasure measure points, nmeasure time point
% position: 3* nsensor, nsensor sensor position points, x, y, z coordinate
% source: 4* nwindow, time, x, y, z 4 dimension, nwindow events.
% window: nwindow* nsensor, nwindow events, nsensor sensor position points.
%
%% -----------------------------------------------------------------------------------------------------
% h=uitable('data',[1,2,3;4,5,6],'position',[100,100,300,100], 'columnname',{'姓名','学号','成绩'},'rowname',{'01','02'})
if ~ishandle(uiT),  uiT = uitable(uifigure);  end
%
format short;
if isempty(tabArray),   return;    end
uiT.Data = tabArray;
[tabRow, tabColumn] = size(tabArray);
columnWide = 120;
% Converts the variable name of a variable to a string
strTabArray = sprintf('%s', inputname(2));

if nargin > 2,   strTabArray = varName;   end
% -----------------------------------------------------------------------------------------------------
% Store the data in a table and display it in one of the App's tabs.
if  contains(strTabArray, 'strain')
    % strainMat:  (nsensor+1) * (nmeasure), nsensor sensor points, nmeasure measure points, nmeasure time point
    rowName = cell(1, tabRow);
    rowName(1) = {'time /ms'};
    tmpLen = tabRow - 1;
    posiName = positionname(tmpLen);
    rowName(2:end) = posiName;
    %
    columnName ='numbered';
    
elseif  contains(strTabArray, 'position')
    % position: 3* nsensor, nsensor sensor position points, x, y, z coordinate
    columnName = {'x /m',  'y /m',  'z /m'};
    %
    posiName = positionname(tabRow);
    rowName = posiName;
    
elseif  contains(strTabArray, 'time')
    % time: 1* nmeasure
    rowName = {'time  /ms'};
    %
    columnName = 'numbered';
    
elseif  contains(strTabArray, 'source')
    % source: 4* nwindow, x, y, z, time,  4 dimension, nwindow events.
    columnName = {'x /m',  'y /m',  'z /m',  'residual', 'underground'};
    columnWide = 90;
%     rowName ='numbered';
     posiName = positionname(tabRow);
    rowName = posiName;
elseif  contains(strTabArray, 'window')
    % window:  nsensor * nwindow, nwindow events, nsensor sensor position points.
    posiName = positionname(tabRow);
    rowName =  posiName;
    %
    tiName = timename( tabColumn);
    columnName = tiName;
    
else
    hr5 = errordlg(' 表格填充数据变量名异常！', '无效数据');
    rowName = 'numbered';
    %
    columnName = 'numbered';
    pause(4);
    if ishghandle(hr5 ), close(hr5);  end
    %  return;
end
%
% uit.RowName = 'numbered';
% uit.ColumnName ='numbered';
uiT.RowName = rowName;
uiT.ColumnName = columnName;
%
%% -----------------------------------------------------------------------------------------------------
% Set uitable property parameters
cw = ones(tabColumn, 1);
cw1 = mat2cell(cw* columnWide,  cw);
uiT.ColumnWidth = cw1';
% uit.ColumnWidth = {'auto',75,'auto','auto','auto',100};

% uit.Position = [15 25 565 200];
uiT.BackgroundColor = [1 1 .9; .9 .95 1];
% uit.BackgroundColor = [1 1 .9; .9 .95 1;1 .5 .5];
% uit.RowStriping = 'on';

% uit.ColumnSortable = true;
uiT.ColumnEditable = true;
% uit.ColumnEditable = [false false true true true true];
% uit.ColumnName = {'Gender','Age','Authorized'};
% uit.ColumnEditable = true;
%
% 
end
% 
% 
% 
% 
%% -----------------------------------------------------------------------------------------------------
function pn = positionname(tmpLen)
% return a size 1* tmpLen position name cell
% tmpLen = max(tabRow, tabColumn);
%   tmpLen = tabRow - 1;
scale= floor(log10(tmpLen) + 1);
tmpStr = sprintf(['posi %0', num2str(scale),'d'], 1:tmpLen);
tmpStr = reshape(tmpStr, scale + 5, tmpLen);
tmpStr = tmpStr';
posiName = cellstr(tmpStr);
pn = posiName';
end
% 
% 
% 
% 
%% -----------------------------------------------------------------------------------------------------
function tn = timename(tmpLen)
% return a size 1* tmpLen time name cell
% tmpLen =  tabColumn;
scale1= floor(log10(tmpLen) + 1);
tmpStr = sprintf(['tw%0', num2str(scale1),'d /ms'], 1:tmpLen);
tmpStr = reshape(tmpStr, scale1 + 6, tmpLen);
tmpStr = tmpStr';
tiName = cellstr(tmpStr);
tn = tiName';
end
% 
% 
% 
% 
% 
% 
