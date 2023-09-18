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
% this function is used to fft
%% -----------------------------------------------------------------------------------------------------
function [ampMat0, ampMat1, frequencyArray0] = analysis_fft(strainMat, time) %  , pathSave)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% strainMat: lenPosition*lenTime matrix, the original signal, microstrain value
% time: discrete time, the time unit is ms.
% OUTPUT:
% strainFftMat: the strain data after filtering
% timeLagFft: the time delay fater filtering
%
%% -----------------------------------------------------------------------------------------------------
%
tic
% 
% [lenPosition, lenTime] = size(strainMat);
% strainFftMat = zeros(lenPosition, lenTime);
% position = 1:lenPosition;
%
[ampMat0, frequencyArray0, ~] = fftfunc(strainMat, time, 'strain');
%
strainFilterMat = filteringfunc(strainMat, time);
%
[ampMat1, ~, ~] = fftfunc(strainFilterMat, time, 'filtered strain');
%
% -----------------------------------------------------------------------------------------------------

% tic
% 
% maxlag = lenTime;
% % The time delay estimation cross-correlation algorithms before and after filtering are compared
% [corrFft, timeLagFft] = deal(zeros(1, lenPosition)); 
% %   
% for i = 1:lenPosition
%     [tmp, timeLagFft(i)] = crosscorrelation(strainMat(i,:),strainFftMat(i,:), maxlag);
%     corrFft(i) = max(tmp);
% end
% 
% co = mean(corrFft)*ones(1,length(position));
% figure;
% subplot(211);
% plot(position, corrFft, position, co);
% xlabel('position/m');  ylabel('correlation');
% legend('corr', 'mean corr');
% title('Correlation graph of time-strain data before and after denoising, ');
% 
% la =ones(1, length(position)) * mean(timeLagFft/16);
% subplot(212);
% plot(position, timeLagFft/16, position, la);
% xlabel('position/m');  ylabel('timeLag/ms');
% legend('timeLag', 'mean timeLag');
% 
% % Correlation graph of time-strain data before and after denoising.;
% 
% if nargin > 3
%     save([ pathSave, 'strainFftMat',int2str(lenPosition)] , 'strainFftMat');
%     save([ pathSave, 'corrFft',int2str(lenPosition)] , 'corrFft');
%     save([ pathSave, 'timeLagFft',int2str(lenPosition)] , 'timeLagFft');
% end

tt2 = toc;
info = ['# the cost of  correlation graph of time-strain data before and after denoising is: ', num2str(tt2), ' s.' ];
displaytimelog(info);




