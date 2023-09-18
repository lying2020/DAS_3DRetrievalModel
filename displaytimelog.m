
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
%  this function is used to display log with a time stamp
%% -----------------------------------------------------------------------------------------------------
function displaytimelog(show_log)

    if  isa(show_log, 'char')
        disp([showtimenow(3), ' ', show_log]);
    else
        disp(['showtimenow', showtimenow(3)]);
        disp(show_log);
    end

end