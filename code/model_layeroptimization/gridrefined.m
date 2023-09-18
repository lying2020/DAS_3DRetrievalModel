%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to  interpolate and refine the discrete mesh points 
%% -----------------------------------------------------------------------------------------------------
function [xMat2, yMat2, zMat2] = gridrefined(xMat, yMat, zMat, stepSize, gridType, retraction_distance)
% -----------------------------------------------------------------------------------------------------
% INPUT: 
% xMat, yMat, zMat:  n *m, x, y z coordinates of the grid point. 
% stepSize: the spacing step of the interpolation
% gridType: interpolation type 
% gridType = 'linear'  | 'nearest'  |  'natural' | 'cubic' | 'v4'
% retraction_distance: x,y 向内收缩的距离，使得插值范围内都有插值结果
% x and y shrink inward so that there are interpolation results within the interpolation range. 
% 
% OUTPUT:
% X, Y, Z: the x, y, z grid point coordinates after interpolation.
%
%  DEBUG ! ! !
dbstop if error;

func_name = mfilename;
displaytimelog(['func: ', func_name]);
%% -----------------------------------------------------------------------------------------------------
if nargin < 6, retraction_distance = [10, 10]; end
if nargin < 4,   stepSize = [20 20];    end
if nargin < 5,  gridType = 'linear';   end
if length(stepSize) == 1
    stepSize = [stepSize , stepSize];
end
% -----------------------------------------------------------------------------------------------------
stepSize = max(1, stepSize);
% 
griddata_method = {'linear', 'nearest', 'natural', 'cubic', 'v4'};
scatter_method = {'linear', 'nearest', 'natural'};

%% scatteredInterpolant Mesh refinement interpolation function
if any(strcmp(scatter_method, gridType))
    %%  Interpolate the rows
    % row and column.
    [nrow_xMat, ncol_xMat] = size(xMat);
    displaytimelog(['func: ', func_name, '. ', 'size(xMat): ', num2str(size(xMat))]);
    % 1st row, 1st column, and the end row, ascending order.
    xSeq0 = xMat(:, 1);
    x_interp_num = 1+ ceil(abs(xSeq0(2: nrow_xMat) - xSeq0(1: nrow_xMat-1))/stepSize(1));
    % m-2 overlap points.
    x_total_points_num = sum(x_interp_num) - (nrow_xMat-2);
    displaytimelog(['func: ', func_name, '. ', 'stepSize(1): ', num2str(stepSize(1)), ', x_interp_num: ', num2str(sum(x_interp_num)), ', x_total_points_num: ', num2str(x_total_points_num)]);
    [xMat1, yMat1] = deal(zeros(x_total_points_num, ncol_xMat) );
    [xArray1, yArray1] = deal(zeros(x_total_points_num, 1));
    %
    for icol = 1: ncol_xMat
        xSeq1 = xMat(:, icol);    ySeq1 = yMat(:, icol);
        row_begin = 1; row_end = x_interp_num(1);
        for irow = 1 : nrow_xMat-1
            xArray1(row_begin : row_end) = linspace(xSeq1(irow), xSeq1(irow+1), x_interp_num(irow));
            yArray1(row_begin : row_end) = linspace(ySeq1(irow), ySeq1(irow+1), x_interp_num(irow));
            row_begin = row_end;
            if irow < nrow_xMat-1,  row_end = row_end +x_interp_num(irow+1)-1; end
        end
        xMat1(:, icol) = unique(xArray1, 'stable');   yMat1(:, icol) = unique(yArray1, 'stable');
    end
 
    [nrow_yMat1, ncol_yMat1] = size(yMat1);
    displaytimelog(['func: ', func_name, '. ', 'size(yMat1): ', num2str(size(yMat1))]);
    %% Interpolate the columns
    ySeq00 = yMat(1, :);
    y_interp_num  = 1+ ceil(abs(ySeq00(2: ncol_xMat) - ySeq00(1:ncol_xMat-1))/stepSize(2));
    y_total_points_num = sum(y_interp_num) - (ncol_yMat1 - 2);
    % n-2 overlap points.
    displaytimelog(['func: ', func_name, '. ', 'stepSize(2): ', num2str(stepSize(2)), ', y_interp_num: ', num2str(sum(y_interp_num)), ', y_total_points_num: ', num2str(y_total_points_num)]);
    [xMat2, yMat2] = deal(zeros(nrow_yMat1, y_total_points_num));
    [xArray2, yArray2] = deal(zeros(1, y_total_points_num));
    %
    for irow = 1: nrow_yMat1
        xSeq2 = xMat1(irow, :);    ySeq2 = yMat1(irow, :);
        col_begin = 1; col_end = y_interp_num(1);
        for icol = 1:ncol_yMat1-1
            xArray2(col_begin : col_end) = linspace(xSeq2(icol), xSeq2(icol+1), y_interp_num(icol));
            yArray2(col_begin : col_end) = linspace(ySeq2(icol), ySeq2(icol+1), y_interp_num(icol));
            col_begin = col_end;
             if icol < ncol_yMat1-1,  col_end = col_end + y_interp_num(icol + 1)-1;  end
        end
        xMat2(irow, :) = unique(xArray2, 'stable');   yMat2(irow, :) = unique(yArray2, 'stable');
    end
    [m2, n2] = size(xMat2);
    displaytimelog(['func: ', func_name, '. ', 'size(xMat2): ', num2str(size(xMat2))]);
    Func = scatteredInterpolant(xMat(:), yMat(:), zMat(:), gridType);
    vq = Func(xMat2(:), yMat2(:));
    zMat2 = reshape(vq, m2, n2);

elseif any(strcmp(griddata_method, gridType))
        % Compute xMat and yMat with griddata  interpolation function
        x_range = (min(xMat(:)) + retraction_distance(1)) : stepSize(1) : (max(xMat(:)) - retraction_distance(1));
        y_range = (min(yMat(:)) + retraction_distance(2)) : stepSize(2) : (max(yMat(:)) - retraction_distance(2));
        [xMat2,yMat2]=meshgrid(x_range,  y_range);
        % %在网格点位置插值求Z，注意：不同的插值方法得到的曲线光滑度不同
        % %最后一个为插值方法，包linear cubic natural nearest和v4等方法
        zMat2 = griddata(xMat(:), yMat(:), zMat(:), xMat2, yMat2, gridType);
        % [xMat2, yMat2, zMat2] = griddata(xMat(:), yMat(:), zMat(:), x_range, y_range, 'v4');
else
    warning('gridrefined function: error gridType input. !!!!!');
    xMat2 = xMat; yMat2 = yMat; zMat2 = zMat;
end

end

% 
% 用于创建
% 
% meshgrid	
% 二维和三维空间中的矩形网格
% 
% griddata	
% 散点数据插值
% 
% griddedInterpolant	
% 网格数据插值
% 
% scatteredInterpolant	
% 散点数据插值
% 












