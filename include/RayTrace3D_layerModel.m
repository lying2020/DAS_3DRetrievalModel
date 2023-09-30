function  [Position, markX0 , initial_guess_velocity, errort, trivalt] = RayTrace3D_layerModel(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorCoord, sourceCoord)
%% Describe:
% The program calculates ray paths for the horizontal layers, when the source and sensor position
% are known. A quasi-Newton method called Broyden's method is used to
% approximate the solution to a nonlinear system.
%% INPUT: 
% * velocityModel: the acoustic velocity model. ( (numLayer+1)*1 )
% * sensorCoord: the position of dector. (Dim*1)
% * sourceCoord:  the position of seismic source. (Dim*1)
% * Layer:  layer information.  (function or data)
%% OUTPUT:
% * Position: the position of refraction position. (M*1)

%% CONSTENT
% compute the intersection points (the initial points of iteration) and the
% the corresponding velocity.
iteratorstep = 200;
maxrefractionpoint = 40;

%% 
if (sourceCoord(3) == sensorCoord(3))
    sourceCoord(3) = sourceCoord(3) + 1e-6;
end

[intersect_points, idxLayer]=computelayerintersectscoords(layerCoeffModel, layerGridModel, layerRangeModel, sourceCoord, sensorCoord);
initial_guess_points = intersect_points;

layerRange = layerRangeModel{1};
% intervalXY = layerRange(1, 3);
intervalXY = layerGridModel{1, 1}(2, 2) - layerGridModel{1, 1}(1, 1);

% ax1 = axes(figure);  hold(ax1, 'on');
% for iFile = 1: length(idxLayer)
%     x = layerGridModel{iFile,1};
%     y = layerGridModel{iFile,2};
%     z = layerGridModel{iFile,3};
%     layersurf(ax1, x, y, z);
%     % shading(ax1, 'faceted');
% end
% scatter3(ax1, intersect_points(:, 1), intersect_points(:, 2), intersect_points(:, 3), 40, 'blue', 'filled');
% ss = [sourceCoord; sensorCoord];
% plot3(ax1, ss(:, 1), ss(:, 2), ss(:, 3), 'r-', 'linewidth', 2.5);
% xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');


%% 
% [initial_guess_points, ia]= sortrows([sourceCoord; initial_guess_points; sensorCoord], 3);
if isempty(initial_guess_points)
    if sourceCoord(3) < sensorCoord(3)
        initial_guess_points = [sourceCoord; initial_guess_points; sensorCoord];
    else
        initial_guess_points = [sensorCoord; initial_guess_points; sourceCoord];
    end
else
    [initial_guess_points, ia]= sortrows(initial_guess_points, 3);
    idxLayer = idxLayer(ia)';
    if sourceCoord(3) < sensorCoord(3)
        initial_guess_points = [sourceCoord; initial_guess_points; sensorCoord];
    else
        initial_guess_points = [sensorCoord; initial_guess_points; sourceCoord];
    end
end

%%
[num_pts, ~] = size(initial_guess_points);

