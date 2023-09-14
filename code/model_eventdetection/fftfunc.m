%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to analyze the frequency amplitude of the target signal
%% -----------------------------------------------------------------------------------------------------
function  [ampMat, frequencyArray, flag] = fftfunc(strainMat, time, varName)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% strainMat: numRow* lenTime matrix, original signal, microstrain value.
% time: 1*lenTime matrix, discrete time, the time unit: ms
% OUTPUT:
% strainFilterMat: numRow* lenTime matrix, the strain data after filtering
% flag: whether to output image or not
%% -----------------------------------------------------------------------------------------------------
%
if nargin < 3, varName = 'input';   end
%
[lenPosition, lenTime] = size(strainMat);
if length(strainMat) < 2
    warning('filteringfunc: NO OUTPUT !!! ');
    [ampMat, frequencyArray, flag] = deal(0);
    return;
end
if nargin < 2, time = (1:lenTime)*0.064;   end
if isempty(time), time =  (1:lenTime)*0.064;   end
%
%% -----------------------------------------------------------------------------------------------------
time = time - 2*time(1) + time(2);
%% sampling interval.  
sampleInterval = mean(diff(time));
if lenTime > 5000
    sampleInterval = sum( ( time(1, 1016: 2015) - time(1, 16:1015) )/1000 )/1000;   % The time span, unit: ms
end
%% time length 
% timeLong = time(end)/1000;  % the sampling time;   unit: s

%% sampling frequency;    unit: Hz
frequency = floor( 1/sampleInterval * 1000);

%% signal resolution / distinguishability(分辨率)
resolution = frequency/(lenTime - 1);
 
%% the frequency of each sensor strain sequence.   
frequencyArray = resolution * (0:(lenTime - 1));    
% frequencyArray = 1/timeLong * (0:(lenTime - 1));

%% the amplitude of each sensor 
ampMat = zeros(lenPosition, lenTime);

for isensor = 1:lenPosition
    % N =  2^(nextpow2(lenTime) );
    ampMat(isensor, :) = fft(strainMat(isensor, :), lenTime);
    % -----------------------------------------------------------------------------------------------------
end

%% determine whether or not to output the image
if nargout > 1
%     flag = 1;
%     figure;
    xx = ceil(lenPosition/ 2);  sp =2;
    strain = strainMat(xx, :);
    flag = subplot(sp, 1, 1);    % stem(time, strain, '.', 'Markersize',1);
    plot(time, strain);
    xlim([- 1, time(end) + 1]);    xlabel('time/ms');   %   ylabel('strain ');
    %     title([ 'Figure: time-signal of ', varName, ' data']);
    title([varName, '数据时间-信号图 ']);
%     set(gca, 'fontsize', 20);
    subplot(sp, 1, 2);
    temp = fft(strain, lenTime);  amplitude = abs(temp);
    if lenTime > 4000, lenTime = lenTime/40;  end
    plot( frequencyArray(1:floor(lenTime/2)), amplitude(1: floor(lenTime/2)) ) ;
    %     title(['Figure: frequency-amplitude of ', varName, ' data');
    title([varName, '数据频率-振幅图']);
    xlabel('fq/ Hz');      ylabel('amp');
    %
end



