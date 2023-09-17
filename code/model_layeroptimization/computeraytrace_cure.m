%
%
% function [realCoordSet, initialCoordSet] = computeraytrace(relatedLayerModel,  relatedVelocityModel,  sensorCoord,  sourceCoord)
% global  x1  x2 layer velocity
% 针对水平地层计算折射路径, 此函数仅讨论大于或等于三个折射层，即只需要确定一个或多个折射点位置坐标的情况。
% 对于二维，确定 x坐标，一个未知数。(x, z), z即折射层
% 对于三维，确定折射点到监测井的直线距离r，即只考虑震源与检波器所在的平面内的折射情况。(r, z), z即折射层
% INPUT:
% relatedLayerModel: nlayer *  1 matrix.    unit: m (metre)
%   -  -   nlayers - 1 different layers with nlayer boundaries
%   -  -   震源与检波器之间的地层深度信息， 每行储存一个交界面的位置
%
%  relatedVelocityModel: (nlayer - 1) *  1 matrix.    unit: m/s (metre per second)
%   -  -   velocity information in each layer, velocity is a given constant in the same layer
%   -  -   震源与检波器之间的地层速度信息，每行储存一个地层的速度信息吗
%
%  sensorCoord: 1 *  numDim matrix.    uint: m (metre)
%   -  -   the position coordinates of the sensors on the ground are: (x_i,  y_i,  0)
%   -  -   the position coordinates of the sensors under the ground are: (0, 0, z_i)
%   -  -    检波器的位置，每行储存一个检波器的坐标
%
%  sourceCoord: 1 *  numDim matrix   
%   -  -   震源位置；
%  refractionPoints: nlayer *  numDim matrix
%   -  -   折射点的坐标，包含检波器和震源的坐标
%%
function [realCoordSet, travelTime, initialCoordSet, velocity] = computeraytrace_curve(relatedLayerModel,  relatedVelocityModel,  sensorCoord,  sourceCoord, flag)
    % 针对水平地层计算折射路径
    %
    if nargin < 5, flag = false;  end
    if size(sourceCoord,  1) > 1,  sourceCoord = sourceCoord';  end
    if size(sensorCoord,  1) > 1,  sensorCoord = sensorCoord';  end
    if size(relatedVelocityModel, 2) > 1, relatedVelocityModel = relatedVelocityModel'; end
    %%
    % info{1} = ['   sensorCoord =[ ', num2str(sensorCoord), ' ];   sourceCoord = [ ', num2str(sourceCoord), ' ];'];
    % info{2} = ['   relatedLayerModel = [ ', num2str( relatedLayerModel' ), ' ]; '];
    % info{3} = ['   relatedVelocityModel = [ ', num2str(relatedVelocityModel' ), ' ]; '];
    % for i = 1: length(info),   disp(info{i});  end
    %%
    % the number of layer
    numLayer = length(relatedLayerModel);
    numDim = length(sensorCoord);
    
    if numLayer == 0
        initialCoordSet = sortrows([sourceCoord;  sensorCoord],  - numDim);
        realCoordSet = sortrows([sourceCoord;  sensorCoord],  - numDim);
        travelTime = norm(sourceCoord - sensorCoord)/relatedVelocityModel(1);
        return;
    end
    
    %%  计算初始折射点坐标
    [initialCoordSet, idxLayer] = layerintersects(relatedLayerModel,  sensorCoord,  sourceCoord);
    % [initialCoordSet, idxLayer] = initialintersections(relatedLayerModel,  sensorCoord,  sourceCoord);
    %%  计算最短时间折射点
    
    %%  计算最短时间折射点
    realCoordSet = initialCoordSet;
    % 地层上下的固定折射点
    st = sortrows( [ sensorCoord; sourceCoord ],  -numDim);
    xy1 = st(1, 1: numDim-1);   z1 = st(1, numDim);
    xy2 = st(2, 1: numDim-1);   z2 = st(2, numDim);
    %
    
    % layer代表的是地层的厚度
    % velocity =  relatedVelocityModel(idxLayer);
    velocity = [relatedVelocityModel(idxLayer(1)) ; relatedVelocityModel(idxLayer + 1)];
    %
    % 地层中间的折射点的x坐标
    xy0Len = size(initialCoordSet, 1);
    xy0 = initialCoordSet( 1: xy0Len, 1: numDim-1);
    %
    if flag
        %% --------------------------------------------------------------------------------------------------------------
        %% # version 1
        % 通过地层折射的总时间函数
        func = @(xy) sum(sqrt(  sum(([xy; xy2] - [xy1; xy]).^2, 2)  ...
            + ( [layerz(relatedLayerModel, xy, idxLayer); z2]- [z1; layerz(relatedLayerModel, xy, idxLayer)]).^2 ) ./ velocity);
        %
        % options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval, 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolX', 2e-4, 'TolFun', 2e-2);
        options = optimset( 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolX', 2e-4, 'TolFun', 2e-2);
        [sol , travelTime] = fminsearch(func, xy0, options);
        %  [sol, totalTime, exitflag, output] = fminsearch(func, x0, options)
        % [sol , totalTime] = fminsearch(func, x0);
        realCoordSet(1: xy0Len, 1: numDim-1) = sol;
        realCoordSet(1: xy0Len, numDim) = layerz(relatedLayerModel, sol, idxLayer);
        
        initialCoordSet = sortrows( [ sensorCoord; initialCoordSet; sourceCoord ],  -numDim);
        realCoordSet = sortrows( [ sensorCoord; realCoordSet; sourceCoord ],  -numDim);
        
        return;
    end
    %% --------------------------------------------------------------------------------------------------------------
    % %% # version 2
    [xyRow, ~] = size(xy0);
    
    xy0 = [xy0(:, 1); xy0(:, 2)];
    %     % 通过地层折射的总时间函数
    func = @(xy) sum(sqrt( ([xy(1:xyRow, 1); xy2(1)] - [xy1(1); xy(1: xyRow, 1)]).^2 + ...
        ([xy(1+ xyRow : end, 1); xy2(2)] - [xy1(2); xy(1+ xyRow : end, 1)]).^2 + ...
        ( [layerz(relatedLayerModel, [xy(1:xyRow, 1), xy(1+ xyRow : end, 1)], idxLayer);  z2] - ...
        [z1;  layerz(relatedLayerModel, [xy(1:xyRow, 1), xy(1+ xyRow : end, 1)], idxLayer)] ).^2 ) ./ velocity);
    % 
    % options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval, 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolX', 2e-4, 'TolFun', 2e-2);
    options = optimset('MaxFunEvals', 6000, 'MaxIter', 10000, 'TolX', 2e-4, 'TolFun', 2e-2);
    [sol , travelTime] = fminsearch(func, xy0, options);
    % [sol, totalTime, exitflag, output] = fminsearch(func, x0, options)
    % [sol , totalTime] = fminsearch(func, x0);
    
    realCoordSet(1: xy0Len, 1: numDim-1) = [sol(1 : xyRow, 1), sol(xyRow+1 : end, 1)];
    realCoordSet(1: xy0Len, numDim) = layerz(relatedLayerModel, [sol(1 : xyRow, 1), sol(xyRow+1 : end, 1)], idxLayer);
    %
    initialCoordSet = sortrows( [ sensorCoord; initialCoordSet; sourceCoord ],  -numDim);
    realCoordSet = sortrows( [ sensorCoord; realCoordSet; sourceCoord ],  -numDim);
    % %
    % %
    % %
    % %
    
    
    
    end
    
    
    
    
    
    