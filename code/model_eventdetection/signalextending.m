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
%
% this code is used to extended system noise signal at the begin and end
%% -----------------------------------------------------------------------------------------------------
% function [strainExt, minT, idxT1, idxArray]= signalextending(strainMat, len, type)
function strainExt= signalextending(strainMat, len, type)
% Extended system noise signal
% INPUT:
% strainMat: numSensor* lenTime matrix, original signal.
% len: a scale, the length of signal extended
% type: 'random' | "noise"
% OUTPUT:
% strainExt: lenPosition*len array, the extended parts of the signal.
%
% -----------------------------------------------------------------------------------------------------
%
% if nargin < 3, type = 'noise';   end
if nargin < 3, type = 'noise';   end

[lenPosition, lenTime] = size(strainMat);
if len> lenTime, len = lenTime;  end
%
% -----------------------------------------------------------------------------------------------------
% %
% % extend the length of strain data
% % by intercepting( Ωÿ»°) the data at the begining of the strain.
% % ext = ones(1, nl) * (sum(strain(1, 1:ns))/ns ); % This approach is too distorted( ß’Ê)
% % extMat = strainMat(:, 1:lenLta);
% % by a noise singnal.
if contains(type, 'random')
    tmp = 3e-4;
    strainExt = 2*tmp*rand(lenPosition, len) - tmp;
    return;
end
% 
%% -----------------------------------------------------------------------------------------------------
%
% if contains(type, 'noise'), ... ;   end
minT = 1e5;
% strain = zeros(2, len);
strain = [];
for idxB = 1:10:(lenTime - len + 1)
    idxArray = idxB:(idxB+len - 1);
    thresholdArray1 = rms(strainMat(:, idxArray), 2) * 1000;
    [minT1, idxT1] = min(thresholdArray1);
    %
    if minT1 < minT, minT = minT1;  strain = strainMat(idxT1, idxArray);   end
%     if minT < 0.08, break; end
end
strainExt = repmat(strain, lenPosition, 1);

% thresholdArray2 = std(strainMat(:, end-len+1:end), 0, 2) * 10000;
% [minT2, idxT2] = min(thresholdArray2);
% strain(2, :) = strainMat(idxT2, end-len+1:end);
% %
% [minT, idx] = min([minT1, minT2]);
% strainExt = strain(idx, :);
% -----------------------------------------------------------------------------------------------------

%
%
end








