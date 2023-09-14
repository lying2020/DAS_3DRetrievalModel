% 
% 
% 
% 
% 
% close all
%%  -----------------------------------------------------------
%  DEBUG ! ! !
dbstop if error;  % load './data/Gdpyear.mat'
format long

fileNameTime = '134625156';
timeBegin = time(1);  %  140000.0156250000;

 timeArrival = arrivaltimetable(fileNameTime, timeBegin, wd, 'ms', 'char');
 
 
 %% 
 