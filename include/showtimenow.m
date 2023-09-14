%% ------------------------------------------------------------------
% Author: liying  
% Tel: 15682070575
% Email: lying2017@126.com 
% log:
% 2019-09-24: Complete
% 2020-05-24: Modify the description and comments
% 
%  this function is used to display different forms of string time
function nowtime = showtimenow(flag)
% show time now, we get a string time.
%   flag:              1                          2                   3                         others
% output:  'yyyy-mm-dd'    'yyyymmdd'    'yyyy_mm_dd'     'yyyymmddhhmmss'
% -------------------------------------------------------------
% nowtime =  showtimenow(1)          showtimenow(2)        showtimenow(3)
% nowtime =    '2020-09-04'                  '20200904'               '2020_09_04'
%
% nowtime =     showtimenow            showtimenow(4)
% nowtime = '20200706084240'       '20200904115504'
% 
year = datestr(now, 10);
month = datestr(now, 5);
day = datestr(now, 7);

ymd = datestr(now, 29);

hms = datestr(now, 13);
hms = hms(1, [1 2 4 5 7 8]);

if nargin >0
    switch flag
        case 1
            nowtime = ymd;  %  '2020-07-10'
        case 2
            nowtime =  [year month day]; %  '20200710'
        case 3
            nowtime = [year, '_', month, '_', day]; % '2020_07_22'
        otherwise
            nowtime = [year month day hms]; %  '20200710132516'
    end
else
    nowtime = [year month day hms];
end
