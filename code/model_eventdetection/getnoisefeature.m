%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to calculate noise's amplitude and corresponding time of a signal
%% -----------------------------------------------------------------------------------------------------
function [ampNoise] = getnoisefeature(strainMat, window)
% -----------------------------------------------------------------------------------------------------
% INPUT:  
% strainMat: numSensor* m, a sensor tries to contain only one signal
% window: numSensor* 1, the time corresponding to the signal acquisition(ʰȡ, pick up)
% OUTPUT
% ampNoise: numSensor*1, the average amplitude of source signal
%% -----------------------------------------------------------------------------------------------------
% 
num = size(strainMat, 1);
ampNoise = zeros(num, 1);
for i  =1: num
    ampNoise(i, 1) = roundn(mean( abs( strainMat(i, 1:window(i, 1)) ) ), -5);
end

% ampNoiseNormal = ampNoise ./ max(abs( strainMat(:) ) );








