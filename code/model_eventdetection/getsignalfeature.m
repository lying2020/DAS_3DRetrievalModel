%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to calculate the maximum amplitude and corresponding time of a signal
%% -----------------------------------------------------------------------------------------------------
function [ampSource,  ampMaxTime] = getsignalfeature(strainMat)
% -----------------------------------------------------------------------------------------------------
% INPUT:  
% strainMat: numSensor* m, a sensor tries to contain only one target signal, m is the number of sample 
% time: the time corresponding to data collection
% OUTPUT
% ampSource: numSensor* 2, amplitude range of source signal
% sourceTimePoint: numSensor* 1, time point corresponding to maximum amplitude value 
%% -----------------------------------------------------------------------------------------------------

% num = size(strainMat, 1);

% ampSource = zeros(num, 2);
% [ampMax, ampMin, sourceTimePoint] = deal(zeros(num, 1));

[ampMax, idxMax] = max(strainMat, [], 2);
[ampMin, idxMin] = min(strainMat, [], 2);
%
ampSource =roundn( [ampMin, ampMax], -5);
%
% ampMaxTime = zeros(num, 1);
% ampSourceNormal = ampSource ./ max(abs( ampSource(:) ) );
[~, ampMaxTime] = max(abs(strainMat), [], 2);
% for i  =1: num  
%     ampMaxTime(i, 1) = [time(1, max(idxMax(i), idxMin(i)) ) ];  
% end
% 
% 
% 




