%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% 2020-11-06: debug. 
% this code is used to draw a 3D surface structure.
%% -----------------------------------------------------------------------------------------------------
function ss = layersurf(ax1, xMat, yMat, zMat)
% -----------------------------------------------------------------------------------------------------
% %  get a surf graph.  
% ax1: the handle of axes in the uiFigure, GUI
% xMat, yMat, zMat: m*n matrix, 
% 
% hold(ax1, 'on');
%% color.  
co = abs(xMat)/max(max(abs(xMat))) ... 
     + abs(yMat)/max(max(abs(yMat))) ... 
     + abs(zMat)/max(max(abs(zMat)));
% co = zMat.*zMat;     
ss = surf(ax1, xMat, yMat, zMat, co);
%  ss = surf(ax1, xMat, yMat, zMat, 'FaceAlpha', 0.5);
% contourf(ax1, xMat, yMat, zMat) %等高线图
% meshc(ax1, xMat, yMat, zMat)%剖面图
%  a =  gradient(zMat)*1.2;  %0.5;   %
%  alpha(ax1, a) % set transparency to 0.8
%
% colormap(ax1, 'jet');   %  'winter' | 'summer'  | 'jet' | 'hot' | 'cool'   %  help colormap
shading(ax1, 'interp');
% shading(ax1, 'faceted');     %  'flat'   |  'interp'  % interpolate the colormap across the surface face
% hidden(ax1, 'off');
% axis(ax1, 'equal');
cb = colorbar(ax1);
cb.Label.String = 'layer coloring.';
cb.Color = [0.49,0.06,0.06];
grid(ax1, 'on');
alpha(ax1, 0.5) % set transparency to 0.8, % adjusting for some transparency
%
view(ax1, [1,1,1]);
% view(ax1, -24, 10);
% view(ax1, -20, 2);
% view(ax1, -20, 1);
% view(ax1, 10, 13);
xlabel(ax1, 'x');  ylabel(ax1, 'y');  zlabel(ax1, 'z');% naming the axis
%
% Making the 3D graph of the 0-level surface of the 4D function "fun":
% h = patch(isosurface(x,y,z,fvalues,0)); % "patch" handles the structure...
%                                         % sent by "isosurface"
% isonormals(x,y,z,fvalues,h)% Recalculating the isosurface normals based...
%                            % on the volume data
% set(h,'FaceColor',color,'EdgeColor','none');
% surfproperty(ss);
%% -----------------------------------------------------------------------------------------------------
%  ss = surf(ax1, X, Y, Z, 'FaceAlpha', 0.5);
%  FaceAlpha — Face transparency,  specified as 1 (default) | scalar in range [0,1] | 'flat' | 'interp' | 'texturemap'
ss.FaceAlpha = 0.5;   %  interpolate to get face transparencies
% FaceLighting — Effect of light objects on faces   % 光源对象对面的影响
ss.FaceLighting = 'none';    %  'flat' (default) | 'gouraud' | 'none'
%  FaceColor — Face color,  specified as 'flat' (default) | 'interp' | 'none' | 'texturemap' | RGB triplet | hexadecimal color code | 'r' | 'g' | 'b' | ...
ss.FaceColor = 'flat';  %  'none' | 'flat' |  'interp'   % interpolate to get face colors
%
% MeshStyle — Edges to display,  specified as 'both' (default) | 'row' | 'column'
ss.MeshStyle = 'both';
% EdgeColor — Edge line color,  specified as [0 0 0] (default) | 'none' | 'flat' | 'interp' | RGB triplet | hexadecimal color code | 'r' | 'g' | 'b' | ...
ss.EdgeColor = 'none';
% EdgeAlpha — Edge transparency, specified as 1 (default) | scalar value in range[0,1] | 'flat' | 'interp'
ss.EdgeAlpha = 0.8;
%
% AlignVertexCenters — Sharp vertical and horizontal lines, specified as 'off' (default) | 'on'
ss.AlignVertexCenters = 'off';
%
ss.CData = hypot(xMat, yMat); % set color data
ss.AlphaData = gradient(zMat); % set vertex transparencies
%
%  ss.CDataMapping = 'direct';
% -----------------------------------------------------------------------------------------------------



end





