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
% this code is used to process  micostrain data, get time windows
%% -----------------------------------------------------------------------------------------------------
% loop # staltaloop, sta-lta ratio recursively.
function ratioMat = staltaloop2(strainMatExt, lenSta, lenLta, sta0, lta0)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% strainMatExt: strain data, numSensor*(nmeasure+ lenLta+ lenSta)
% lenSta: short time window length
% lenLta: long time window lentgh
% sta0: the sta value of the 1th sta-lta time windows value
% lta0: the lta value of the 1th sta-lta time windows value
% ex: lenSta = 320;    lenLta = 6400;
% 
% OUTPUT:
% ratioMat: sta-lta ration matrix.
% 
% ex: 
% ratioMat(:, i) = (\sum_{k = i}^{i + lenSta -1}*cf(k)) / (\sum_{k = i-lenLen}^{i -1}*cf(k));
% -----------------------------------------------------------------------------------------------------
[lenPosition, lenTime]= size(strainMatExt); 
lenTime = lenTime - lenLta - lenSta; 
ratioMat = zeros(lenPosition, lenTime); 
% h=waitbar(0.01,'Getting the sta-lta ratio ......', 'Position', [0.5 0.5 0.2 0.1]); % , 'CreateCancelBtn', 'deleteh(h)');
% 
for i = 1: lenTime - 1
    % if ~mod((lenTime - 1), i),  waitbar(i/(lenTime - 1), h);  end
    % cf(i+1)
    tmp = characteristicfunc(strainMatExt(:, (i + lenLta):(i + 1 + lenLta)));
    % cf(i + lenSta + 1)
    tmpS = characteristicfunc(strainMatExt(:, (i + lenLta + lenSta):(i + 1 + lenLta + lenSta)));
    % cf(i - lenLta + 1)
    tmpL = characteristicfunc(strainMatExt(:, i:(i + 1)));
    % 
    % -----------------------------------------------------------------------------------------------------
    % sta0(i + 1) = sta0(i) + (cf(i + 1) - cf(i - lenSta + 1))/lenSta;
    sta0 = sta0 + (tmpS - tmp) / lenSta;
    % lta0(i + 1) = lta0(i) + (cf(i + 1) - cf(i - lenLta +1)) / lenLta;
    lta0 = lta0 +(tmp - tmpL)/lenLta;
    %  
    ratioMat(:, i + 1) = min(50, sta0./lta0);
end
%
% close(h);
end









