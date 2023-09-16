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
% points: n * 3, ��ɢ�㣬������ĸ���ɢ�㣬�����β�ֵ�����档��������ĸ�����Ҫ��ϡ����в�ֵ
% interval:  ��ϡ����������ڴ治��
% stepSize: ȷ����������Ĳ���
% type: ��ֵ����ѡ��
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
% ���ݸ�ʽ��xx, yy, zz
% �޳��ظ�������
points = unique(points, 'rows');
tmpArray =  1 : interval : length( points(:, 1) );
tmpLayer = points(tmpArray, :);
xx = tmpLayer(:, 1);    
yy = tmpLayer(:, 2);     
zz = tmpLayer(:, 3);

%ȷ���������꣨x��y����Ĳ�����ȡ0.1��
[X,Y]=meshgrid(min(xx) : stepSize : max(xx), min(yy) : stepSize : max(yy));
%�������λ�ò�ֵ��Z��ע�⣺��ͬ�Ĳ�ֵ�����õ������߹⻬�Ȳ�ͬ
%���һ��Ϊ��ֵ��������linear cubic natural nearest��v4�ȷ���
Z=griddata(xx, yy, zz, X, Y, type);
% [X, Y, Z] = griddata(x, y, z, linspace( min(x), max(x), 30 )', linspace( min(y), max(y), 30 ),'v4');
%��������
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




% %%  �����ز�ṹ
% function s1 = layersurf1(ax1, points, interval, stepSize, type)
% %%
% % interval:  ��ϡ����������ڴ治��
% % stepSize: ȷ����������Ĳ���
% % type: ��ֵ����ѡ��
% if nargin < 5,   type = 'v4';    end
% if nargin < 4,   stepSize = 100;    end
% if nargin < 3,   interval = 10;    end
% %
% % ���ݸ�ʽ��x,y,z
% tmpArray =  1 : interval : length( points(:, 1) );
% tmpLayer = points(tmpArray, :);
% x = tmpLayer(:, 1);
% y = tmpLayer(:, 2);
% z = tmpLayer(:, 3);
% 
% %ȷ���������꣨x��y����Ĳ�����ȡ10��
% [X,Y]=meshgrid(min(x) : stepSize : max(x), min(y) : stepSize : max(y));
% %�������λ�ò�ֵ��Z��ע�⣺��ͬ�Ĳ�ֵ�����õ������߹⻬�Ȳ�ͬ
% %���һ��Ϊ��ֵ���������� linear cubic natural nearest��v4�ȷ���
% Z=griddata(x, y, z, X, Y, type);
% % [X, Y, Z] = griddata(x, y, z, linspace( min(x), max(x), 30 )', linspace( min(y), max(y), 30 ),'v4');
% %��������
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
% % pcolor(X,Y,Z);  shading interp %α��ɫͼ
% % figure,contourf(X,Y,Z) %�ȸ���ͼ
% % figure,surf(X,Y,Z);%��ά����
% % figure,meshc(X,Y,Z)%����ͼ
% 
% % hidden off;
% 
% end
% 





















