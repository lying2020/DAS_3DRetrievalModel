%
%
%
%
% close all;
% clear
clc
% clear all; clc; close all; 
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));   
% -----------------------------------------------------------------------------------------------------

strainMat = importdata('strainMat166_188.mat'); 
[lenPosition, lenTime] = size(strainMat);
L = 0; 
sArray = 166:188;  % 1:lenPosition 
sMat = zeros(length(sArray), L*2 + lenTime);
for istrain = 1: length(sArray) 
sMat(istrain, :) = forbackpredict(strainMat(sArray(istrain), :), L, 4);        % 延拓
end

plot3D(axes(figure), strainMat(sArray, :)); title('strainMat');

plot3D(axes(figure), sMat);  title('sMat');




return;  
%% 
Fs=1000;                     % 采样频率
N=251;                       % 样点数
t=(0:N-1)/Fs;                % 时间刻度
f1=10; f2=21;                % 信号频率f1和f2
L=20;                        % 延拓长度
ys=sin(2*pi*f1*t)+sin(2*pi*f2*t);  % 正弦信号
yc=cos(2*pi*f1*t)+cos(2*pi*f2*t);  % 余弦信号
x1=forbackpredict(ys, L, 4);        % 延拓
hys=hilbert(ys);             % 求没有延拓时的希尔伯特变换
hx1=hilbert(x1);             % 求延拓后序列的希尔伯特变换
hys1=hx1(L+1:L+N);           % 消去延拓的增长

% 作图
subplot 311; plot(t, ys, 'k'); 
axis([0 max(t) -2.4 2.4]); ylabel('原始信号')
subplot 312; plot(t, yc, 'r', 'linewidth', 3); hold on
plot(t, -imag(hys), 'k'); axis([0 max(t) -2.4 2.4]);
ylabel('未经延拓的变换')
subplot 313; plot(t, yc, 'r', 'linewidth', 3); hold on
plot(t, -imag(hys1), 'k'); axis([0 max(t) -2.4 2.4]);
ylabel('经延拓的变换'); xlabel('时间/s')
set(gcf, 'color', 'w');





