%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% This code is used to plot 3d diagram of strain-time-position
%% -----------------------------------------------------------------------------------------------------
function [h1, h2, tfg] = plot3D(ax1, strainMat, position, time, window, picType)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% ax1: axes handle ion the user interface figure window
% strainMat: nsensor* nmeasure matrix, ns ensor sensors, and n measure
%                   strainMat is the original signal, microstrain value of selected sensor
% position: nsensor* 1 matrix, position of nsensor selected sensors;
% time: 1* nmeasure matrix, nmeasure measures(sampling data), discrete time,  unit: ms
% window: nsensor* mwindows, nsensor sensors, mwindows time windows,
%                that means mwindows seismic events
% picType: pic type, a string, 'plot' | 'surf' | 'mesh' | 'waterfall'
% pathSave: 3D figure save path
% 
% OUTPUT:
% tfg: total time cost flag
%
tic
%% -----------------------------------------------------------------------------------------------------
%  3D drawing with strain matrix
% some default parameters set.
if ~ishandle(ax1),  ax1 = axes(uifigure);  end
if nargin< 6,  picType = 'plot3';  end
 strArray = {'plot3',   'surf' , 'mesh',  'waterfall'}; 
% % 更改输出图类型: plotType = 1 | 2 | 3 | 4  ---->  'plot3'  | 'surf' | 'mesh' |  'waterfall'
% plotType = 1;
% str =strArray{plotType};
if ~any(contains(strArray, picType)),  picType = 'plot3';  end

if nargin< 5,  window = [];  end 
if length(strainMat) < 2, warning('plot3D: NO OUTPUT !!! ');  return;  end     
[lenPosition, lenTime] = size(strainMat);   
if nargin < 4, time = (1:lenTime)*0.064;  end  
if isempty(time), time = (1:lenTime)*0.064;  end  
if nargin < 3, position = (1: lenPosition)';  end  
if isempty(position), position = (1: lenPosition)';  end  
if size(position, 2)>1, position = position';   end  
%            
[h1, h2] = deal(plot([]));
%
hold(ax1, 'on');
%% -----------------------------------------------------------------------------------------------------
%
time = time - time(1)* 2 + time(2);
[po, ti] = meshgrid(position, time);
% fnc=str2func(picType);
% fnc(ti, po, strainMat); %, 'color', [0 1 1]);
%%       
switch picType
    case 'plot3'
        h1 = plot3(ax1, ti, po, strainMat, 'Color', [0.3010 0.7450 0.9330]); 
        % s.LineWidth = 2;
        % -----------------------------------------------------------------------------------------------------
        % if ~isempty(window)
        % mark time windows
        % 3D  
        %  mInterval = 5.0 / mean( (time(11:15) - time(6:10)) );
                [tw1, tw2] = size(window);
                for i = 1:tw1
                    for j = 1: tw2
                        twEnd = 0;  % min(floor(310 * mInterval), length(time) - window(i, j));
                        %  twP = repmat(position, twEnd+1, 1);
                        %  twT =  time(window(:, j):(window(:, j) + twEnd));
                        %  plot3(ax1, twT, twP, strainMat(:, window(:, j):(window(:, j) + twEnd)),  'r', 'LineWidth', 1.1);
                        [twP, twT ] = meshgrid(position,  time(window(i, j):(window(i, j) + twEnd)));
                        %                 plot3(ax1, twT(:, i), twP(:, i), strainMat(i, window(i, j):(window(i, j) + twEnd)),  'r*', 'LineWidth', 2.1);
                        h2 = plot3(ax1, twT(:, i), twP(:, i), strainMat(i, window(i, j):(window(i, j) + twEnd)),  'r.', 'MarkerSize', 8.1);
                        %    h2 = scatter3(ax1, twT(:, i), twP(:, i), strainMat(i, window(i, j):(window(i, j) + twEnd)), 'filled');
                    end
                end
%         end
        %         view (ax1, 7, 13);  % view(77, 31);
        view(ax1,[62.104 30.676073933044]);
        % -----------------------------------------------------------------------------------------------------
    case 'waterfall'
        po = position;  ti = time;
        h1 = waterfall(ax1, ti, po, strainMat);
