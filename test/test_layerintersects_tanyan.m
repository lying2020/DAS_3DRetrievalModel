
%
%
%
%
% close all;
clear
%clear points intersection
%%  -----------------------------------------------------------
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
%
[fileName, pathName] = uigetfile({'*.*'; '*.txt'; '*.mat'}, ' Select the TXT-file ',  'MultiSelect', 'on');
% 
tic 
if  isa(fileName, 'numeric'), return;  end
%
filenameList = fullfile(pathName, fileName);
%
if isa(filenameList, 'char')
    tmp{1, 1} = filenameList;
    filenameList = tmp;
end
num = length(filenameList);
type = 'layer';
layerCoeffModel = cell(num, 1);
%% --------------------------------------------
sp =  [14621234 4650653 2000; 14619460 4650140 -110;   14619580 4650100 2030; 14619460,4650100,-2110; 14619460 4650140 -2110; 14619430 4650140 -2000; 14620022 4650108 1200; 14619240 4650620 -800];  %
ep =   [14619869 4649742 -2990; 14619070 4649700 -2300; 14619000 4649720 -7250; 14619100,4649720,-2340; 14619170 4649700 -2300; 14618920 4649740 -2300];
n = 3;
startpoint = sp(n, :);
endpoint = ep(n, :);
inter = 10;
se = [startpoint; endpoint] - startpoint;
% filenameList is a cell array

ax1 = axes(figure);  hold(ax1, 'on');
scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'filled');
plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 4.5);
%
for iFile = 1:num
    layerdata{iFile} = readtxtdata(filenameList{iFile}, type);
end
    baseCoord =  startpoint;
%layerGridModel = grid_tanyan(layerdata,baseCoord,inter,150,300);
layerGridModel = grid_tanyan(layerdata,baseCoord,inter,20,20); % new data
for iFile = 1:num   
    x = layerGridModel{iFile,1};
    y = layerGridModel{iFile,2};
    z = layerGridModel{iFile,3};
    layersurf(ax1, x, y, z);
    % shading(ax1, 'faceted');
end
endpoint = endpoint - startpoint;
startpoint = [0 0 0];
[layerCoeffModel, layerCoeffModel_zdomain] = fitting_tanyan(layerGridModel);
%%  ----------------------------------
% # test 1
for k =1:100
    for s = 1:10
        ep = endpoint - [20*k 10*k -1000*s];
        % ep = endpoint - [96 48 -2000]; iLayer = 8;  这里直线从拟合多项式之间的缝隙中穿过了。
        [intersection, idxLayer, points]  = layerintersects_tanyan(layerCoeffModel,layerCoeffModel_zdomain,layerGridModel, startpoint, ep);
        markintersection{k,s} = intersection;
        markidxLayer{k,s} = idxLayer;
    end
end
if ~isempty(intersection)
    scatter3(ax1, intersection(:, 1), intersection(:, 2), intersection(:, 3), 100, 'filled');
end
xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');

%% -------------------------------------------------------------------------------------
% # test 2
ax1 = axes(figure);  hold(ax1, 'on');
for iP4 = 1:length(points)
    tmp = points{iP4};
%     interpolation(tmp, 1, 0.1, 'linear', ax1);
    plot3(ax1, [tmp(:, 1); tmp(1, 1)], [tmp(:, 2); tmp(1, 2)], [tmp(:, 3); tmp(1, 3)], 'r-', 'linewidth', 1.1);
    patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), abs(tmp(:, 3))/norm(tmp(:, 3)));
    scatter3(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), 20, 'MarkerFaceColor', [0 0 0]);
    % 测试四点是否在直线不同侧
    for jTmp = 1: size(tmp, 1)
        st = [startpoint; tmp(jTmp, :)];
        plot3(ax1, st(:, 1), st(:, 2), st(:, 3), 'b-');
    end
    %          tmp_p4{iP4} = test_tmp(tmp, startpoint, endpoint);
    
    %         patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), [0 0.1 0.9],'EdgeColor','interp','Marker','o','MarkerFaceColor','flat');
    %         colorbar(ax1);
    %      iP4
end
scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'filled');
plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 2.5);
if ~isempty(intersection)
    scatter3(ax1, intersection(:, 1), intersection(:, 2), intersection(:, 3), 20, 'filled');
end
xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');





toc
