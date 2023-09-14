
% 1.  ���ݾ��Ĳ�ͬλ�õĵ㣬������������ܳ��ȣ�
% 2. ������Ӿ��ڵ����ף�ÿ���5m������ [x, y, z]. 
function [well_length, interpolated_points] = compute_sensor_coord_with_well_data(data)
% well_length���Ǿ����ܳ��ȣ�interpolated_points���ǴӾ��ڵ����ף�ÿ���5m�����ꡣ
well_length = calculateWellLength(data);
interpolated_points = calculateInterpolatedPoints(data, 5);

end

function well_length = calculateWellLength(data)
    % ���㾮���ܳ���
    well_length = 0;
    for i = 1:size(data, 1)-1
        well_length = well_length + norm(data(i, :) - data(i+1, :));
    end
end

function interpolated_points = calculateInterpolatedPoints(data, interval)
    % ����Ӿ��ڵ����ף�ÿ���interval m������
    total_length = calculateWellLength(data);
    num_points = total_length / interval;
    % ����һ����������ʾÿ�����ھ��е����
    depths = [0; cumsum(sqrt(sum(diff(data).^2, 2)))];
    % ����һ����������ʾÿ���interval m�����
    interp_depths = (0:interval:depths(end))';
    % ʹ�ò�ֵ��������ÿ���interval m������
    interpolated_points = interp1(depths, data, interp_depths);
end