%         cb = colorbar(ax1);
%         cb.Label.String = 'Strain distribution at different time and positions';
       view(ax1, 77, 31);  %  view (ax1, 4, 13);  % 
        % view(ax1, 10, 27);  %  view(ax1, 37.5,30);  % view(ax1, 63, 62);
    case 'mesh'
        h1 = mesh(ax1, ti, po, strainMat', 'FaceLighting','gouraud');
        view(ax1, 9, 12); % view(-12, 7);
        hidden(ax1, 'off');
    case 'surf'
        h1 = surf(ax1, ti, po, strainMat', 'FaceColor',  'interp');
        view(ax1, 10, 13);
        %
        shading(ax1, 'interp'); % interpolate the colormap across the surface face
        %             shading flat
        %             light % create a light-
        %             lighting flat
        %             lighting gouraud % preferred method for lighting curved surfaces
        %              material dull % set material to be dull, no specular highlight
        alpha(ax1, 0.5) % set transparency to 0.8
        %             s.CData = hypot(ti, po); % set color data
        %             s.FaceColor = 'interp'; % interpolate to get face colors
        %             s.AlphaData = gradient(strainMat); % set vertex transparencies
        %             s.FaceAlpha = 'interp'; % interpolate to get face transparencies
    otherwise
        hr5 = errordlg(' Error 3D function name ! ', 'Invalid name');
        pause(4);
        if ishghandle(hr5 ), close(hr5);  end
        return;
end
if any(contains({'surf', 'mesh'}, picType))
        cb = colorbar(ax1);
        cb.Label.String = 'Strain distribution at different time and positions';
end
% if ~isempty(window)
%     sm = (window - 1)*lenPosition + position;
%     h2 = plot3(ax1, time(window), position, strainMat(sm), 'r.', 'MarkerSize', 4.1);
% end
%% -----------------------------------------------------------------------------------------------------
% box(ax1, 'on');
%             ax1.Box = 'on';
%           ax1.BoxStyle = 'full';
%             xmin = ti(1) - 0.01* (ti(end) - ti(1));
%             xmax = ti(end) + 0.01* (ti(end) - ti(1));
%             ymin = po(1) - 0.01* (po(end) - po(1));
%             ymax = po(end) + 0.01* (po(end) - po(1));
%             zmin = min(min(sM)) - 0.01*(max(max(sM)) - min(min(sM)));
%             zmax =  max(max(sM)) + 0.01*(max(max(sM)) - min(min(sM)));
%             axis(ax1, [xmin, xmax, ymin, ymax, zmin, zmax]);

ax1.XTickMode = 'auto';
ax1.YTickMode = 'auto';
title(ax1, ['the diagram of time - position - strain with ', num2str(lenPosition), ' sensors']);
%   title(ax1, ' 3D  strainMat  data !!!')
xlabel(ax1, 'time/ms');
ylabel(ax1, 'position/m');
zlabel(ax1, 'strain');
%% -----------------------------------------------------------------------------------------------------
% strVarName1 = sprintf('%s', inputname(1));
% strVarName2 = sprintf('%s', inputname(2));
% strVarName3 = sprintf('%s', inputname(3));
% % title([strVarName3, ' - ', strVarName1, ' with ' , int2str(nPosition), 'sensor']);
% title(ax1, [strVarName3, ' - ', strVarName2, ' - ', strVarName1]);
%
% %  xlabel('time/ms');  ylabel('position/m');   zlabel('strain');  %  title('time-strain');
% if (nPosition == length(position)) && (nTime == length(time))
%     strVarName3 = [strVarName3, '/ms' ];
%     strVarName2 = [strVarName2, '/m' ];
% end
% xlabel( ax1, strVarName3);
% ylabel(ax1,  strVarName2);
% zlabel(ax1,  strVarName1);
%% -----------------------------------------------------------------------------------------------------
% if nargin > 6
%     % set(pic,'color',[1,1,1]) % 背景色设置为白色
%     info1 = ['pic3D', picType, num2str(nPosition), '.png'];
%     saveas(gca, [pathSave, filesep, info1]);  % gcf(get current figure)
% end

tfg = toc;
% info = ['# the cost of plot 3D graph of strain-position-time with func ',  picType, ' is: ', num2str(tfg), ' s.' ];
% disp(info);

end








