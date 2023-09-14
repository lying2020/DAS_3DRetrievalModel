%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-08-24: Readjust code
% this code is used to filter strain data with buterword filter(lowpass or highpass).
%% -----------------------------------------------------------------------------------------------------
function [strainFilterMat, timeLag, maxCorr, flag] = filteringfunc(strainMat, time, fp, ftype)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% strainMat: nsensor* nmeasure matrix, the original signal, microstrain value
% time: 1* nmeasure array, discrete time, unit: ms
% fparameter: a struct data, contains wp, ws, rp, rs
% -- wp - Passband corner (cutoff) frequency
% -- ws - Stopband corner frequency
% -- rp - Passband ripple
% -- rs - Stopband attenuation
% ftype: filtering type, 'low' | 'high' | 'band'
%
% OUTPUT:
% strainFilterMat: the strain data after filtering
% timeLag: nsensor*1 matrix, time lag after filtering. 
% maxCorr: nsensor*1 matrix, max correlation coefficients. 
%% -----------------------------------------------------------------------------------------------------
tic
% some default parameters setting.
if nargin < 4, ftype = '  ';   end
if nargin< 3, fp = []; end
% if nargin < 3 || isempty(fparameter)
%  Butterworth low pass filter.
fparameter.wp = 20;       %  40 ;  % [20  20 4 ]    % wp: 通带截止频率, Passband cutoff frequency
fparameter.ws = 200;   % 400; % [300 50 50]  % ws: 阻带起始频率, Stopband start frequency
fparameter.rp = 2;   % [ 1   2    5   4 ]    % rp: 通带波纹, passband ripple
fparameter.rs = 30;  % [30 40 45 40]   % rs: 阻带衰减, stopband attenuation
%
% end
% field = {'wp','ws','rp','rs'};
if isfield(fp,'wp'), fparameter.wp = fp.wp;   end
if isfield(fp,'ws'), fparameter.ws = fp.ws;   end
if isfield(fp,'rp'), fparameter.rp = fp.rp;   end
if isfield(fp,'rs'), fparameter.rs = fp.rs;   end
%
% test demo. 
% if nargin < 1, strainMat = importdata('../testdata/strainMat166_188.mat');  nargout = 4; end  
[lenPosition, lenTime] = size(strainMat);
if length(strainMat) < 2
    warning('filteringfunc: NO OUTPUT !!! ');
    strainFilterMat = strainMat;
    timeLag = [];
    %     info = toc;
    return;
end
if size(strainMat, 2) == 1, strainMat = strainMat';  end
%
if nargin < 2, time = (1:lenTime)*0.064;   end
if isempty(time), time = (1:lenTime)*0.064;   end
%
%% -----------------------------------------------------------------------------------------------------
% lenPosition = length(position);
% lenTime = length(time);
time = time - 2*time(1) + time(2);

%% sampling interval.
sampleInterval = mean(diff(time));
if lenTime > 5000
    sampleInterval = sum( ( time(1, 1016: 2015) - time(1, 16:1015) )/1000 )/1000;   % The time span, unit: ms
end
% timeLong = time(end)/1000;  % the sampling time;   unit: s

