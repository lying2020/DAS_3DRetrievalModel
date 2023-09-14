%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2019-09-24: Complete
% 2020-05-24: Modify the description and comments
% 2020-07-06: add das format read function(binary storage)
% 2020-11-04: do some bug fixes

% This code is used to draw a three-dimensional picture of seismic events
%% -----------------------------------------------------------------------------------------------------
function [h1, h2, h3, h4, h5] = sourceplot3D(ax1, layerGridModel, wellCoordSet, sensorCoordSet, sourceCoordSet)  %  ,  pathSave)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% ax1: the handle of axes in the uiFigure, GUI
% layerGridModel:  numLayer* 1 matrix, or numLayer* numDim cell.
% numLayer-1 different stratums with numLayer boundaries
% wellCoordSet: numWell * numDim matrix. monitoring well model
% sensorCoordSet: numSensor*numDim matrix.
%  --  the position coordinates of nsensor sensors, x, y, z
%  --  the coordinates of the sensors on the ground are: (x_i,  y_i,  0)
%  --  the coordinates of the sensors under the ground are: (0, 0, z_i)
% sourceCoordSet: numEvents* numDim matrix. position of seismic events.
% the (numDim + 1)th dimension is the time point tha earthquak arrivals.
%
% OUTPUT:
% [h1 h2 h3 h4 h5]:
% the axes handle of sourceCoordSet, opticalCableCoordSet, sensorCoordSet, wellCoordSet, layerGridModel
% delete([h1 h2 h3 h4 h5]);
% 
%% -----------------------------------------------------------------------------------------------
% some default parameters set.
if nargin < 5,  sourceCoordSet = [];    end
if nargin < 4,  sensorCoordSet = [];    end
if nargin < 3,  wellCoordSet = [];   end
if nargin < 2,  layerGridModel = [];  end
if nargin < 1,  ax1 = axes(figure);          end
%
if ~ishandle(ax1),  ax1 = axes(figure);  end
hold(ax1, 'on');
%
% d = uiprogressdlg(app.seismic,'Title','ProgressDialog -- data display', 'Indeterminate','on');
% d.Message = 'Reading seismic source data ...';
%% -----------------------------------------------------------------------------------------------
numDim = 3;
% [baseX, baseY, baseZ] = deal(0);
baseCoord = zeros(1, numDim);   %  base coordinate.
 [h1, h2, h3, h4, h5] = deal(plot([]));
% -----------------------------------------------------------------------------------------------
% initialize base coordinate
if ~isempty(wellCoordSet)
    if size(wellCoordSet, 2) == 4, wellCoordSet(:, 1) = [];    end
    %     baseX = wellCoordSet(1, 1);  baseY = wellCoordSet(1, 2);  baseZ = wellCoordSet(1, 3);
   % [~, idx] = max( wellCoordSet(:, numDim) );
   % baseCoord = wellCoordSet(idx, :);
