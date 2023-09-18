% clc
% clear       
close all
%% ------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2019-09-24: Complete
% 2020-07-14: Modify the description and comments
%% -------------------------------------------------------------------------
tic
% if isempty(gcp('nocreate'))
%     parpool('local', 4);
%   end


DasVar = dasdataformat;

% DasVar.sensor = 1016;
% DasVar.threshold = 3.4;
% DasVar.file = 2;
DasVar.fileNumber = 61;
 DasVar.fileBegin = 1;
 DasVar.sensorNumber = 20;
DasVar.sensorInterval = 1;
 DasVar.measureInterval = 2;
timeFlag = 0;
% % pathLoadDas = 'N:\Learning_DATA\19_Autumn\SeismicWave\DAS data';
pathLoadDas = 'DAS data';
pathSaveDas = 'seismic20200805';
mkdir(pathSaveDas);
delete([pathSaveDas, filesep, '*.bin']);
% pathLoadDas = 'das';
% displaytimelog('reading seismic data ... ');
% [strainMat, position, time, timeFlag(1)] = readopendata(DasVar ,pathLoadDas, '*.csv');
% ss = strainMat ;
savebindata(strainMat, pathSaveDas);
savebindata(position, pathSaveDas);
savebindata(time, pathSaveDas);
strArray = {'plot3',   'surf' , 'mesh',  'waterfall'};   
% 
% for n =1:2  % [1 2 6]
%     str =strArray{n};
%     plot3D( strainMat, position, time, str);
% end
% # the cost of reading 300 strain csv data is: 305.3761 s.
[lenPosition, lenTime] = size(strainMat);
% displaytimelog('filtering seismic data ... ');
%  [strainFilterMat, timeFlag(8)] = filteringfunc(strainMat, position, time);

% timeTemp = (time - time(1)) / 1000;
% ninterval = 1;    begin = 1;
% npositionArray = begin: ninterval : DasVar.sensorNumber;
% %
% % ntimeArray = 1:length(time);
% tB = 7812*1 + 1;
% tE = 7812*10;
% ntimeArray = floor(tB: 1 :tE);
% % qq = plot2D(strainMat(npositionArray, ntimeArray), position(npositionArray), time(ntimeArray));
threshold =DasVar.threshold;
% threshold = 2.1;
lenSta = 20; lenLta = 400;
stalta = @staltaloop1;
% [ratioMat, realIdx, tfg] = ratiostalta(strainMat, lenSta, lenLta, funcstalta, threshold);
%
% displaytimelog('geting the time window ... ');

% [window, ratioMat, timeFlag(14)] = timewindow( strainFilterMat(npositionArray, ntimeArray), lenSta, lenLta, stalta, threshold);
sampling = floor(DasVar.measure / DasVar.measureInterval);
[window, ratioMat, timeFlag(14)] = timewindow(strainMat, sampling, lenSta, lenLta, stalta, threshold);
 
% picType = 'surf';
% plot3D(ratioMat, position, time, picType); %, pathSaveDas);
 
%  plot2D(, );
plot2D(ax1, strainMat(1:3, :), position(1:3), time, window(1:3, :), window(1:3, :));
w1 = window;
plot2D(ax1, strainMat(1:3, :), position(1:3), time, [], w1(1:3, :));

% tmp  =  rand(2, lenPosition)*position(1, 1);
% posi = [position; tmp];  % 3*n
posi = posi3D(position);
% posi = [zeros(2, lenPosition); position];
        source = sourcelocation( posi, window/1000); 
        savebindata(window, pathSaveDas);
        savebindata(source,  pathSaveDas);
% qq1 = plot2D(strainMat(npositionArray, ntimeArray), position(npositionArray), time(ntimeArray), window);
% plot2D(strainMat, position, time, window);
% ax1 = axes(uifigure); 
% sourceplot3D(ax1, position, source);
% pathReadDas = 'seismic20200805';
% ax3 = axes(uifigure);
% uiT = uitable(uifigure);
%  showtable(uiT, source)
% [position1, source1, window1,  strainMat1, time1,  flag] =  readbindata(pathReadDas); %, storageFormat);
 % %% --------------------------------------------------------------
%% test function AIC
% % displaytimelog('testing function AIC ... ');
% meanTime = [8949 102379];
% nm =2;
% start = max(1, meanTime(nm) -lenLta + 1);
% final = min((meanTime(nm) +2 * lenSta), lenTime);
% partStrain = strainMat(:, start : final);
% %  [tw, timeFlag(9)] = AIC(strainMat);
%  [tw, tfg] = AIC(partStrain);
% % [tw1, tfg1] = AIC1(partStrain);
% sum(tw - tw1)
%% % --------------------------------------------------------------

% figure;
% subplot(2, 1, 1);
% plot(1:length(ntimeArray), ratioMat(1, :));
% subplot(2, 1, 2);
% plot(1:length(ntimeArray), ratioMat(3, :));
% figure;
% plot(1:length(ntimeArray), ratioMat(8, :));
% [maxCorr3, time3, timeFlag(7)] = crosscorrelation(strainMat(1, :), strainMat(2,:));

%  sourcelocation( position, timeArrival, velocity)

%tt = toc;
%  info = ['# the cost of reading all data is: ', num2str(tt), ' s.' ];
%  displaytimelog(info);
% delete(gcp('nocreate')) % stop parallel computing
% ax2 = axes(uifigure); 
% plot3D(ax2, strainMat, position, time, window);
toc
totalTime = sum(timeFlag)