% size(X0) == [4, length(idxLayer) + 2];
X0 = [initial_guess_points'; 0 idxLayer 0] ;

% delete the layers with the too small distance. 
% num_pts = size(X0, 2);
if num_pts > 2
    deleteX0 = [];
    if norm(X0(1:3, num_pts) - X0(1:3, num_pts-1)) < intervalXY/10
        deleteX0(end+1) = num_pts-1;
    end
    if norm(X0(1:3, 2) - X0(1:3, 1)) < intervalXY/10
        deleteX0(end+1) = 2;
    end
    for i_X0 = num_pts-1:-1:3
        if X0(4, i_X0) == X0(4, i_X0-1)
            if norm(X0(1:3, i_X0) - X0(1:3, i_X0-1)) < intervalXY
                deleteX0(end+1) = i_X0;
            end
        end
    end
    X0(:, deleteX0) = [];
end
%
num_X0_pts = size(X0, 2);
clear initial_guess_velocity;
initial_guess_velocity = zeros(1, num_X0_pts - 1);
for i_X0 = 1 : num_X0_pts-1
    p = (X0(:, i_X0) + X0(:, i_X0+1))./2;
    p = p';
    m = size(layerCoeffModel, 1);
    xyArray(1:m, 1) = p(1, 1);
    xyArray(1:m, 2) = p(1, 2);
    idx = (1:m)';
    z = [computelayerz(layerCoeffModel, layerGridModel, layerRangeModel, xyArray, idx); p(1, 3)];
    z = sortrows(z, 1);
    [row, ~] = find(z == p(1, 3));
    initial_guess_velocity(i_X0) = velocityModel(row(1), 1);
end

%%
count_mark = 1;
markX0 = zeros(4, maxrefractionpoint, iteratorstep);
mark_initial_guess_velocity = zeros(1, maxrefractionpoint, iteratorstep);
nump(count_mark) = size(X0, 2);
markX0(1:4, 1:nump(count_mark), count_mark) = X0(1:4, :); %  
mark_initial_guess_velocity(1, 1:nump(count_mark)-1, count_mark) = initial_guess_velocity(:);
count_mark = count_mark + 1;
trivalt(1) = trivaltime(initial_guess_velocity, X0); %  
smallt = 1;
countinstop = 10;
countin = 0;
for j=1:iteratorstep
    X00=X0;
    %
    num_X0_pts = size(X0, 2);
    for ii=num_X0_pts-1:-1:2
        iteraX=X0(1:3, [ii-1, ii, ii+1]);
        iteraVelMod=initial_guess_velocity([ii-1, ii]);
        ii_layer = X0(4, ii);
        X0(1:3, ii) = calculateSingleIntersection_layerCoeffModel_temp(iteraX, iteraVelMod, layerCoeffModel(ii_layer), layerGridModel(ii_layer, :), layerRangeModel(ii_layer, :));
%         errorz = computelayerz(layerCoeffModel(ii_layer), layerGridModel(ii_layer, :), layerRangeModel(ii_layer, :), X0(1:2, ii)', 1) - X0(3, ii);
%         if norm(errorz) > 1
% %             warning('z coordinate error wrong');
%         end
    end
    error_position_changed = max(max(abs(X00(1:3, :)-X0(1:3, :))));
    % 
    if num_X0_pts <= 2
        break;
    end
    deleteX0 = [];
    if norm(X0(1:3, num_X0_pts) - X0(1:3, num_X0_pts-1)) < intervalXY/100
        deleteX0(end+1) = num_X0_pts-1;
    end
    if norm(X0(1:3, 2) - X0(1:3, 1)) < intervalXY/100
        deleteX0(end+1) = 2;
    end
    for i_X0 = num_X0_pts-1:-1:3
        if X0(4, i_X0) == X0(4, i_X0-1)
            if norm(X0(1:3, i_X0) - X0(1:3, i_X0-1)) < intervalXY
                deleteX0(end+1) = i_X0;
            end
        end
    end
    X0(:, deleteX0) = [];
    clear initial_guess_velocity;
    initial_guess_velocity = zeros(1, size(X0', 1)-1);
    for i_X0 = 1:size(X0', 1)-1
        p = (X0(:, i_X0) + X0(:, i_X0+1))./2;
        p = p';
        m = size(layerCoeffModel, 1);
        xyArray(1:m, 1) = p(1, 1);
        xyArray(1:m, 2) = p(1, 2);
        idx = (1:m)';
        z = [computelayerz(layerCoeffModel, layerGridModel, layerRangeModel, xyArray, idx);p(1, 3)];
        z = sortrows(z, 1);
        [row, ~] = find(z == p(1, 3));
        initial_guess_velocity(i_X0) = velocityModel(row(1));
    end
    nump(count_mark) = size(X0, 2);
    markX0(1:4, 1:nump(count_mark), count_mark) = X0(1:4, :);
    mark_initial_guess_velocity(1, 1:nump(count_mark)-1, count_mark) = initial_guess_velocity(:);
    trivalt(count_mark) = trivaltime(initial_guess_velocity, X0);
    count_mark = count_mark+1;
    % 
    if trivalt(end) > trivalt(smallt) - 1e-5  
        countin = countin+1;   
    else
        countin = 0;
    end
    if trivalt(end) < trivalt(smallt)
        smallt = count_mark-1;
    end
    if error_position_changed<1e-4
        break
    elseif countin > countinstop
        break
    end
end
Position = markX0(:, 1:nump(smallt), smallt);
initial_guess_velocity = mark_initial_guess_velocity(1, 1:nump(smallt)-1, smallt);
errort = trivalt(1) - trivalt(smallt);
if size(Position, 2) ~= size(initial_guess_velocity, 2)+1
    r = 0;
end
end

