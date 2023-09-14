%
%
%   
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to calculate the threshold of each sensor strain change.  
%  and sifting valid sensor.   
%% -----------------------------------------------------------------------------------------------------
function [idxT, thresholdArray0, thresholdArray1, flag] = siftingfunc(strainMat, threshold0, threshold1, lenSta, ratio)
%
% INPUT:
% strainMat: nsensor*nmeasure matrix, ns ensor sensors, and n measure
% threshold0: a scale, the lower limit value of the strain rms      
% threshold1: a scale, the upper limit value of the incompleted strain rms. 
% lenSta: a scale, sampling length for the incompleted strain rms. 
% ratio: a scale, a coefficient for eliminating signals with large rms value differences.
% 
% OUTPUT:
% idxT: 1* num array, a sensor sequence whose signal fluctuations exceed a threshold
% thresholdArray1: numSensor*1, std var of each sensor strain -- strainMat(:, 1:end)              
% thresholdArray2: numSensor*1, std var of the part of each sensor strain -- strainMat(:, 1:lenSta)                                
% -----------------------------------------------------------------------------------------------------
if nargin < 5, ratio = 0.1;   end
if nargin < 4, lenSta = 400;   end
if nargin < 3, threshold1 = 0.31;   end
if nargin < 2, threshold0 = 0.21;   end
% 
% %% strainMat 3D
% plot3D(axes(figure), strainMat, [], 1:lenTime);

lenSta = lenSta *3;  %  *2;   % 
%% Eliminate signals that are smaller than the lower limit of the threshold                                  
% thresholdArray0 = std(strainMat, 0, 2) * 1000;   %  std, 标准差, unit: n-strain    
thresholdArray0 = rms(strainMat, 2)*1000;    % rms, 均方根, unit: n-strain         
% thresholdArray0 = sqrt(sum(strainMat.^2, 2)/size(strainMat, 2))*1000;   %   rms, 均方根, unit: n-strain         

% if any(thresholdArray0 > 280), thresholdArray0 = thresholdArray0/1000;    end
idxT = find(thresholdArray0 > threshold0);
%  
%% Eliminate signals that may be incomplete.  (剔除不完整的信号) 
% lenSta = 320; 
% thresholdArray1 = std(strainMat(:, 1:(lenSta*2)), 0, 2) * 1000;
thresholdArray1 = rms(strainMat(:, 1:lenSta), 2)*1000; 
idxBad = find(thresholdArray1 > threshold1);
idxT = setdiff(idxT, idxBad);
% 
%% Eliminate signals with large threshold/rms-value differences.  (剔除阈值差异过大的信号)
% ratio = 0.3; 
if length(idxT)>10
    tmp = find(thresholdArray0 < mean(thresholdArray0)*ratio);
    idxT = setdiff(idxT, tmp);
end
% 
% -----------------------------------------------------------------------------------------------------
% 
idxT = idxT';
% 
flag = 1;
%% if nargout > 3, output graph case. 
if nargout > 3
    % -----------------------------------------------------------------------------------------------------
    fig = figure;
    set(fig,'Position',[100,100,500,300]);
    axt = axes(fig);  hold(axt, 'on');
    %
    yyaxis(axt, 'left');
    plot(axt, thresholdArray0); 
    plot(axt, mean(thresholdArray0)*ones(length(thresholdArray0), 1), 'DisplayName', 'mean rms');
    ylabel(axt, 'the total signal std. ');
    %
    yyaxis(axt, 'right');
    plot(axt, thresholdArray1);
    ylabel(axt, 'the part signal  rms. ');
    %
    xlabel(axt, 'sensor sequence. ');     title(axt, ['threshold distribution, ', 'threshold is rms var of strainMat ']);
    %
end


end