%% sampling frequency;    unit: Hz
frequency = floor( 1/sampleInterval * 1000);
%
%% filtering and compensating for delay and distortion.
[b, a] = butterworthfilter(fparameter, frequency, ftype);
strainFilterMat = zeros(lenPosition, lenTime);
for istrain = 1:lenPosition
    strainFilterMat(istrain, :) = filter(b, a, strainMat(istrain, :));
    % Compensates for delay and distortion
    lag = finddelay(strainMat(istrain, :), strainFilterMat(istrain, :));
    [~, bp0, fp0] = forbackpredict(strainMat(istrain, :), abs(lag), 4);        % 延拓
    if lag > 0, strainFilterMat(istrain, :) = [strainFilterMat(istrain, (lag+1):end), fp0']; end
    if lag < 0, strainFilterMat(istrain, :) = [bp0', strainFilterMat(istrain, 1:(end+lag))]; end
    %     if lag > 0, strainFilterMat(istrain, :) = [strainFilterMat(istrain, (lag+1):end), strainFilterMat(istrain, 1:lag)]; end
    %     if lag < 0, strainFilterMat(istrain, :) = [strainFilterMat(istrain, (lenTime - lag+1):end), strainFilterMat(istrain, 1:(lenTime - lag))]; end
end

%% correlation matrix of strain data between before and after filtering
if nargout > 1
    timeLag = zeros(lenPosition, 1);
    maxCorr = zeros(lenPosition, 1);
    for istrain = 1:lenPosition
        [tmp, timeLag(istrain, 1)]= crosscorrelation(strainMat(istrain, :), strainFilterMat(istrain, :));
        maxCorr(istrain, 1) = max(tmp);
    end
end

%% determine whether or not to output the image
if nargout > 3
    %
    figure;
    xx = ceil(lenPosition/2);
    strain = strainMat(xx, :);
    strainfilter = strainFilterMat(xx, :);
    subplot(3, 1, 1);
    plot(time, strain);    %   stem(time, strainMat(xx, :), '.', 'Markersize',1);
    %     plot(1: length(time), strain);
    xlabel('time/ms');    ylabel('strain ');
    title(['pic time-strain of the ', num2str(xx), 'th sensor']);
    subplot(3, 1, 2);
    plot(time, strainfilter);  % stem(time, strainMat(xx, :), '.', 'Markersize',1);
    %     plot(1: length(time), strainfilter);
    xlabel('time/ms');     ylabel('strain-filtered ');
    title(['time-strain of the ', num2str(xx), 'th sensor after filtering']);
    subplot(3, 1, 3);
    xcorrArray = crosscorrelation(strain, strainfilter);
    xcorrTime = (1 : length(xcorrArray)) - length(strain) - 1;
    plot(xcorrTime, xcorrArray); xlabel('timeLag/');  ylabel('correlation');
    title('correlation of strain data between before and after filtering.');
    % -----------------------------------------------------------------------------------------------------
    flag = toc;
    %     info = ['# the cost of  strain filtering is: ', num2str(flag), ' s.' ];
    %     disp(info);
end


end
%
%
%
%
%% -----------------------------------------------------------------------------------------------------
function [b, a] = butterworthfilter(fparameter, fn, ftype)
%
% https://ww2.mathworks.cn/help/signal/ref/buttord.html?s_tid=srchtitle
% finds the minimum order n and cutoff frequencies Wn for an analog Butterworth filter.
% INPUT:
% fparameter:
% fn:
% -----------------------------------------------------------------------------------------------------
%  ex: fn = 1/timeLen * lenTime;
% Butterworth filter
% lowpass:
%  wp = 20; ws =300;
%  rp = 1; rs = 30;
% wp: 通带截止频率, the cutoff frequencies must be within the interval of (0,1).
% ws: 阻带起始频率
% rp: 通带波纹
% rs: 阻带衰减
%
% bandpass:
% Wp = [100 200]/500;
% Ws = [50 250]/500;
% Rp = 3;    Rs = 40;
% -----------------------------------------------------------------------------------------------------
wpp=fparameter.wp/(fn/2);   wss=fparameter.ws/(fn/2);  %归一化;
% wn:  Cutoff frequency
[n, wn]=buttord(wpp, wss, fparameter.rp, fparameter.rs); %计算阶数和临界 截止频率（归一化频率）
%
% 计算N阶巴特沃斯数字滤波器系统函数分子、分母多项式的系数向量b、a。
if contains('highpass', ftype)
    [b, a] =  butter(n, wn, 'high');   %   高通数字滤波器
    return;
end
% if contains('lowpass', ftype)
[b, a]=butter(n, wn);  % bandpass or lowpass.
%     return;
% end

% [H,  f] = freqz(b,a,512,fn);%做出H(z)的幅频、相频图，频率特性
end
% -----------------------------------------------------------------------------------------------------
%       Lowpass:    Wp = .1,      Ws = .2
%       Highpass:   Wp = .2,      Ws = .1
%       Bandpass:   Wp = [.2 .7], Ws = [.1 .8]
%       Bandstop:   Wp = [.1 .8], Ws = [.2 .7]

