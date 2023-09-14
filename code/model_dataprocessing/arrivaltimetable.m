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
function timeArrival = arrivaltimetable(fileBeginTime, timeBegin, timeWindow, timeUnit, type)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% fileBeginTime: a string. a filename named in current time. 
% fileBeginTime = 'yyyymmddhhmmss' | 'yyyymmddhhmmssxxx' | 'hhmmss' | 'hhmmssxxx';            
%       fbtLength =  [           14                                    17                              6                  9         ];
% timeWindow: m* n integer matrix.   the time span is less than an hour
% timeUnit: 's'  |  'ms'. Display Resolution of timeWindow 
% type: 'char'  |  'numeric';  0 | 1
%
% OUTPUT:
% timeArrival: m*n cell/matrix. each cell/element represents a timetable, 24 hour system time display
% if type == 'char', each cell contains a string: hh:mm:ss.xxx 
% if type == 'numeric', each element represents a numer: hhmmssxxx.  
% ex: timeArrival{1, 1} =  '16:17:40.206';
%% -----------------------------------------------------------------------------------------------------
% some default parameters.
if nargin < 5, type = 'numeric';  end
if nargin < 4, timeUnit = 'ms'; end
% -----------------------------------------------------------------------------------------------------
ymd = '';
microsecond = '000';
%  floor( log( str2double(fileBeginTime) ) / log(10) )+ 1;  % Number of digits, fileBeginTime
fntLength =length(fileBeginTime);  
%% -----------------------------------------------------------------------------------------------------
% Separate the string fileBeginTime into many small string table
% -- ymd, hour, minute, second, microsecond.     
if fntLength >= 14
    ymd = fileBeginTime(1: 8);
    hour = fileBeginTime(9:10);
    minute = fileBeginTime(11:12);
    second = fileBeginTime(13: 14);
    if fntLength > 14,    microsecond = fileBeginTime(15:17);    end   % if fntLength == 17;
else  % if fntLength >= 6;
    hour = fileBeginTime(1:2);
    minute = fileBeginTime(3:4);
    second = fileBeginTime(5:6);
    if fntLength > 6, microsecond = fileBeginTime(7:9);   end            % if fntLength == 9;
end
hour = str2double(hour);
minute = str2double(minute);
second = str2double(second);
microsecond = str2double(microsecond);
%
%% -----------------------------------------------------------------------------------------------------
% Calculate timeWindow 24 - hour system time display
if isempty(timeWindow),  timeArrival = cell(0);   return;   end
tw = timeWindow - timeBegin;
if strcmp(timeUnit, 'ms')
    microsecond = microsecond + mod(tw, 1000);  % tw is a matrix
    second = second + floor(microsecond/1000);    % microsecond is matrix
    microsecond = floor(mod(microsecond, 1000));  % second is a matrix
    tw = floor(tw/1000);
end
% 
%  Determine second hand display
second = second + mod(tw, 60);
minute = minute + floor(second / 60);
second = mod(second, 60);
tw = floor( tw/60 );
%
% Determine the minute hand display
minute = minute + mod(tw, 60);
hour = hour + floor(minute/60);
minute = mod(minute, 60);
tw = floor(tw/60);
%
% Determine the hour hand display
hour = hour + mod(tw, 24);
hour = mod(hour, 24);
%
%% -----------------------------------------------------------------------------------------------------
% display timeWindow in a 24 - hour system. 
[twRow, twCol] = size(timeWindow);
if contains(type, 'num')
    timeArrival = zeros(twRow, twCol);
    for i = 1:twRow
        for j = 1:twCol
            timeArrival(i, j) =str2double([ymd, num2str(hour(i, j)), num2str(minute(i, j)), num2str(second(i, j)), num2str(microsecond(i, j))]);
        end
    end
    return;
end
% -----------------------------------------------------------------------------------------------------
% if contains(type, 'char') 
timeArrival = cell(1, twCol);
for i = 1: twRow
    for j = 1:twCol
        timeArrival{i, j}  = [ymd,' ', num2str(hour(i, j)), ':', num2str(minute(i, j)), ':', num2str(second(i, j)), '.', num2str(microsecond(i, j))];
    end
end




