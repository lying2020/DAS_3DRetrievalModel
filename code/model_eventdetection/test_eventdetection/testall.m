% clc
% clear
close all
%% ------------------------------------------------------------------
% Author: liying  
% Tel: 15682070575
% Email: lying2017@126.com 
% log: 
% 2019-09-24: Complete
% 2020-05-24: Modify the descriptio  n and comments
%% -------------------------------------------------------------------------
% tic 
% profile on
% testparallel
DasVar = das_data_format;
% DasVar.numSensor = 300;
% DasVar.intervalSensor = 2;
DasVar.sensor = 1017;
DasVar.numSensor = 300;
timeFlag = 0;
pathLoadDas = 'N:\Learning_DATA\19_Autumn\SeismicWave\DAS data';
% [strainMat0, position0, time0, timeFlag(1)] = read_das_data(DasVar); % , pathLoadDas);

% [strainMat, position, time, timeFlag(2)] = read_csv_data(DasVar, pathLoadDas);
% # the cost of reading 300 strain csv data is: 305.3761 s.

pathSave = ['.', filesep, 'sensor', int2str(DasVar.numSensor)];
% [pathSaveDas, timeFlag(3)] = save_mat_data(strainMat, position, time);
% [pathSaveDas, state, timeFlag(4)] = write_bin_data(strainMat, position, time);
sensorArray = 1:5;
[strainMatUpload, positionUpload, timeUpload] = das_upload_data(sensorArray, pathSaveDas);
%  strain_plot_3d(strainMatUpload, positionUpload, timeUpload); %, pathSaveDas);
% strain_waterfall(strainMatUpload, positionUpload, timeUpload); %, pathSaveDas);
% %  % Position = position_plot_3d(position, pathSaveDas);
% % lenSta = 600; lenLta = 8000;  
% % sta_lta = @sta_lta_loop1;
% % [ratioMat, picflag, timeFlag(5)] = ratio_sta_lta(strainMat, lenSta, lenLta, sta_lta);
% % [ratioMat1, flag1] = temp_sta_lta(strainMat, lenSta, lenLta, pathSaveDas);
% % %  analysis_sta_lta(strainMatUpload, pathSaveDas);
% time_temp = (time - time(1)) / 1000;
% ninterval = 2;
% ntimeArray = floor(1: 1 :(7812*4.8));
% % sensorArray = 1:10;
% npositionArray = 1:ninterval:DasVar.numSensor;
% [pic0, timeFlag(6)] = strain_plot_3d(strainMat(npositionArray, ntimeArray), position(npositionArray), 1:length(ntimeArray ));% , time_temp(ntimeArray)); %, pathSaveDas);
%   
% 
% % [maxCorr, timeLag, flag] = cross_correlation(strainFilterMat(1, 1:40000), strainFilterMat(2, 1:40000));
% % [maxCorr3, time3, timeFlag(7)] = cross_correlation(strainMat(1, :), strainMat(2,:));
% % xcorrArray = cross_correlation(strainMat(1, :), strainMat(2, :));
% % [maxCorr4, time4, timeFlag(8)] = cross_correlation(strainMat(1, 1:40000), strainMat(2, 1:40000));
% % [corrMat, lagMat, timeFlag(11)] = analysis_cross_corr(strainMat(npositionArray, ntimeArray)); % , pathSaveDas);
% % [pic4, timeFlag(12)] = strain_plot_3d(corrMat, position(npositionArray), time_temp(ntimeArray)); %, pathSaveDas);
% 
% %  source_location( position, timeArrival, velocity)
% 
% %tt = toc;    
% %  info = ['# the cost of reading all data is: ', num2str(tt), ' s.' ]; 
% %  displaytimelog(info); 
% % delete(gcp('nocreate')) % stop parallel computing
% % profile viewer
% 
% 
% totalTime = sum(timeFlag)