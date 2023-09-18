%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-07-06: modify the staltaloop recursion function
%
% this code is used to process  micostrain data, get sta-lta ratio
%% -----------------------------------------------------------------------------------------------------
function [meanTimeArrival, ratioMat, validSensor, idxArray, timeflag, picflag] = ratiostalta(strainMat, sampling, lenSta, lenLta, funcstalta, threshold, pathSave)
% [meanTime, ratioMat] =  ratiostalta(strainMat, sampling, lenSta, lenLta, funcstalta, threshold);
% -----------------------------------------------------------------------------------------------------
% INPUT:
% strainMat: strain data, m*n
%  sampling: sampling point length
% lenSta: short time window length
% lenLta: long time window lentgh
% funcstalta: sta-lta recursion function
% threshold: the threshold of sta-lta ratio  for seismic events
% pathSave: store path, save ratioMat to the path pathSave.
%
% OUTPUT:
% meanTimeArrival: mean arrival time of sta-lta method
% ratioMat: sta-lta ratio matrix.
% picflag: decide whether to output the image
% timeflag: decide whether to output the calculation time
%
%% -----------------------------------------------------------------------------------------------------
% set some default parameters.
if length(strainMat) < 2, error('plot3D: NO OUTPUT !!! ');  return;  end
if nargin < 6,  threshold = 4; end
if nargin < 5, funcstalta = @staltaloop; end
if nargin < 4, lenSta = 200; lenLta = 4000; end
% -----------------------------------------------------------------------------------------------------
%{
Microseismic period 30-350ms.  % sta = 200; lta = 4000;
中国地震台网中心实时地震监测软件默认短、长窗数据长度参数为：1.5×采样率，20.0×采样率。
sta = 16*1000*1.5 = 24000; 1.5s
lta = 16*1000*20.0 = 320000; 20s.
%}
tic
[lenPosition, lenTime]= size(strainMat);

%%  signal extending:
extMat1 = signalextending(strainMat, lenLta);
extMat2 = signalextending(strainMat, lenSta);
%
strainMatExt = [extMat1 strainMat extMat2];
%
%% the 1th sta and lta time windows value, we will get ratio recursively.
sta0 = characteristicfunc(strainMatExt(:, (lenLta - lenSta + 1) : (lenLta + 1)))/lenSta;
lta0 = characteristicfunc(strainMatExt(:, 1:(lenLta + 1)))/lenLta;
ratio = sta0./lta0;
% h=waitbar(0,'Getting the sta-lta ratio ......'); % , 'CreateCancelBtn', 'deleteh(h)');
%
%% ratioMat = staltaloop1(strainMatExt, lenSta, lenLta, sta0, lta0)
% ratioMat = zeros(lenPosition, lenTime);
ratioMat = funcstalta(strainMatExt, lenSta, lenLta, sta0, lta0);
ratioMat(:, 1) = ratio;
len0 = (lenSta*3);
ratioMat(:, 1:len0) = 0;

%% ratioMat 3D.
% plot3D( axes(figure), ratioMat, [], 1:lenTime);
% %% strainMat 3D
% plot3D(axes(figure), strainMat, [], 1:lenTime);

%% sampling point length
sampling = lenTime;
%% -----------------------------------------------------------------------------------------------------
col = floor(lenTime/sampling);
% tw = zeros(nPosition, 1);
validSensor = zeros(lenPosition, col);
meanTimeArrival = [];
itw = 0;
for i = 1:col
    tmp = ratioMat(:, (sampling * (i - 1) + 1):(sampling*i)) > threshold;
    [validSensor(:, i), idx0] = max(tmp, [], 2); % 阈值的 arrival time，
    % -----------------------------------------------------------------------------------------------------
    [idx0, idxArray] = idx_correction(strainMat, idx0);
    % -----------------------------------------------------------------------------------------------------
    if sum(validSensor(:, i))> 0.2 * lenPosition
        itw = itw + 1;
        %         meanTimeArrival(itw) = floor( mean(idx0( idx0 > 1)) ) + sampling * (i - 1);
        meanTimeArrival = [meanTimeArrival, idx0 + sampling * (i - 1)];
        %
        if ~ isnumeric( meanTimeArrival(1, itw))
            info = ['sum(m) = ', int2str(sum(validSensor(:, i))), ', i = ', int2str(i), ...
                ', mean(idx0( idx0 > 1)) = ', num2str(mean(idx0( idx0 > 1)))];
            displaytimelog(info);
            error(' meanTimeArrival is not a number !');
        end
    end
end

sensorArray = [1: lenPosition]';
validSensor = sensorArray(all(validSensor, 2));
if isempty(meanTimeArrival), validSensor = [];  return;  end
%  meanTimeArrival = meanTimeArrival(validSensor);
%
% [~,  meanTimeArrival] = getsignalfeature(strainMat);

%% -----------------------------------------------------------------------------------------------------
if nargin > 6,  save([ pathSave, 'ratioMat',int2str(lenPosition)] , 'ratioMat');   end

if nargout > 5
    timeflag = toc;
    info = ['# the cost of  sta-lta ratio is: ', num2str(timeflag), ' s.' ];
    displaytimelog(info);
end

if nargout > 4
    n = min(2, lenPosition);
    arr = [1, lenPosition];
    picflag = figure('name','sta lta ratio');
    for j = 1:n
        subplot(2, n, j);
        plot(strainMat(arr(j), :));
        ylabel('strain');
        title(['sta = ', num2str(lenSta), ', lta = ', num2str(lenLta), ' ratio of the ', num2str(arr(j)),'th sensor.']);
        subplot(2, n, n + j);
        plot(ratioMat(arr(j), :));
        ylabel('sta-lta ratio');
    end
end



end

%
%
%
%
function [idx0, idxArray] = idx_correction(strainMat, idx0)
%%
% idx0: n*1 matrix, is the arrival-time point of each sensor with sta-lta method.
% strainMat: n* m matrix, is strain signal.
%
[lenPosition, lenTime] = size(strainMat);
%% the number of sensor must more than 5, else ...
if lenPosition < 8
    idx00 = idx0; 
    if lenPosition > 3  
        [~, m1] = min(idx00);  [~, m2] = max(idx00);
        idx00([m1, m2]) = [];
    end
    len0 = max(idx00) - min(idx00); 
    cmeans0 = mean(idx00);  idxArray = 1:lenPosition; 
else
    %    tmp0([1, 2, lenPosition-1, lenPosition]) = [];   % break off both ends
    %    len0 = (tmp0(end) - tmp0(1))*lenPosition/(lenPosition-4);
    [len0, cmeans0, idxArray] = clusteringfunc(idx0);
end

%%   找到异常到时数据点索引
tmp1 = find(abs(idx0 - cmeans0) > len0);  
%% 剔除异常到时数据索引，留下正常索引
tmp2 = setdiff(1:lenPosition, tmp1); 
if isempty(tmp2), tmp2 = tmp1;  end 
%% 找到波峰的索引
ep1 = min(lenTime, floor(max(idx0(tmp2) + len0)));
[~, idx1] = max(abs(strainMat(tmp1, 1:ep1)), [], 2 );
[~, idx2] = max(abs(strainMat(tmp2, 1:ep1)), [], 2 );
%%
ep2 = floor(max((idx1 - min(len0, abs(mean(idx2) - mean(idx1)))*1.1), len0));
idx0(tmp1) = min( lenTime, ep2);

end



