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
%  findpeaks函数

strainMat = importdata('strainMat_noise.mat');
y = strainMat(9, :);
x=detrend(y);                % 消除趋势项
fs=15624;                      % 采样频率
N=length(x);                 % 数据长度
time=(0:N-1)/fs;             % 时间刻度
% 用findpeaks函数求峰值位置 
[Val,Locs]=findpeaks(abs(x), 'MINPEAKHEIGHT', 0.00005); % , 'MINPEAKDISTANCE', 100);
T1=time(Locs);               % 取得脉搏峰值时间
M1=length(T1);
T11=T1(2:M1);
T12=T1(1:M1-1);
Mdt1=mean(T11-T12);          % 从峰值得的平均周期值
fprintf('峰值求得的平均周期值=%5.4f\n',Mdt1);
% 作图
plot(time, x, 'k'); hold on; grid;
plot(time(Locs),Val,'r:','linewidth',3);
xlabel('时间/s'); ylabel('幅值'); title('脉搏信号波形图')
set(gcf,'color','w');

% 
% 
% 
% 
% 