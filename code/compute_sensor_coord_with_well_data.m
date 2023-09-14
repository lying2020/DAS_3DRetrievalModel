
% 1.  根据井的不同位置的点，计算出来井的总长度；
% 2. 计算出从井口到井底，每间隔5m的坐标 [x, y, z]. 
function [well_length, interpolated_points] = compute_sensor_coord_with_well_data(data)
% well_length就是井的总长度，interpolated_points就是从井口到井底，每间隔5m的坐标。
well_length = calculateWellLength(data);
interpolated_points = calculateInterpolatedPoints(data, 5);

end

function well_length = calculateWellLength(data)
    % 计算井的总长度
    well_length = 0;
    for i = 1:size(data, 1)-1
        well_length = well_length + norm(data(i, :) - data(i+1, :));
    end
end

function interpolated_points = calculateInterpolatedPoints(data, interval)
    % 计算从井口到井底，每间隔interval m的坐标
    total_length = calculateWellLength(data);
    num_points = total_length / interval;
    % 创建一个向量，表示每个点在井中的深度
    depths = [0; cumsum(sqrt(sum(diff(data).^2, 2)))];
    % 创建一个向量，表示每间隔interval m的深度
    interp_depths = (0:interval:depths(end))';
    % 使用插值函数计算每间隔interval m的坐标
    interpolated_points = interp1(depths, data, interp_depths);
end