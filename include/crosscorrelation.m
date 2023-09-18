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
% this code is used to analysis cross correlation 
% 
%% -----------------------------------------------------------------------------------------------------
% function [xcorrGcc, xcorrTime, xcorrFft, xcorrMat] = crosscorrelation(arr1, arr2, maxLag)
function [xcorrArray, timeLag, flag,ax] = crosscorrelation(arr1, arr2, maxLag)
% -----------------------------------------------------------------------------------------------------
% [maxCorr, timeLag] = crosscorrelation(strainMat(1, :), strainMat(2, :));
% INPUT:
% arr1, arr2: 1*n array, data to be compared.    
% maxLag: max time lag.    
%
% OUTPUT:
% xCorrArray: 1* n array, correlation coeficients array. 
% timeLag: the corresponding time delay.
% positive(+) represents advance, negative(-) represents delay
% MATLAB calls xcorr calculation.   
% 
%% -----------------------------------------------------------------------------------------------------
tic
if nargin < 3,  maxLag = length(arr1);   end
% -----------------------------------------------------------------------------------------------------
% Matlabµ÷ÓÃxcorr¼ÆËã
% scaleopt ¡ª Normalization option
% 'none' (default) | 'biased' | 'unbiased' | 'normalized' | 'coeff'
[xcorrArray, lag] = xcorr(arr1,arr2, maxLag, 'coeff');   %  'biased'  %  'unbiased'
% maxCorr: maximal correlation  coefficient
[maxCorr, idx] = max(xcorrArray);
timeLag = lag(idx);

%% determine whether or not to output the image
if nargout >2
    xcorrTime = (1 : length(xcorrArray)) - length(arr1) - 1;
    figure; 
    subplot(3, 1, 1);
    plot(1:length(arr1), arr1); ylabel('data1');
    subplot(3, 1, 2);
    plot(1:length(arr2), arr2); ylabel('data2');
    subplot(3, 1, 3);
    ax = plot(xcorrTime, xcorrArray); xlabel('timeLag');  ylabel('correlation');
%     title('the correlation and time delay between two different data.');
 title(['timeLag = ', num2str(timeLag), ',  cross correlation = ', num2str(maxCorr), '.  ']);
%  % -----------------------------------------------------------------------------------------------------
    flag = toc;
    info = ['# the cost of  cross correlation is: ', num2str(flag), ' s.' ];
    displaytimelog(info);
end

%% -----------------------------------------------------------------------------------------------------
% % Frequency domain calculation: GCC-PHAT
% Nfft = length(arr1)+length(arr2)-1;
% Gss = fft(arr1,Nfft).*conj(fft(arr2,Nfft));
% Gss = Gss./abs(Gss);
% % Gss = exp(1i*angle(Gss)); % this method also works
% xcorrGcc = fftshift(ifft(Gss));
% [maxCorr, idx] = max(xcorrGcc);
% timeLag = idx - length(arr1);
%
% 
%% -----------------------------------------------------------------------------------------------------
% % Traditional time domain method
% N = length(var1);
% % time = -N+1:N-1;
% xcorrTime = zeros(2*N-1,1);
% m = 0;
% for i = -(N-1):N-1
%     m = m+1;
%     for t = 1:N
%         if 0<(i+t)&&(i+t)<=N
%             xcorrTime(m) = xcorrTime(m) + arr2(t)* arr1(t+i);
%         end
%     end
% end
% xcorrTime = xcorrTime'/N;
% [maxCorr, idx] = max(xcorrTime);
% timeLag = idx - length(arr1);
%
% 
%% -----------------------------------------------------------------------------------------------------
% %  Frequency domain method
% Nfft = length(arr1)+length(arr2)-1;
% xcorrFft = fftshift(ifft(fft(arr1,Nfft).*conj(fft(arr2,Nfft))));
% [maxCorr, idx] = max(xcorrFft);
% timeLag = idx - length(arr1);
% 






