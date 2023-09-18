
%
%
%
close all;
% clear
clc
%  DEBUG ! ! !
dbstop if error;
format short
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
% test function AIC
displaytimelog('testing function ratiostalta ... ');
%
% filename = getfilenamelist;
% filename = {'..\..\testdata\strainMat61.mat'};
filename = {'..\..\testdata\strainFilterMat17.mat'}; 
strainMat = importdata(filename{1, 1});
% strainMat = strainMat(1:end-3, :);
% 
[idxT0, thresholdArray01, thresholdArray02, flag0] = siftingfunc(strainMat, 4.3);
strainMat = strainMat(idxT, :);
% 
% 
%% -----------------------------------------------------------------------------------------------------
[numSensor, numTime] = size(strainMat);
samplingInterval = 0.064;   %  sampling interval, unit: ms
sampling = 500/(samplingInterval);
% 
lenSta = 100;   lenLta = 3200; 
% lenSta = 320;   lenLta = 6400; 
% 
% funcstalta = @staltaloop;  
funcstalta = @staltaloop1; 
% funcstalta = @staltaloop2; 
 threshold = 3.1;
%  
position = (1:numSensor)';
time = (1:numTime)* samplingInterval;
%% -----------------------------------------------------------------------------------------------------
% 
[meanTime, ratioMat, validSensor] = ratiostalta(strainMat, sampling, lenSta, lenLta, funcstalta, threshold);
% % 
ax1 = axes(figure);  hold(ax1, 'on');
plot3D(ax1, ratioMat);
title(ax1, 'ratioMat: sta-lta ratio matrix.  ');


%     picflag = figure('name','sta lta ratio');
    for j = 1:numSensor
         figure('name','sta lta ratio');
        subplot(2, 1, 1);
        plot(strainMat(j, :));
        ylabel('strain');
        title(['sta = ', num2str(lenSta), ', lta = ', num2str(lenLta), ' ratio of the ', num2str(j),'th sensor.']);
        subplot(2, 1, 2);
        plot(ratioMat(j, :));
        ylabel('sta-lta ratio');
    end













