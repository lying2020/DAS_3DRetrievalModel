%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to calculate the maximum amplitude and corresponding time of a signal
%% -----------------------------------------------------------------------------------------------------
function [tw, aic0, flag] = analysis_AIC(strainMat, time, window)
% -----------------------------------------------------------------------------------------------------
if nargin < 3, window = [];  end
if nargin < 2, time = 1:length(strainMat(1, :));  end
%
[num, ~] = size(strainMat);
idxSeq = 1:num;
[tw, aic0] = AIC(strainMat);
%

ax1 = axes(figure);  hold(ax1, 'on');
plot3D(ax1, strainMat, idxSeq, time, []);
sm = num*(tw - 1) + idxSeq';
plot3(ax1, time(tw), idxSeq, strainMat(sm), 'k*', 'linewidth', 2, 'DisplayName', 'aic');

% 
% x = time(tw);   y = idxSeq;    z = zeros(1, num);
% for i = 1:num
% z(i) = strainMat(idxSeq(i), tw(i));
% end
% plot3(ax1, x, y, z, 'k*', 'linewidth', 2, 'DisplayName', 'aic');
% 
if ~isempty(window)
    sm1 = num*(window - 1) + idxSeq';
    plot3(ax1, time(window), idxSeq, strainMat(sm1), 'r*', 'linewidth', 1, 'DisplayName', 'timewindow');
end
title(ax1, 'function: analysis\_AIC. ');
%% -----------------------------------------------------------------------------------------------------
if nargout < 3, return;   end
% 
flag = 1;
% % %
for i = 1:num
    ax1 = axes(figure(floor(2e5*rand + i)));  hold(ax1, 'on');
    yyaxis(ax1, 'left');
    plot(ax1, time, strainMat(idxSeq(i), :));
    h1 = plot(ax1, time(tw(i)), strainMat(idxSeq(i), tw(i)), 'k*', 'linewidth', 1, 'DisplayName', 'aic');
      set(get(get(h1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'on');
    if ~isempty(window)
        h2 = plot(ax1, time(window(i)), strainMat(idxSeq(i), window(i)), 'r*', 'linewidth', 1, 'DisplayName', 'timewindow');
           set(get(get(h2, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'on');
    end
    yyaxis(ax1, 'right');
    h3 = plot(ax1, time, aic0(i, :), 'DisplayName', 'timewindow');
    set(get(get(h3, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'on');
    c = 1;
    title(ax1, 'black -- aic,  red -- time window');
end
% 

%% -----------------------------------------------------------------------------------------------------
% start = 1;
% final = length(time);
% partStrain = strainMat(:, start : final);
% [tw1, tfg(2)] = AIC(partStrain);
% [tw2, tfg(3)] = AIC1(partStrain);
% sum(tw - tw1)



end
