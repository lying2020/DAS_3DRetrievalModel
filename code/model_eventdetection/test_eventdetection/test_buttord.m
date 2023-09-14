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
wp=[0.2*pi 0.3*pi];              % ����ͨ��Ƶ��
ws=[0.1*pi 0.4*pi];              % �������Ƶ��
Rp=1; Rs=20;                     % ���ò���ϵ��
% ������˹�˲������
[N,Wn]=buttord(wp,ws,Rp,Rs,'s'); % �������˹�˲�������
fprintf('������˹�˲��� N=%4d\n',N) % ��ʾ�˲�������
[bb,ab]=butter(N,Wn,'s');        % �������˹�˲���ϵ��
W=0:0.01:2;                      % ����ģ��Ƶ��
[Hb,wb]=freqs(bb,ab,W);          % �������˹�˲���Ƶ����Ӧ
plot(wb/pi,20*log10(abs(Hb)),'b')% ��ͼ
