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
% 2020-11-04: do some bug fixes
% some properties of the function axes.     
%  
%% -----------------------------------------------------------------------------------------------------
function axesproperty(ax1, property)
%  
% ax1: the handle of axes in the uiFigure, GUI
% property: the property of axes.   
if nargin < 2
    property.shading = 'interp';    % 'flat'   |  'interp'
    property.lighting = 'flat';         % 'flat' | 'gouraud'  %  % create a light
    property.alpha = 0.5;               % set transparency to 0.8
    property.BoxStyle = 'full';   
    property.box = 'on';
    property.view = [-31, 13];   
    property.grid = 'on';     %    'on'  |  'minor'  %  create a grid line  
    property.axis = 'equal' ; 
    % -----------------------------------------------------------------------------------------------------
    property.xlabel = 'x/ m ';
    property.ylabel = 'y/m';
    property.zlabel = 'z/m';
    %
    property.XColor = 'blue';
    property.YColor = 'blue';
    property.ZColor = 'blue';
    % -----------------------------------------------------------------------------------------------------
    property.XDir = 'reverse';
    property.XAxisLocation = 'origin';   %  'origin'  |  'top';  % 将x轴的位置设置在y=0处。
    property.YAxisLocation = 'origin';   %  'origin'  |  'top';  % 将x轴的位置设置在y=0处。
    property.pbaspect = [1 1 1];  %    doc pbaspect
    property.colormap =  'cool';  %   'cool'  |  'winter' | 'summer'    %  help colormap
end
%  
%% -----------------------------------------------------------------------------------------------------
% cb = colorbar(ax1);
% cb.Label.String = 'layer coloring.';
% cb.Color = [0.49,0.06,0.06];
%  axis(ax1, 'equal');  
% axis(ax1, property.axis);
% shading(ax1, 'interp');  %  'flat'   |  'interp'  % interpolate the colormap across the surface face
shading(ax1, property.shading); 
light(ax1);     % create a light
% lighting(ax1, 'gouraud');   % 'flat' | 'gouraud'  %  % create a light
lighting(ax1, property.lighting);  
% preferred method for lighting curved surfaces
% material dull % set material to be dull, no specular highlight
%
%  alpha(ax1, 0.5)    % set transparency to 0.8, % adjusting for some transparency
alpha(ax1, property.alpha) 
% colormap(ax1, 'cool');  'winter' | 'summer'    %  help colormap
colormap(ax1, property.colormap);
% grid(ax1, 'on');
% grid(ax1,  'minor');
grid(ax1, property.grid);
% view(ax1, -21, 6);
% view(ax1, -24, 10);
% view(ax1, -20, 2);
% view(ax1, -20, 1);
view(ax1,  property.view);
% xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');      zlabel(ax1, 'z /m');
xlabel(ax1, property.xlabel);
ylabel(ax1, property.ylabel);
zlabel(ax1, property.zlabel);
% XColor(ax1, 'blue');     YColor(ax1, 'blue');      ZColor(ax1, 'blue');
ax1.XColor = property.XColor;
ax1.YColor = property.YColor;
ax1.ZColor = property.ZColor;
%
% -----------------------------------------------------------------------------------------------------
% lgd = legend(ax1, 'TextColor', 'blue', 'Location','southeast', 'NumColumns', 2);
% lgd = legend(ax1, 'TextColor', 'blue', 'Location','northoutside', 'Orientation', 'horizontal', 'NumColumns', 2);
% title(lgd,'My Legend Title');
% legend(ax1, 'boxoff');
% -----------------------------------------------------------------------------------------------------
%pbaspect(ax1, [1 1 1])      %  doc pbaspect
% pbaspect(ax1, property.pbaspect);
% XDir(ax1, 'reverse');
% XDir(ax1, property.XDir);
% -----------------------------------------------------------------------------------------------------
% box(ax1, 'on');
box(ax1, property.box);
% ax1.BoxStyle = 'full';
ax1.BoxStyle = property.BoxStyle;
% -----------------------------------------------------------------------------------------------------
%
%  set(gca,'xaxislocation','top');                 % 把x轴换到上方
% ax1.XAxisLocation = property.XAxisLocation;           %将x轴的位置设置在y=0处。
%  set(gca,'ZAxisLocation','origin');           %将y轴的位置设置在x=0处。
% ax1.YAxisLocation = property.YAxisLocation;           %将y轴的位置设置在x=0处。

% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');

%



