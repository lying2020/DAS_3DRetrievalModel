%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this function is used for  2D plot
%% -----------------------------------------------------------------------------------------------------
function [p1, p2, p3] = plot2D(ax1, strainMat, position, time, autoWindow, manualWindow)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% ax1: axes handle ion the user interface figure window
% strainMat: nsensor* nmeasure matrix, ns ensor sensors, and n measure
%              strainMat is the original signal, microstrain value of selected sensor
% position: nsensor* 1 matrix, position of nsensor sensors
% time: 1*nmeasure matrix, nmeasure measures(sampling data)
% window: nsensor* mwindows, nsensor sensors, mwindows time windows,
%              that means mwindows seismic events
% pathSave: 2D figure save path
% 
% OUTPUT:
% [p1, p2, p3]: the figure handle of plot 
% tfg: total time cost flag
% 
%% -----------------------------------------------------------------------------------------------------
% some default parameters set. 
if ~ishandle(ax1),  ax1 = axes(uifigure);  end
if nargin< 6,  manualWindow = [];  end
if nargin< 5,  autoWindow = [];       end
% 
if length(strainMat) < 2, warning('plot3D: NO OUTPUT !!! ');  return;  end
[lenPosition, lenTime] =size(strainMat);
if nargin<4, time = (1:lenTime)*0.064;   end
if isempty(time), time = (1:lenTime)*0.064;   end
if nargin<3, position = 1:lenPosition;   end
if isempty(position), position = 1:lenPosition;   end
% 
[p1, p2, p3] = deal(plot([]));
% 
hold(ax1, 'on');
%% -----------------------------------------------------------------------------------------------------
%
time = time - time(1)* 2 + time(2);
%  2D drawing with strain matrix
%% 
interval = 4; 
% normalization  
strainMat = interval* strainMat./(max(abs(strainMat), [], 2));
% 
tmpArray = ones(1, lenPosition + 1);
% ms = mean(max(abs(strainMat), [], 2))* 1.5;
delta = ones(1, lenPosition);% diff(position); delta(lenPosition) = 1;
for i = 1:lenPosition
    p1 = plot(ax1, time, tmpArray(i) + strainMat(i, :), 'b');   % 'DisplayName', 'strain');  
    tmpArray(i + 1) = tmpArray(i) + 2*interval*delta(i) + 0.01;
end
% 
%% -----------------------------------------------------------------------------------------------------
% Mark automatic pickup time window data
% if ~isempty(autoWindow)
%     sm = (autoWindow - 1)*lenPosition + position';
%     p2 = plot(ax1, time(autoWindow), tmpArray + strainMat(sm), 'r.', 'LineWidth', 1.1, 'MarkerSize', 5.5, 'DisplayName', 'aW');  %
% end
% 
% meanInterval = 5.0 / mean( (time(11:15) - time(6:10)) );
[aw1, aw2] = size(autoWindow);
for i = 1:aw1
    for j = 1: aw2
        awEnd = 0;   % min(floor(310 * meanInterval), length(time) - autoWindow(i, j));
            awArray = autoWindow(i, j):(autoWindow(i, j) + awEnd);
        p2 = plot(ax1, time(awArray), tmpArray(i) + strainMat(i, awArray), 'r.', 'LineWidth', 2.1, 'MarkerSize', 8.5);  %  , 'DisplayName', 'aW');  %
    end
    %         yTic(i) = tmp + strainMat(i, 1);
    %         yLab{i} = num2str(position(i));
end

%% -----------------------------------------------------------------------------------------------------
% Marks manual pickup time window data
if ~isempty(manualWindow)
    sm1 = (manualWindow - 1)*lenPosition + position';
    p3 = plot(ax1, time(manualWindow), tmpArray + strainMat(sm1), 'k.', 'LineWidth', 1.1, 'MarkerSize', 5.5, 'DisplayName', 'mW');  %
end
% 
% meanInterval = 5.0 / mean( (time(11:15) - time(6:10)) );
% tmpArray =0.1;
% [mw1, mw2] = size(manualWindow);
% for i = 1:mw1
%     for j = 1: mw2
%         mwEnd = 1;  %  min(floor(310 * meanInterval), length(time) - manualWindow(i, j));
%         mwArray = manualWindow(i, j):(manualWindow(i, j) + mwEnd);
%         p3 = plot(ax1, time(mwArray), tmpArray(i) + strainMat(i, mwArray), 'Linewidth', 1.5,  'Color', [0.30,0.75,0.93]);  % , 'DisplayName', 'mW'); % 'Color', [0.72,0.57,0.12]);
%         p3.Color(4) = 0.2;
%     end
% end
% 
%% -----------------------------------------------------------------------------------------------------
% if aw1
%     if mw1
%       legend(ax1, [p1, p2, p3], 'strain', ' autoWindow',  'manualWindow', 'TextColor', 'blue'); %, 'Location','southeast');
%     else
%     legend(ax1, [p1, p2], 'strain', ' autoWindow', 'TextColor', 'blue'); % , 'Location','southeast');
%     end
% else
%      if mw1,  legend(ax1, [p1, p3], 'strain', 'manualWindow', 'TextColor', 'blue');    end
% end
%% -----------------------------------------------------------------------------------------------------
% x coordinate label
%             lenX = 8;
%             % xTic = zeros(1, lenX);
%             xLab = cell(1, lenX);
%             xArray = floor( (linspace(1, lenTime, lenX)) );
%             xTic = (floor(ti(xArray)/100) + 1) * 100;
%             for jx = 1:lenX
%                %   xTic(jx) = ti(xArray(jx));
%                 xLab{jx} = num2str(xTic(jx));
%             end
%
%    xticks(ax1, xTic);
%   xticklabels(ax1, xLab);
%% -----------------------------------------------------------------------------------------------------
% y coordinate label
lenY = lenPosition;  %  min(8, lenPosition);
% yTic = zeros(1, lenY );
yLab = cell(1, lenY);
yArray = round(linspace(1, lenPosition,  lenY));
yTic = tmpArray(yArray) + (strainMat(yArray, 1))';
for j = 1:lenY
    % yTic(j) = tmp(yArray(j)) + strainMat(yArray(j), 1);
    yLab{j} = num2str( round( position(yArray(j)) ) );
end
% 
yticks(ax1, yTic);
yticklabels(ax1, yLab);
%% -----------------------------------------------------------------------------------------------------
% 
deciTime = floor( lenTime/20);
tmpTime = time(1, deciTime) - time(1, 1);
xlim(ax1, [time(1) - tmpTime,  time(end) + tmpTime]);

% if ~isempty(autoWindow)
%     delta = floor((max(autoWindow) - min(autoWindow))*1.5);
%     xlim(ax1, [min(max(time(min(autoWindow)) - time(delta), -2)), max(min(time(max(autoWindow)) + time(delta), time(end) + 2))]);
% end

title(ax1, ['the plot of time-strain with ', num2str(lenPosition), ' sensors']);
box(ax1, 'on');
xlabel(ax1, 'time/ms');
ylabel(ax1, 'position/m');
hold(ax1, 'off');
% 
end
%% -----------------------------------------------------------------------------------------------------
%
%  b = bar(rand(10,5),'stacked');
%           hold on
%           ln = plot(1:10,5*rand(10,1),'-o');
%           hold off
%           legend([b,ln],'Carrots','Peas','Peppers','Green Beans',...
%                     'Cucumbers','Eggplant')