end
%
%% --------------------------------------------------------------------------------------------------
% plot seismic source position
if ~isempty(sourceCoordSet)
    sourceCoordSet = sourceCoordSet(:, 1: 3) - baseCoord;
    co = abs(sourceCoordSet(:, 1))/ max(abs(sourceCoordSet(:, 1)))  ...
         + abs(sourceCoordSet(:, 2))/ max(abs(sourceCoordSet(:, 2)))  ...
         + abs(sourceCoordSet(:, 3))/ max(abs(sourceCoordSet(:, 3))); % color
    si = ones(size(co))*10;  % point size 
    % co = linspace(1, 5, length(co))';
    % h1 = plot3(ax1, sourceCoordSet(:, 1), sourceCoordSet(:, 2), sourceCoordSet(:, 3), 'ro', 'MarkerFaceColor', 'r', 'markersize', 5  );
    h1 = scatter3(ax1, sourceCoordSet(:, 1), sourceCoordSet(:, 2), sourceCoordSet(:, 3), si, co, 'filled', 'DisplayName', '地震事件分布');
   % set(get(get(h1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    h1.MarkerFaceAlpha = 0.8;  %  'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2
    h1.MarkerEdgeAlpha = 0.2;
    cb = colorbar(ax1); % create and label the colorbar
    cb.Label.String = 'Seismic event distribution coloring.';
    cb.Color = [0.49,0.06,0.06];
end
%
%% --------------------------------------------------------------------------------------------------
% plot sensor position ...
if ~isempty(sensorCoordSet)
    %     [sensorCoordSet, opticalCableCoordSet] = posi3D(sensorCoordSet);
    opticalCableCoordSet = getcablecoord(wellCoordSet, sensorCoordSet);
    if size(sensorCoordSet, 2) ~= 3, sensorCoordSet = sensorCoordSet';  end
    if size(opticalCableCoordSet, 2) ~= 3, opticalCableCoordSet = opticalCableCoordSet';  end
    %   The distribution model of optical cable
    opticalCableCoordSet = opticalCableCoordSet - baseCoord;
    h2 = plot3(ax1, opticalCableCoordSet(:, 1), opticalCableCoordSet(:, 2), opticalCableCoordSet(:, 3), 'Linewidth', 2.8, 'Color', [0.30,0.75,0.93], 'DisplayName', '光缆分布');
     set(get(get(h2, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    h2.Color(4) = 0.8;
    % The distribution model of sensor position ...
    sensorCoordSet = sensorCoordSet - baseCoord;
%      h3 = scatter3(ax1, sensorCoordSet(:, 1), sensorCoordSet(:, 2), sensorCoordSet(:, 3), 'filled', 'DisplayName', '检波器分布');
%     h3 = plot3(ax1, sensorCoordSet(:, 1), sensorCoordSet(:, 2), sensorCoordSet(:, 3), 'r*', 'Linewidth', 1.0, 'DisplayName', '检波器分布');
     h3 = plot3(ax1, sensorCoordSet(:, 1), sensorCoordSet(:, 2), sensorCoordSet(:, 3), 'r.', 'MarkerSize', 7.5, 'DisplayName', '检波器分布');
     % set(get(get(h3, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
end
%
%% --------------------------------------------------------------------------------------------------
% plot 3D monitoring well model
if ~isempty(wellCoordSet)
    wellCoordSet = wellCoordSet - baseCoord;
    h4 = plot3(ax1, wellCoordSet(:, 1),  wellCoordSet(:, 2),  wellCoordSet(:, 3), 'Linewidth', 4,  'Color', [0.72,0.57,0.12], 'DisplayName', '监测井结构');
    % set(get(get(h4, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    % h1 = plot3(ax2, 0, 0, z, 'Linewidth', 10,  'Color', [0.72,0.57,0.12]);
    h4.Color(4) = 0.6;
end
%
% set the coordinate display range
ssw = [sensorCoordSet; sourceCoordSet; wellCoordSet];
% if isempty(layerGridModel),   layerGridModel = linspace(min(ss(:, end)), max(ss(:, end)), 4);   end
%% --------------------------------------------------------------------------------------------------
% plot 3D layer model  
% ax1_pos = ax1.Position; % position of first axes
if ~isempty(layerGridModel)
%     ax1 = axes('Position',ax1_pos, 'XAxisLocation','top',  'YAxisLocation','right', 'Color','none');
    hold(ax1, 'on');
    numLayer = size(layerGridModel, 1);   %  the number of layer.
    if isa(layerGridModel, 'numeric')
        numLayer = length(layerGridModel);
        %% set axes range
        minSs  = min(ssw, [], 1);    if isempty(minSs), minSs = [0 0 0];  end
        maxSs = max(ssw, [], 1);    if isempty(maxSs), maxSs = [0 0 0];  end
        deltaSs = max( 1,  (maxSs - minSs) / 20 );
        %  if isempty(deltaSs), deltaSs = [1 1 1];  end
        xlim(ax1, [minSs(1) - 1.2* deltaSs(1), maxSs(1) + 1.2* deltaSs(1)]);
        ylim(ax1, [minSs(2) - 1.2* deltaSs(2), maxSs(2) + 1.2* deltaSs(2)]);
        %  zlim(ax1, [minSs(3) - deltaSs(3), maxSs(3) + deltaSs(3)]);
        deltaZ = max(1, abs(layerGridModel(1) - layerGridModel(end)) / 20);
        zlim(ax1, [min(layerGridModel) - 1.2* deltaZ, max(layerGridModel) + 1.2* deltaZ]);
        %  xlim auto;     ylim auto;    zlim auto;
        %%  set x, y coord range. 
        delta = deltaSs/10;
        x = minSs(1) - deltaSs(1): delta: maxSs(1) + deltaSs(1);
        y = minSs(2) - deltaSs(2): delta: maxSs(2) + deltaSs(2);
        [X, Y] = meshgrid(x, y);
        tmpLayer = cell(numLayer, numDim);
        for ilayer = 1: numLayer
            Z = ones(size(X))* layerGridModel(ilayer);
            tmpLayer(ilayer, :) = {X, Y, Z};
        end
        layerGridModel = tmpLayer;
    end
    %% --------------------------------------------------------------------------------------------------
    % the layer model
    for ilayer = 1: numLayer
        [xMat, yMat, zMat] = layerGridModel{ilayer, 1: numDim};
        h5 = layersurf(ax1, xMat, yMat, zMat);
        set(get(get(h5, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    end
     set(get(get(h5, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'on');
%     h5.DisplayName = '地层分布';
end
%
%% axes property . 
axesproperty(ax1);
% lg = {‘底层结构’， '监测井结构',  '光缆分布',  '检波器分布‘， ’地震事件分布‘};
%
% lgd = legend(ax1, 'TextColor', 'blue', 'Location','southeast', 'NumColumns', 2);
% 
% lgd = legend(ax1, 'TextColor', 'blue', 'Location','northoutside', 'Orientation', 'horizontal', 'NumColumns', 2);
% title(lgd,'My Legend Title');
% legend(ax1, 'boxoff');
% view(ax1, -31, 13);
% xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');
%
end


%% --------------------------------------------------------------------------------------------------
function  opticalCableCoordSet = getcablecoord(wellCoordSet, sensorCoordSet)

idx = find(sensorCoordSet(:, 3) > -1000, 1, 'last');  
 if isempty(idx),   opticalCableCoordSet = sensorCoordSet;  return; end
opticalCableCoordSet = [sensorCoordSet(1:idx, :); [0, 0, sensorCoordSet(idx, 3)]; wellCoordSet];
% [numSensor, numDim] = size(sensorCoordSet);
% opticalCableCoordSet = zeros(numSensor+1, numDim);
% opticalCableCoordSet(1:idx, :) =  sensorCoordSet(1:idx, :);
% opticalCableCoordSet(1+idx, :) = [0, 0, sensorCoordSet(idx, 3)];
% opticalCableCoordSet(1+idx:end, :) = sensorCoordSet(idx+1:end, :);

end