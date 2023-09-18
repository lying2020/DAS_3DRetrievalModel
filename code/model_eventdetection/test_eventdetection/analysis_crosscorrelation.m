%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-07-06: modify the staltaloop recursion function
% 2020-11-16: debug and comment.
% this code is used to process micostrain data, compare the delay of two different strain signals.
%
%% -----------------------------------------------------------------------------------------------------
function [corrMat, lagMat, strainFilterMat, corrFilter, timeLagFilter] = analysis_crosscorrelation(strainMat, time, maxlag, pathSave)
% -----------------------------------------------------------------------------------------------------
% correlation analysis of different strain data
% INPUT:
% strainMat: lenPosition*lenTime matrix, the original signal, microstrain value
% time: discrete time, the time unit is ms
% maxLag: specified as an integer scalar. If you specify maxlag, the returned cross-correlation sequence ranges from -maxlag to maxlag.
%  If you do not specify maxlag, the lag range equals 2N ¨C 1, where N is the greater of the lengths of x and y.
%
% OUTPUT:
% corrMat: lenPosition*lenPosition matrix, cross correlation coeficients matrix.
% lagMat: lenPosition*lenPosition matrix, time delay matrix.
%
% strainFilterMat: the strain data after filtering
% corrFilter: 1*lenPosition array, the cross correlation between before and after filtering.
% timeLagFilter: 1*lenPosition array, the time delay after filtering.  
% 
% filtering strain data with buterword filter.
% flag: wether to print pic .
%
%% -----------------------------------------------------------------------------------------------------
% some default parameters set.
if length(strainMat) < 2, warning('plot3D: NO OUTPUT !!! ');  return;  end
[lenPosition, lenTime] = size(strainMat);
if nargin < 3, maxlag = lenTime;   end
if nargin<2, time = (1:lenTime)*0.064;   end
%% -----------------------------------------------------------------------------------------------------
%
corrMat =ones(lenPosition);
lagMat = zeros(lenPosition);
tic
%
for i = 1: lenPosition
    for j = (i+1):lenPosition
        [corrMat(i, j), lagMat(i, j)] = crosscorrelation(strainMat(i,:),strainMat(j,:), maxlag);
    end
end
corrMat = triu(corrMat) + (triu(corrMat, 1))';
lagMat = triu(lagMat) - triu(lagMat)';
%
if nargin > 3
    save([ pathSave, 'corrMat',int2str(lenPosition)] , 'corrMat');
    save([ pathSave, 'lagMat',int2str(lenPosition)] , 'lagMat');
end
%
%% -----------------------------------------------------------------------------------------------------
% Estimation of cross-correlation time-lag between different sensors.
if nargout >= 1
    figure;  %('name', 'corrMat');
    [X, Y] = meshgrid(1:lenPosition);
    plot3(X, Y, corrMat );
    title('Correlation analysis between different sensors.');
    figure; %('name', 'lagMat');
    plot3(X, Y, lagMat );
    title('Time delay estimation between different sensors.');
end
%
%% -----------------------------------------------------------------------------------------------------
% Estimation of cross-correlation time-lag between before and after filtering.
if nargout >= 3
    [strainFilterMat, ~] = filteringfunc(strainMat, time);
    posiArray = 1:lenPosition;
    % The time delay estimation cross-correlation algorithms before and after filtering are compared
    [corrFilter, timeLagFilter] = deal(zeros(1, lenPosition));
    %
    for i = 1:lenPosition
        [corrFilter(i),timeLagFilter(i)] = crosscorrelation(strainMat(i,:),strainFilterMat(i,:), maxlag);
    end
    if nargin > 3
        save([ pathSave, 'strainFilterMat',int2str(lenPosition)] , 'strainFilterMat');
        save([ pathSave, 'corrFilter',int2str(lenPosition)] , 'corrFilter');
        save([ pathSave, 'timeLagFilter',int2str(lenPosition)] , 'timeLagFilter');
    end
end
% -----------------------------------------------------------------------------------------------------
co = mean(corrFilter)*ones(1, lenPosition);
figure;
subplot(211);
plot(posiArray, corrFilter, posiArray, co);
xlabel('position/m');  ylabel('correlation');
legend('corr', 'mean corr');
title('Correlation graph of time-strain data before and after filtering ');
%
la =ones(1, length(posiArray)) * mean(timeLagFilter);
subplot(212);
plot(posiArray, timeLagFilter, posiArray, la);
xlabel('position/m');  ylabel('timeLag/ms');
legend('timeLag', 'mean timeLag');

%% -----------------------------------------------------------------------------------------------------
%
flag1 = toc;
info = ['# the cost of  correlation analysis of different strain data is: ', num2str(flag1), ' s.' ];
displaytimelog(info);

end








