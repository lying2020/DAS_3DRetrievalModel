% 
% 
% 
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-11-19: debug and comment. 
% this code is used to analyze the impact on strain data after filtering
%% -----------------------------------------------------------------------------------------------------
function [strainFilterMat, timeLagFilter, timeFlag] = analysis_filtering(strainMat, time, maxlag, pathSave)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% strainMat: lenPosition*lenTime matrix, the original signal, microstrain value
% time: discrete time, the time unit is ms
% maxLag: specified as an integer scalar. If you specify maxlag, the returned cross-correlation sequence ranges from -maxlag to maxlag.
%  If you do not specify maxlag, the lag range equals 2N ¨C 1, where N is the greater of the lengths of x and y.
%
% OUTPUT:
% strainFilterMat: lenPosition*lenTime matrix, the strain data after filtering
% corrFilter: 1*lenPosition array, the cross correlation between before and after filtering.
% timeLagFilter: 1*lenPosition array, the time delay after filtering.  
% 
% filtering strain data with buterword filter.
% 
%% -----------------------------------------------------------------------------------------------------
% some default parameters set.
if length(strainMat) < 2, warning('plot3D: NO OUTPUT !!! ');  return;  end
[lenPosition, lenTime] = size(strainMat);
if nargin < 3, maxlag = lenTime;   end
if nargin<2, time = (1:lenTime)*0.064;   end
%% -----------------------------------------------------------------------------------------------------
posiArray = 1:lenPosition;
% 
[~, ~,~] = fftfunc(strainMat, time, 'strain');

[strainFilterMat, ~] = filteringfunc(strainMat, time);

[~, ~,~] = fftfunc(strainMat, time, 'filtered strain');

% The time delay estimation cross-correlation algorithms before and after filtering are compared
[corrFilter, timeLagFilter] = deal(zeros(1, lenPosition)); 
%   
for i = 1:lenPosition
    [tmp, timeLagFilter(i)] = crosscorrelation(strainMat(i,:),strainFilterMat(i,:), maxlag);
    corrFilter(i) = max(tmp);
end

if nargin > 3
    save([ pathSave, 'strainFilterMat',int2str(lenPosition)] , 'strainFilterMat');
    save([ pathSave, 'corrFilter',int2str(lenPosition)] , 'corrFilter');
    save([ pathSave, 'timeLagFilter',int2str(lenPosition)] , 'timeLagFilter');
end


%% -----------------------------------------------------------------------------------------------------
% Estimation of cross-correlation time-lag between before and after filtering.  
co = mean(corrFilter)*ones(1, lenPosition);
figure;
subplot(211);
plot(posiArray, corrFilter, posiArray, co);
xlabel('position/m');  ylabel('correlation');
legend('corr', 'mean corr');
title('Correlation graph of time-strain data before and after filtering ');

la =ones(1, length(posiArray)) * mean(timeLagFilter);
subplot(212);
plot(posiArray, timeLagFilter, posiArray, la);
xlabel('position/m');  ylabel('timeLag/ms');
legend('timeLag', 'mean timeLag');

% -----------------------------------------------------------------------------------------------------
% 
if nargout > 2
    timeFlag = toc;
    info = ['# the cost of  filtering analysis of different strain data is: ', num2str(timeFlag), ' s.' ];
    disp(info);
end




