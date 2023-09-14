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
% loop # staltaloop1, attenuation impulse response
function ratioMat = staltaloop1(strainMatExt, lenSta, lenLta, sta0, lta0)
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
% -----------------------------------------------------------------------------------------------------
[lenPosition, lenTime]= size(strainMatExt);
lenTime = lenTime - lenLta - lenSta;
ratioMat = zeros(lenPosition, lenTime);
%
% h=waitbar(0,'Getting the sta-lta ratio ......'); % , 'CreateCancelBtn', 'deleteh(h)');
%
for i = 1: lenTime - 1
    % if ~mod((lenTime - 1), i),  waitbar(i/(lenTime - 1), h);  end
    % cf(i + 1)
    tmpS = characteristicfunc(strainMatExt(:, (i + lenLta):(i + lenLta + 1)));
    % cf(i - lenSta)
    tmpL = characteristicfunc(strainMatExt(:, (i + lenLta - lenSta - 1):(i + lenLta - lenSta)));
    %
    % -----------------------------------------------------------------------------------------------------
    % sta0(i + 1) = sta0(i) + (cf(i + 1) - sta0(i)) /lenSta;
    sta0 = sta0 + (tmpS - sta0) / lenSta;
    % lta0(i + 1) = lta0(i) + (cf(i - lenSta) - lta0(i)) / lenLta;
    lta0 = lta0 +(tmpL - lta0)/lenLta;
    %
    ratioMat(:, i + 1) = min(50, sta0./lta0);
end
%
%   close(h);
%
end









