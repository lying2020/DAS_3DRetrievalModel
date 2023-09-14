
%
%
%
%
% close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format short
addpath(genpath('../include'));
%% -----------------------------------------------------------------------------------------------------
filenameList = getfilenamelist;
[filenameListSet, fileTime] = mergefile(filenameList);


% writetable(T,'myTable.txt')

