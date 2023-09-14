
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
% [K,V]=v_findpeaks(x,m,w);

% 输入变量x是被测序列，m是方式，m设为’q’时，用二次曲线内插后寻找峰值，当m设为’v’时是寻找谷值；w是在寻找峰值时，两个峰值之间最小间隔

clear all; clc; close all;

strainMat = importdata('strainMat.mat');
y = strainMat(1, :);
x=detrend(y);                % 消除趋势项
fs=200;                      % 采样频率
N=length(x);                 % 数据长度
time=(0:N-1)/fs;             % 时间刻度
[K,V]=v_findpeaks(x,'v',100);
T2=time(K);                  % 取得脉搏谷值时间
M2=length(T2);
T21=T2(2:M1);
T22=T2(1:M1-1);
Mdt2=mean(T21-T22);          % 从谷值得的平均周期值
fprintf('谷值求得的平均周期值=%5.4f\n',Mdt2);
% 作图
plot(time(K),V,'gO','linewidth',3);
set(gcf,'color','w');
