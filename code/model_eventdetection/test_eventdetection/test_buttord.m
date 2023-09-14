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
wp=[0.2*pi 0.3*pi];              % 设置通带频率
ws=[0.1*pi 0.4*pi];              % 设置阻带频率
Rp=1; Rs=20;                     % 设置波纹系数
% 巴特沃斯滤波器设计
[N,Wn]=buttord(wp,ws,Rp,Rs,'s'); % 求巴特沃斯滤波器阶数
fprintf('巴特沃斯滤波器 N=%4d\n',N) % 显示滤波器阶数
[bb,ab]=butter(N,Wn,'s');        % 求巴特沃斯滤波器系数
W=0:0.01:2;                      % 设置模拟频率
[Hb,wb]=freqs(bb,ab,W);          % 求巴特沃斯滤波器频率响应
plot(wb/pi,20*log10(abs(Hb)),'b')% 作图
