%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to  interpolate and refine the discrete points 
%% -----------------------------------------------------------------------------------------------------
function  [X, Y, Z] = pointsinterpolation(points, interval, stepSize, type, ax1)
% -----------------------------------------------------------------------------------------------------
% INPUT: 
% points: n * 3, 离散点，如果是四个离散点，则三次插值成曲面。如果大于四个，需要抽稀后进行插值
% interval:  抽稀间隔，以免内存不够
% stepSize: 确定网格坐标的步长
% type: 插值方法选择
% 
% OUTPUT:
% X, Y, Z: the x, y, z grid point coordinates after interpolation.
%
% ex: % points= [0 0 0; 4 4 4; 0 4 4; 8 0 0 ];
%% -----------------------------------------------------------------------------------------------------
% some default parameters.
if nargin < 4,   type = 'cubic';    end
if nargin < 3,   stepSize = 1;    end
if nargin < 2,   interval = 1;    end
% -----------------------------------------------------------------------------------------------------
% 数据格式：xx, yy, zz
% 剔除重复坐标行
points = unique(points, 'rows');
tmpArray =  1 : interval : length( points(:, 1) );
tmpLayer = points(tmpArray, :);
xx = tmpLayer(:, 1);    
yy = tmpLayer(:, 2);     
zz = tmpLayer(:, 3);

%确定网格坐标（x和y方向的步长均取0.1）
[X,Y]=meshgrid(min(xx) : stepSize : max(xx), min(yy) : stepSize : max(yy));
%在网格点位置插值求Z，注意：不同的插值方法得到的曲线光滑度不同
%最后一个为插值方法，包linear cubic natural nearest和v4等方法
Z=griddata(xx, yy, zz, X, Y, type);
% [X, Y, Z] = griddata(x, y, z, linspace( min(x), max(x), 30 )', linspace( min(y), max(y), 30 ),'v4');
%绘制曲面
%% -----------------------------------------------------------------------------------------------------
% Draw the curved surface             
if nargin > 4
    % p1 = plot3(ax1, x, y, z, 'or', 'MarkerFaceColor', 'r');
    % set(get(get(p1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    hold(ax1, 'on');
    s1 = surf(ax1, X, Y, Z, Z);
    plot3(ax1, points(:, 1), points(:, 2), points(:, 3), 'r*');
    shading(ax1, 'interp');
    %  colormap(jet);
    % view(0, 90);
    colorbar(ax1);
    % print(gcf, '-djpeg', 'xyz.jpg'); % save picture
    alpha(ax1, 0.8) % set transparency to 0.8
    
end
% 
% 
% 
end




% %%  画出地层结构
% function s1 = layersurf1(ax1, points, interval, stepSize, type)
% %%
% % interval:  抽稀间隔，以免内存不够
% % stepSize: 确定网格坐标的步长
% % type: 插值方法选择
% if nargin < 5,   type = 'v4';    end
% if nargin < 4,   stepSize = 100;    end
% if nargin < 3,   interval = 10;    end
% %
% % 数据格式：x,y,z
% tmpArray =  1 : interval : length( points(:, 1) );
% tmpLayer = points(tmpArray, :);
% x = tmpLayer(:, 1);
% y = tmpLayer(:, 2);
% z = tmpLayer(:, 3);
% 
% %确定网格坐标（x和y方向的步长均取10）
% [X,Y]=meshgrid(min(x) : stepSize : max(x), min(y) : stepSize : max(y));
% %在网格点位置插值求Z，注意：不同的插值方法得到的曲线光滑度不同
% %最后一个为插值方法，包括 linear cubic natural nearest和v4等方法
% Z=griddata(x, y, z, X, Y, type);
% % [X, Y, Z] = griddata(x, y, z, linspace( min(x), max(x), 30 )', linspace( min(y), max(y), 30 ),'v4');
% %绘制曲面
% %   hold(ax1, 'on');
% % surf(ax1, X,Y,Z);
% %  a = gradient(Z)
% % p1 = plot3(ax1, x, y, z, 'or', 'MarkerFaceColor', 'r');
% % set(get(get(p1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
% s1 = surf(ax1, X, Y, Z, Z);
% set(get(get(s1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
% % shading(ax1, 'interp');
% %  colormap(jet);
% % view(0, 90);
% % colorbar;
% % print(gcf, '-djpeg', 'xyz.jpg'); % save picture
% %  alpha(ax1, 0.8) % set transparency to 0.8
% 
% % pcolor(X,Y,Z);  shading interp %伪彩色图
% % figure,contourf(X,Y,Z) %等高线图
% % figure,surf(X,Y,Z);%三维曲面
% % figure,meshc(X,Y,Z)%剖面图
% 
% % hidden off;
% 
% end
% 





















