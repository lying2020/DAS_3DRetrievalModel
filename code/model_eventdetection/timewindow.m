%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-07-14: sta-lta and AIC method
% 2020-10-29: Modify the description and comments
% This code is used to process  mico_strain data, get sta-lta ratio
%  [timeWindow, ratioMat, timeFlag] = time_window(strainMat, sampling, lenSta, lenLta, func_sta_lta, threshold)
%% -----------------------------------------------------------------------------------------------------
function [timeWindow, ratioMat, validSensor, idxArray, meanTime, timeFlag] = timewindow(strainMat, sampling, lenSta, lenLta, funcstalta, threshold)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% strainMat: strain data, numSensor* nmeasure  matrix.
%  sampling: sampling point length
% lenSta: short time window length
% lenLta: long time window lentgh
% funcstalta: sta-lta recursion function
% threshold: the threshold of sta-lta ratio  for seismic events
% pathSave: store path, save ratioMat to the path pathSave.
%
% OUTPUT:
% timeWindow: numSensor* n matrix.
% ratioMat: sta-lta ratio matrix.
% meanTimeArrival: mean arrival time of sta-lta method
% picflag: decide whether to output the image
% timeflag: whether to output the calculation time
%
%% -----------------------------------------------------------------------------------------------------
if nargin < 5,  threshold = 4; end
if nargin < 4, funcstalta = @staltaloop; end
if nargin < 3, lenSta = 200; lenLta = 4000; end
if length(strainMat) < 2
    warning('plot3D: NO OUTPUT !!! ');
    [timeWindow, ratioMat, validSensor, idxArray, meanTime, timeFlag] = deal([]);
    return;
end
%
% -----------------------------------------------------------------------------------------------------
tic;  timeFlag = 0;
%
timeWindow = [];
%
[meanTime, ratioMat, validSensor, idxArray] = ratiostalta(strainMat, sampling, lenSta, lenLta, funcstalta, threshold);
%
%% -----------------------------------------------------------------------------------------------------
% the strainMat matrix is extended forward and backward ...
% lenExtendForward: the length of the extension forward
lenExtFor = 1.0*lenLta;
% lenExtendBackward: % the length of the extension fbackward
lenExtBack = 3*lenSta;
%
[lenPosition0, lenTime0] = size(strainMat);
%
%% -----------------------------------------------------------------------------------------------------
%  signalextending:
extMat1= signalextending(strainMat, lenExtFor);
extMat2 = signalextending(strainMat, lenExtBack);
%
strainMatExt = [extMat1 strainMat extMat2];
%
%% -----------------------------------------------------------------------------------------------------
%
[~, lenTime] = size(strainMatExt);
meanTime = meanTime + lenExtFor;
%
% meanTime = repmat(mean(meanTime), lenPosition, 1);
if ~isempty(meanTime)
    %     displaytimelog(['meanTime = ', int2str(meanTime)]);
    %     timeWindow = zeros(lenPosition, length(meanTime));
    timeWindow = zeros(size(meanTime));
    for j = 1:size(meanTime, 2)
        startPoint = max(1, meanTime(:, j) -lenExtFor);
        endPoint = min((meanTime(:, j) +lenExtBack), lenTime);
        partStrain = zeros(lenPosition0, lenExtBack + lenExtFor + 1);
        for iposi = 1:lenPosition0
            timeArray = startPoint(iposi): endPoint(iposi);
            partStrain(iposi, :) = strainMatExt(iposi, timeArray);
        end
        tw = AIC(partStrain);
        tw = tw + startPoint - 1;
        %          analysis_AIC(partStrain(end-2:end, :), 1:size(partStrain, 2), ones(3, 1)*lenExtFor);
        %% -----------------------------------------------------------------------------------------------------
        %             analysis_AIC(strainMatExt(end-9:end, :), 1:lenTime, tw(end-9:end));
        %     [~, ~, ~] = analysis_AIC(strainMatExt, 1:lenTime, tw);
        %         analysis_AIC(strainMatExt(end-9:end, :), 1:lenTime, meanTime(end-9:end));
        %% -----------------------------------------------------------------------------------------------------
        timeWindow(:, j) = min(max(tw - lenLta + 1, 1), lenTime0);
    end
    %
end
%
if length(timeWindow) > 4
    [~, ~, idxArray] = clusteringfunc(timeWindow);
end
tfg = toc;
timeFlag = tfg + timeFlag;
if nargout > 4
    info = ['# the cost of time_window function is: ', num2str(timeFlag), ' s.' ];
    displaytimelog(info);
end

end  % function  time_window
%
% some code ...
%% -----------------------------------------------------------------------------------------------------
%
%  if ishghandle(hr2 ), close(hr2);  end
% % h=waitbar(0,'Getting the time window ...', 'Position', [0.5 0.5 0.2 0.1]); % , 'CreateCancelBtn','delete_h(h)');
% % waitbar(j/length(meanTime), h,[num2str(j/length(meanTime)),'% ', '...Getting the time window ......']); %
% % close(h);
% % hr1 = msgbox({'Please wait...', 'Getting the sta-lta ratio......'}, 'running'); % , 'Position', [0.8 0.5 0.2 0.1]);
%

%  if ishghandle(hr1 ), close(hr1);  end
% hr2 = msgbox({'Please wait...', 'Getting the time window......'}, 'running'); % , 'Position', [0.8 0.5 0.2 0.1]);
% [lenPosition, lenTime] = size(strainMat);

