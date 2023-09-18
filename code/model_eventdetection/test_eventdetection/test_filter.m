
%
close all;
clear
%  DEBUG ! ! !
dbstop if error;
format long
% addpath ../include/model_dataprocessing ..\include\model_eventdetection
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
%
%
% filename = '..\..\testdata\strainMat17.mat';
% filename = '..\..\testdata\strainMat61.mat';
filename = '..\..\testdata\strainMat44.mat';
% filename = '..\..\testdata\strainMat103.mat';
%
strainMat = importdata(filename);
[lenPosition,  lenTime] = size(strainMat);
time = (1:lenTime)*0.064;
position = 1:lenPosition;
[ampMat0, frequencyArray0, ~] = fftfunc(strainMat, time, 'strain');
% a 3D figure of original signal.     
ax1 = axes(figure);
plot3D(ax1, strainMat, position, time);
%
% -----------------------------------------------------------------------------------------------------
% lowpass filter.
fp.wp = 20.0;  fp.ws = 40;
%
% fp.wp = 10;  fp.ws = 40;
% bandpass filter.
% fp.wp = [4, 60];  fp.ws = [1, 100];
% -----------------------------------------------------------------------------------------------------
% passband ripple, and stopband attenuation.
fp.rp = 1;    fp.rs = 30;
displaytimelog('filtering seismic data ... ');
% ftype = 'low' | 'high' | 'band'£»
%
ftype = ' '; % default low or band pass filter.
[strainMat1, timeLagArray, maxCorrArray] = filteringfunc(strainMat, time, fp, ftype);
[ampMat1, frequencyArray1, ~] = fftfunc(strainMat1, time, 'strain');
% a 3D figure of the filtered signal
ax2 = axes(figure);
plot3D(ax2, strainMat1, position, time);

numArray = 2:9;   %  ceil(lenPosition/10);

for num = numArray
    strain0 = strainMat(num, :);
     displaytimelog([' ------------------------------------------------------------------']);
    displaytimelog(['  # ', num2str(num), ' filtering seismic data ... ']);
    [strain1, timelag(num), maxCorr] = filteringfunc(strain0, time, fp, ftype);
    %
    [val0, idx0] = max(strain0);      [val1, idx1] = max(strain1);
    std0 = std(strain0);                  std1 = std(strain1);
    ssnorm = norm(strain0 - strain1);
    fprintf('   signal         maxvalue          location            std \n');
    fprintf(' original     %2.8f         %5d      %2.8f \n', val0,  idx0, std0);
    fprintf(' filtered     %2.8f          %5d      %2.8f \n', val1,  idx1, std1);
%     displaytimelog([' ------------------------------------------------------------------']);
    fprintf('  norm2:  %2.8f;   time-lag: %5d;   maxcorr: %2.8f \n', ssnorm, timelag(num), maxCorr);
    figure;
    subplot(311);
    plot(time, strain0);
    xlabel('time/ms');    ylabel('strain ');
    title(['the ', num2str(num), 'th ', 'strain signal. ']);
    subplot(312);
    plot(time, strainMat1(num, :));
     xlabel('time/ms');     ylabel('strain-filtered ');
    title(['the ', num2str(num), 'th ', 'strain signal after filtering. ']);
    subplot(313);
     xcorrArray = crosscorrelation(strain0, strain1);
    xcorrTime = (1 : length(xcorrArray)) - length(strain0) - 1;
    plot(xcorrTime, xcorrArray); xlabel('timeLag');  ylabel('correlation');
    title('correlation of strain data between before and after filtering.');
    % -----------------------------------------------------------------------------------------------------
    pause(2);
end





