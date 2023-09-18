
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
displaytimelog('testing function AIC ... ');
%
% filename = getfilenamelist;
filename = {'..\..\testdata\strainMat17.mat'};
filename = {'..\..\testdata\strainMat61.mat'};
strainMat = importdata(filename{1, 1});
% strainMat = strainMat(1:end-3, :);
[idxT0, thresholdArray01, thresholdArray02, flag0] = siftingfunc(strainMat, 4.3);
strainMat = strainMat(idxT, :);
% -----------------------------------------------------------------------------------------------------
% filename1 = {'..\..\testdata\strainFilterMat17.mat'};   
% strainFilterMat = importdata(filename1);
%% -----------------------------------------------------------------------------------------------------
[numSensor, numTime] = size(strainMat);
samplingInterval = 0.064;   %  sampling interval, unit: ms
sampling = 500/(samplingInterval);
lenSta = 320;   lenLta = 6400;  funcstalta = @staltaloop;   threshold = 3.1;
%
position = (1:numSensor)';
time = (1:numTime)* samplingInterval;
%% -----------------------------------------------------------------------------------------------------
% %
%  ax1 = axes(figure);
%  plot3D(ax1, strainMat,position, time);
%  title(ax1, 'strainMat ');
%
tw0 = AIC(strainMat);
% [tw, aic0]= analysis_AIC(strainMat, time);
timeTw0 = time(tw0);
% 
[tw2, ratioMat2, validsensor2] = timewindow(strainMat, sampling, lenSta, lenLta, funcstalta, threshold);
timeTw2 = time(tw2);
% 
%% -----------------------------------------------------------------------------------------------------
% displaytimelog('filtering seismic data ... ');
 [strainMat, timeLag] = filteringfunc(strainMat, time);
 ax2 = axes(figure);
 plot3D(ax2, strainMat, position, time);
 title(ax2, 'strainMat after filtering');
% % % 
% 
[idxT1, thresholdArray11, thresholdArray12, flag1] = siftingfunc(strainMat, 4.3);

tw1 = AIC(strainMat);
% [tw, aic0]= analysis_AIC(strainMat, time);
timeTw1 = time(tw1 + timeLag);
%
[tw3, ratioMat3, validsensor3] = timewindow(strainMat, sampling, lenSta, lenLta, funcstalta, threshold);
timeTw3 = time(tw3 + timeLag);

%% -----------------------------------------------------------------------------------------------------
%
axw = axes(figure); hold(axw, 'on');
yyaxis(axw, 'left');
plot(axw, timeTw0); 
plot(axw, timeTw1); 
% 
yyaxis(axw, 'right');
plot(axw, timeTw2);
plot(axw, timeTw3);
legend(axw, 'aic tw', 'aic tw after filtering', 'timewindow tw', 'timewindow tw after filtering');
title('time window before and after filtering. ');
%     
%            
%% -----------------------------------------------------------------------------------------------------
 ax1 = axes(figure);  hold(ax1, 'on');
 plot3D(ax1, strainMat, position, time);
% % 
sm0 = numSensor*(tw0 - 1) + position;
sm1 = numSensor*(tw1 - 1) + position;
sm2 = numSensor*(tw2 - 1) + position;
sm3 = numSensor*(tw3 - 1) + position;
plot3(ax1, timeTw0, position, strainMat(sm0), 'r.', 'linewidth', 2, 'DisplayName', 'aic0');
plot3(ax1, timeTw1, position, strainMat(sm1), 'k.', 'linewidth', 2, 'DisplayName', 'aic1');
plot3(ax1, timeTw2, position, strainMat(sm2), 'r*', 'linewidth', 0.5, 'DisplayName', 'timewindow');
plot3(ax1, timeTw3, position, strainMat(sm3), 'k*', 'linewidth', 0.5, 'DisplayName', 'timewindow1');
title(ax1, 'function: analysis\_AIC. ');

%
% 
% analysis_AIC(strainMat, time);
% analysis_AIC(strainMat1, time);
%% -----------------------------------------------------------------------------------------------------






