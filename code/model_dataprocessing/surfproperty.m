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
% some properties of the surf diagram   
%  
%% -----------------------------------------------------------------------------------------------------
function surfproperty(ss)
% -----------------------------------------------------------------------------------------------------
%  ss = surf(ax1, X, Y, Z, 'FaceAlpha', 0.5);
% ss: surf function handle. 

%  FaceAlpha — Face transparency,  specified as 1 (default) | scalar in range [0,1] | 'flat' | 'interp' | 'texturemap'
ss.FaceAlpha = 0.5;   %  interpolate to get face transparencies
% FaceLighting — Effect of light objects on faces   % 光源对象对面的影响
 ss.FaceLighting = 'none';    %  'flat' (default) | 'gouraud' | 'none'
%  FaceColor — Face color,  specified as 'flat' (default) | 'interp' | 'none' | 'texturemap' | RGB triplet | hexadecimal color code | 'r' | 'g' | 'b' | ...
ss.FaceColor = 'flat';  %  'none' | 'flat' |  'interp'   % interpolate to get face colors
%
% MeshStyle — Edges to display,  specified as 'both' (default) | 'row' | 'column'
ss.MeshStyle = 'flat';
% EdgeColor — Edge line color,  specified as [0 0 0] (default) | 'none' | 'flat' | 'interp' | RGB triplet | hexadecimal color code | 'r' | 'g' | 'b' | ...
ss.EdgeColor = 'none';  
% EdgeAlpha — Edge transparency, specified as 1 (default) | scalar value in range[0,1] | 'flat' | 'interp'
ss.EdgeAlpha = 0.8;
%
% AlignVertexCenters — Sharp vertical and horizontal lines, specified as 'off' (default) | 'on'
ss.AlignVertexCenters = 'off';
%
ss.CData = hypot(x, y); % set color data
ss.AlphaData = gradient(z); % set vertex transparencies
%
%  ss.CDataMapping = 'direct';
% -----------------------------------------------------------------------------------------------------



end