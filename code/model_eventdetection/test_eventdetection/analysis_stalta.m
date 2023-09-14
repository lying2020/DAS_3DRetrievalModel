%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-07-14: sta-lta and AIC method
% 2020-10-29: Modify the description and comments
%
%% -----------------------------------------------------------------------------------------------------
% function [seismicEventIdx, value] = analysis_sta_lta(strainMat, sta, lta, threshold)
function analysis_stalta(strainMat, pathSave)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% time: discrete time, the time unit is ms
% position: value of selected position
% strainMat:the original signal, microstrain value
%
% OUTPUT:
% threhold: the threshold at which the seismic signal is triggered
% -----------------------------------------------------------------------------------------------------
tic
if nargin < 1, strainMat = importdata('strainMat217.mat');  end
%
% [lenPosition, lenTime] = size(strainMat);
% % Compare the effects of different time window lengths
lenSta = [100; 300; 500];
% lenSta = [200 400];
% lenSta = 300;
lenLta = [2000 4000 6000 8000];
%
[staRow, staCol] = size(lenSta);
nLta = length(lenLta);
%
xx = 1;
%
for st1 = 1:staRow
    figure;
    for st2 = 1:staCol
        subplot(nLta + 1, staCol, st2)
        plot(strainMat(xx, :));  ylabel('strain');
        title(['sta-lta ratio analysis with', ' sta = ', num2str(lenSta(st1, st2)), '.']);
        for lt = 1:nLta
            %  signalextending:
            extMat1 = signalextending(strainMat, lenLta(lt));
            extMat2 = signalextending(strainMat, lenSta(st1, st2));
            strainMatExt = [extMat1 strainMat extMat2];
            % -----------------------------------------------------------------------------------------------------
            % the 1th sta and lta time windows value, we will get ratio recursively.
            sta0 = characteristicfunc(strainMatExt(:, (lenLta(lt) - lenSta(st1, st2) + 1) : (lenLta(lt) + 1)))/lenSta(st1, st2);
            lta0 = characteristicfunc(strainMatExt(:, 1:(lenLta(lt) + 1)))/lenLta(lt);
            ratio = sta0./lta0;
            ratioMat = staltaloop(strainMatExt, lenSta(st1, st2), lenLta(lt), sta0, lta0);
            ratioMat(:, 1) = ratio;
            %% -----------------------------------------------------------------------------------------------------
            subplot(nLta + 1, staCol, lt*staCol + st2);
            plot(ratioMat(xx, :));
            ylabel('sta-lta ratio');  legend(['lta = ', num2str(lenLta(lt))]);
        end
    end
    
    if nargin > 1
        % set(pic,'color',[1,1,1]) % 背景色设置为白色
        info = ['sta', num2str(lenSta(st1, st2)), '.png'];
        saveas(gca,[pathSave, info]);  % gcf(get current figure)
    end
end

% compare the effect of different sta-lta function
ns = 200; nl =  4000;
ratioMat1 = staltaloop(strainMatExt, ns, nl, sta0, lta0);
ratioMat2 = staltaloop1(strainMatExt, ns, nl, sta0, lta0);
%
n = min(2, size(strainMat, 1));
arr = [1, size(strainMat, 1)];
figure;
for j = 1:n
    subplot(3, n, j);
    plot(strainMat(arr(j), :));
    ylabel('strain');
    title(['the ', num2str(j),'th sensor: sta = ', num2str(ns), ', lta = ', num2str(nl)]);
    subplot(3, n, n + j);
    plot(ratioMat1(arr(j), :));
    ylabel('sta-lta');    % ylim([0 (1 + max(ratioMat1(arr(j))))]);
    subplot(3, n, 2*n + j);
    plot(ratioMat2(arr(j), :));  % ylim([0 (1 + max(ratioMat1(arr(j), :)))]);
    ylabel('sta-lta1');
end

tt2 = toc;
info = ['# the cost of sta-lta analysis is: ', num2str(tt2), ' s.' ];
disp(info);
end

% function [idx, value]= AIC(strainWindow)
%
% end