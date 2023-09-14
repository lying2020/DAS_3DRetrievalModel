
%
%
%
%
% close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format short
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
%% test_getsensorcoord.m

%% sensor position
position = importdata('sensorposition217.mat');

%%  baseCoord and well Coord.
wellCoordSet = importdata('wellModel4.mat');
baseCoord = [14620550.3 4650200.4 1514.78];
well0 = importdata('wellModel4.mat');

%% -----------------------------------------------------------------------------------------------------
% numSensor = [78, 139];
% lastPoint = 30;
%  [undergroundCoord, overgroundCoord, Posi, Pz] = getposition(well0, position, pathSave)
[undergroundCoord, overgroundCoord, Posi, Pz] = getsensorcoord(well0, position);
%
sensorCoordSet = [overgroundCoord; undergroundCoord];
x = overgroundCoord(:, 1);
y = overgroundCoord(:, 2);
%% 光纤检波器位置
axy = axes(figure);  hold(axy, 'on');
plot(axy, [-31; -42; x], [31; 29; y], 'r', 'linewidth', 1);
h1 = plot(axy, x, y, 'r*', 'linewidth', 2);
%% 电子检波器位置
h2 = plot(axy, Posi(:, 1), Posi(:, 2), 'b.', 'linewidth', 2, 'MarkerSize', 10.0);
xlabel(axy, 'x');   ylabel(axy, 'y');
%% 铁块的位置
h3 = plot(axy, Pz(:, 1), Pz(:, 2), 'b*', 'linewidth', 3);
text(axy, Pz(:, 1)+ 3, Pz(:, 2), 'Pz');
%% 井口的位置
h4 = plot(axy, 0, 0, 'ro', 'linewidth', 2);
text(axy, 3, 0, 'W0');
%% 作业间
h5 = plot(axy, -31, 31, 'bo', 'linewidth', 2);
text(axy, -27, 30, 'H0');
% -----------------------------------------------------------------------------------------------------
xlim(axy, [min(x) - 10, max(x) + 10]);
ylim(axy, [min(y) - 10, max(y) + 10]);
%
%% 标注光纤检波器顶角的位置
for i = [ 7 27 45 66 ]
    text(axy, x(i)+1.0, y(i)-0.5, ['s', num2str(i)]);
end
% -----------------------------------------------------------------------------------------------------
dist1 = computedistance([Pz; Posi(1, :)]);
dist6 = computedistance([Pz; Posi(6, :)]);

velocity = abs(dist1 - dist6)/13;

% sourceCoordSet = [-4.12, -26.33; -5.93, -23.24; -1.4, -21.7];
% h6 = plot(axy, sourceCoordSet(:, 1), sourceCoordSet(:, 2), 'k*', 'linewidth', 2, 'MarkerSize', 4.0);

% legend(axy, [h1, h2, h3, h4, h5, h6], '光纤检波器', '电子检波器', '试验位置', '井口','数据站', '定位位置');
%
% for i = 1:size(sourceCoordSet, 1)
%     n(i) = (norm(sourceCoordSet(i, :) - Pz(1, 1:2)))/norm(Posi(3, :) - Posi(7, :));
% end
%
% err = mean(n)*100;

% title(axy, ['地面定位相对误差：', num2str(err), '%. ']);

% delete([h1, h2, h3, h4, h5, h6]);




