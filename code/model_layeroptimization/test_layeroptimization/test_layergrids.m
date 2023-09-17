
%
%
%
% close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
%
baseCoord = [14620550.3 4650200.4 1514.78];
%% --------------------------------------------
sp =  [14621234 4650653 -2000.00; 14619460 4650140 -110;   14619580 4650100 -2130; 14619460,4650100,-2110; 14619460 4650140 -2110; 14619430 4650140 -2000; 14620022 4650108 1200; 14619240 4650620 -800];  %
ep =   [14619869 4649742 -2990; 14618970 4649700 -2300; 14618900 4649720 -2250; 14618900,4649720,-2340; 14618870 4649700 -2300; 14618920 4649740 -2300];
%% --------------------------------------------
n = 1;
startpoint = sp(n, :);
endpoint = ep(n, :);
% baseCoord = startpoint; % [14621234 4650653 2000];
se = [startpoint; endpoint] - baseCoord;
%
fittingType = 'nonlinear';  
[baseCoord, layerCoeffModel, layerGridModel, ax1] = test_first(baseCoord, fittingType);
num = size(layerGridModel, 1);
%
%% --------------------------------------------
% ax1 = axes(figure);  
hold(ax1, 'on');
scatter3(ax1, se(:, 1), se(:, 2), se(:, 3), 50, 'filled');
plot3(ax1, se(:, 1), se(:, 2), se(:, 3), 'b-', 'linewidth', 1.5);
%
% ax1 = axes(figure);   hold(ax1, 'on');
for iFile = 1:num
     [xMat, yMat, zMat] = layerGridModel{iFile, 1:3};
%%
    p4 =  computelayerintersectsgrids(xMat, yMat, zMat, se(1, :), se(2, :));
%     p4 = points4(x, y, z, startpoint, endpoint);
%% -----------------------------------
    for iP4 = 1:length(p4)
        tmp = p4{iP4, 1};
        plot3(ax1, [tmp(:, 1); tmp(1, 1)], [tmp(:, 2); tmp(1, 2)], [tmp(:, 3); tmp(1, 3)], 'r-', 'linewidth', 1.5);
        patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), abs(tmp(:, 3))/norm(tmp(:, 3)));
        scatter3(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), 20, 'MarkerFaceColor', [0 0 0]);
        % 测试四点是否在直线不同侧
        for jTmp = 1: size(tmp, 1)
            st = [se(1, :); tmp(jTmp, :)];             
            plot3(ax1, st(:, 1), st(:, 2), st(:, 3), 'b-');
        end      
         tmp_p4{iP4} = test4(tmp, se(1, :), se(2, :));
         
%         patch(ax1, tmp(:, 1), tmp(:, 2), tmp(:, 3), [0 0.1 0.9],'EdgeColor','interp','Marker','o','MarkerFaceColor','flat');
%         colorbar(ax1);
%      iP4
    end   
%      iFile
%    surf(ax1, xMat, yMat, zMat, zMat.*zMat);
end
xlabel(ax1, 'x /m');   ylabel(ax1, 'y /m');  zlabel(ax1, 'z /m');
% ax2 = axes(figure(3));
% sourceplot3D(ax2, layerGridModel, [], [], []);

% [14620060,4650170,-2059.63989300000;14620060,4650180,-2058.23974600000;14620070,4650180,-2056.83032200000;14620070,4650170,-2055.51513700000]

% 
% type = 'velocity';
% [x, y, z, v, xTimes, yTimes] = layerdatatransform(velocityData, type);
% disp('GOOD JOB !!!');
% 
% deltaX = max(velocityData(:, 4:6)) - min(velocityData(:, 4:6));
% deltaV = 304800 / min(velocityData(:, 7)) - 304800 / max(velocityData(:, 7));

function p4 = test4(tmp, sp, ep)

x = [tmp(1, 1) tmp(2, 1); tmp(4, 1), tmp(3, 1)];
y = [tmp(1, 2) tmp(2, 2); tmp(4, 2), tmp(3, 2)];
z = [tmp(1, 3) tmp(2, 3); tmp(4, 3), tmp(3, 3)];
p4 = computelayerintersectsgrids(x, y, z, sp, ep);
% 
f5 = figure;
ax5 = axes(f5);  hold(ax5, 'on');
se = [ep; sp];
scatter3(ax5, se(:, 1), se(:, 2), se(:, 3), 40, 'filled');
plot3(ax5, se(:, 1), se(:, 2), se(:, 3), 'r', 'linewidth', 2);

plot3(ax5, tmp(:, 1), tmp(:, 2), tmp(:, 3), 'r-', 'linewidth', 1.5);
patch(ax5, tmp(:, 1), tmp(:, 2), tmp(:, 3), abs(tmp(:, 3))/norm(tmp(:, 3)));
scatter3(ax5, tmp(:, 1), tmp(:, 2), tmp(:, 3), 20, 'MarkerFaceColor', [0 0 0]);

end




