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
function [strainFftMat, dominantFq, dominantAmp, flag] = getdominantFq(strainMat, time, rangeFq)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% strainMat: numSensor* lenTime matrix, original signal, microstrain value.
% time: 1*lenTime matrix, discrete time, the time unit: ms
% numFq: the number of primary frequencies picked up
% frequencyRange: 1* 2 array, Extraction frequency range.      
% amplitudeRange: Extraction amplitude range
% OUTPUT:
% strainFilterMat: numSensor* lenTime matrix, the strain data after filtering only for the primary frequency
% dominantFq: numSensor* numFq matrix, the dominant frequency of the signal
% dominantAmp: numSensor* numFq matrix, the amplitude corresponding to the dominant frequency.
%% -----------------------------------------------------------------------------------------------------
% some default parameters
if nargin < 3, rangeFq = [0, 200];   end
%
if size(strainMat, 2) < 2, strainMat = strainMat';   end
if size(time, 2) < 2, time = time';   end
% tic
t1 =time(1, 1);   t2 = time(1, end);
timeLong = (t2 - t1)/ 1000;  % the sampling time;   unit: s
lenTime = length(time);                              %  the length of signal  
fs =  lenTime / timeLong;                            %  sampling frequency;    unit: Hz
resolution = fs/(lenTime - 1);                       %  signal resolution / distinguishability(·Ö±æÂÊ)
frequency = resolution * (0:(lenTime - 1));    %  the frequency of each point
%  frequency = 1/timeLong * (0:(lenTime - 1));
% -----------------------------------------------------------------------------------------------------
numSensor = size(strainMat, 1);
strainFftMat = zeros(numSensor, lenTime);
%
idx1 = find(frequency < rangeFq(1), 1, 'last');
if isempty(idx1), idx1 = 1;   end
idx2 = find(frequency > rangeFq(2), 1, 'first');
if isempty(idx2), idx2 = floor(lenTime/2);   end
[dominantFq, dominantAmp] = deal(zeros(numSensor, idx2 - idx1 + 1));
% -----------------------------------------------------------------------------------------------------
for isensor = 1: numSensor
    % N =  2^(nextpow2(lenTime) -1);
    amplitude = fft(strainMat(isensor, :), lenTime);
    % -----------------------------------------------------------------------------------------------------
   %     amplitude = abs(amplitude(1:floor(lenTime/2)));
    idxArray = idx1: idx2;
    % get the dominant frequency and amplitude.
    dominantFq(isensor, :) = frequency(idxArray);
    dominantAmp(isensor, :) = amplitude(idxArray);
    iAmp = zeros(1, lenTime);
    iAmp([idxArray, flip(end - idxArray+ 1)]) = [amplitude(idxArray), flip(amplitude(idxArray))];
    % take the inverse Fourier transform of the dominant frequency
%     strainFftMat(isensor, :) = ifft(iAmp, lenTime);
    strainFftMat(isensor, :) = ifft(amplitude(idxArray), lenTime);
    %
end


if nargout > 3
    flag = 1;
    figure;
    xx = 1; sp = 4;
    strain = strainMat(xx, :);
    subplot(sp, 1, 1);
    plot(time - t1, strain);
    %     xlim([ t1- 1, t2 + 1]);
    title(['time-strain ']);      xlabel('time/ms');     ylabel('strain ');
    
    subplot(sp, 1, 2);
    temp = fft(strain, lenTime);  
    plot( frequency(1:floor(lenTime/2)), abs(temp(1: floor(lenTime/2)) ) ) ;
    title('frequency-amplitude');    xlabel('fq/ Hz');      ylabel('amp');
    
    subplot(sp, 1, 3);
    plot(dominantFq(xx, :), abs(dominantAmp(xx, :)));
%     stem(dominantFq(xx, :), abs(dominantAmp(xx, :)), '.', 'Markersize',1);
    title('dominant frequency-amplitude');    xlabel('fq/ Hz');      ylabel('amp');
    
    subplot(sp, 1, 4)
    plot(time - t1, strainFftMat(xx, :));
    %     xlim([ t1- 1, t2 + 1]);
    title(['time-strain after denoising.']);   xlabel('time/ms');    ylabel('strainDenoising ');
    % -----------------------------------------------------------------------------------------------------
    figure;
    subplot(2, 1, 1);
    plot(time - t1, strain);
     title(['time-strain ']);      xlabel('time/ms');     ylabel('strain ');
      subplot(2, 1, 2)
    plot(time - t1, strainFftMat(xx, :));
    %     xlim([ t1- 1, t2 + 1]);
    title(['time-strain after denoising.']);   xlabel('time/ms');    ylabel('strainDenoising ');
end
%
% tt2 = toc;
% info = ['# the cost of  strain fft denoise is: ', num2str(tt2), ' s.' ];
% displaytimelog(info);
%
%    subplot(sp, 1, 4)
%     xcorrArray = cross_correlation(strain, strainDenoising);
%     xcorrTime = (1 : length(xcorrArray)) - length(strain);
%     plot(xcorrTime, xcorrArray); ylabel('correlation');
%     title('correlation of strain data between before and after denoising.');
% 



