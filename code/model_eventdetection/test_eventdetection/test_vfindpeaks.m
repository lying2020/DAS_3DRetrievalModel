
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

% �������x�Ǳ������У�m�Ƿ�ʽ��m��Ϊ��q��ʱ���ö��������ڲ��Ѱ�ҷ�ֵ����m��Ϊ��v��ʱ��Ѱ�ҹ�ֵ��w����Ѱ�ҷ�ֵʱ��������ֵ֮����С���

clear all; clc; close all;

strainMat = importdata('strainMat.mat');
y = strainMat(1, :);
x=detrend(y);                % ����������
fs=200;                      % ����Ƶ��
N=length(x);                 % ���ݳ���
time=(0:N-1)/fs;             % ʱ��̶�
[K,V]=v_findpeaks(x,'v',100);
T2=time(K);                  % ȡ��������ֵʱ��
M2=length(T2);
T21=T2(2:M1);
T22=T2(1:M1-1);
Mdt2=mean(T21-T22);          % �ӹ�ֵ�õ�ƽ������ֵ
fprintf('��ֵ��õ�ƽ������ֵ=%5.4f\n',Mdt2);
% ��ͼ
plot(time(K),V,'gO','linewidth',3);
set(gcf,'color','w');
