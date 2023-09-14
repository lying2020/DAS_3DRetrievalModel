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




% y=hilbert（x）
% 直接对接收到的信号做希尔伯特变换，得到的包络如图所示
clear all; clc; close all;

n=-5000:20:5000;            % 样点设置
% 程序第一部分:直接做做希尔伯特变换
N=length(n);                % 信号样点数
nt=0:N-1;                   % 设置样点序列号
x=120+96*exp(-(n/1500).^2).*cos(2*pi*n/600); % 设置信号
Hx=hilbert(x);              % 希尔伯特变换
% 作图
plot(nt, x, 'k', nt, abs(Hx), 'r');
grid; legend('信号', '包络');
xlabel('样点'); ylabel('幅值')
title('信号和包络')
set(gcf, 'color', 'w');

% return; 
% 原因是由于直流分量的影响，早生了包络的不理想，
% 下面对信号进行去直流分量的处理，再进行希尔伯特变换。代码如下所示：
clear all; clc; close all;
n=-5000:20:5000;            % 样点设置
% 程序第一部分:直接做做希尔伯特变换
N=length(n);                % 信号样点数
nt=0:N-1;                   % 设置样点序列号
x=120+96*exp(-(n/1500).^2).*cos(2*pi*n/600); % 设置信号
% strainMat = importdata('strainMat_noise.mat');
% x = strainMat(11,  :);
% nt = 1:length(x);
y=detrend(x);                    % 消除直流分量
Hy=hilbert(y);              % 希尔伯特变换
plot(nt, y, 'k', nt, abs(Hy), 'r');
grid; legend('信号', '包络');
xlabel('样点'); ylabel('幅值')
title('信号和包络')
set(gcf, 'color', 'w');

return; 
% 去直流画出包络后，还要再加上直流分量

clear all; clc; close all;
n=-5000:20:5000;            % 样点设置
% 程序第一部分:直接做做希尔伯特变换
N=length(n);                % 信号样点数
nt=0:N-1;                   % 设置样点序列号
x=120+96*exp(-(n/1500).^2).*cos(2*pi*n/600); % 设置信号
y=detrend(x);                    % 消除直流分量
Hy=hilbert(y);              % 希尔伯特变换
plot(nt, x, 'k', nt, abs(Hy)+120, 'g');
grid; legend('信号', '包络'); hold on;
xlabel('样点'); ylabel('幅值')
title('信号和包络')
set(gcf, 'color', 'w');









