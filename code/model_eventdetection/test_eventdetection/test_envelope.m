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




% y=hilbert��x��
% ֱ�ӶԽ��յ����ź���ϣ�����ر任���õ��İ�����ͼ��ʾ
clear all; clc; close all;

n=-5000:20:5000;            % ��������
% �����һ����:ֱ������ϣ�����ر任
N=length(n);                % �ź�������
nt=0:N-1;                   % �����������к�
x=120+96*exp(-(n/1500).^2).*cos(2*pi*n/600); % �����ź�
Hx=hilbert(x);              % ϣ�����ر任
% ��ͼ
plot(nt, x, 'k', nt, abs(Hx), 'r');
grid; legend('�ź�', '����');
xlabel('����'); ylabel('��ֵ')
title('�źźͰ���')
set(gcf, 'color', 'w');

% return; 
% ԭ��������ֱ��������Ӱ�죬�����˰���Ĳ����룬
% ������źŽ���ȥֱ�������Ĵ����ٽ���ϣ�����ر任������������ʾ��
clear all; clc; close all;
n=-5000:20:5000;            % ��������
% �����һ����:ֱ������ϣ�����ر任
N=length(n);                % �ź�������
nt=0:N-1;                   % �����������к�
x=120+96*exp(-(n/1500).^2).*cos(2*pi*n/600); % �����ź�
% strainMat = importdata('strainMat_noise.mat');
% x = strainMat(11,  :);
% nt = 1:length(x);
y=detrend(x);                    % ����ֱ������
Hy=hilbert(y);              % ϣ�����ر任
plot(nt, y, 'k', nt, abs(Hy), 'r');
grid; legend('�ź�', '����');
xlabel('����'); ylabel('��ֵ')
title('�źźͰ���')
set(gcf, 'color', 'w');

return; 
% ȥֱ����������󣬻�Ҫ�ټ���ֱ������

clear all; clc; close all;
n=-5000:20:5000;            % ��������
% �����һ����:ֱ������ϣ�����ر任
N=length(n);                % �ź�������
nt=0:N-1;                   % �����������к�
x=120+96*exp(-(n/1500).^2).*cos(2*pi*n/600); % �����ź�
y=detrend(x);                    % ����ֱ������
Hy=hilbert(y);              % ϣ�����ر任
plot(nt, x, 'k', nt, abs(Hy)+120, 'g');
grid; legend('�ź�', '����'); hold on;
xlabel('����'); ylabel('��ֵ')
title('�źźͰ���')
set(gcf, 'color', 'w');









