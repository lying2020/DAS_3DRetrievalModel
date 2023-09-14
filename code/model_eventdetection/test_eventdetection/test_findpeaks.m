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
%  findpeaks����

strainMat = importdata('strainMat_noise.mat');
y = strainMat(9, :);
x=detrend(y);                % ����������
fs=15624;                      % ����Ƶ��
N=length(x);                 % ���ݳ���
time=(0:N-1)/fs;             % ʱ��̶�
% ��findpeaks�������ֵλ�� 
[Val,Locs]=findpeaks(abs(x), 'MINPEAKHEIGHT', 0.00005); % , 'MINPEAKDISTANCE', 100);
T1=time(Locs);               % ȡ��������ֵʱ��
M1=length(T1);
T11=T1(2:M1);
T12=T1(1:M1-1);
Mdt1=mean(T11-T12);          % �ӷ�ֵ�õ�ƽ������ֵ
fprintf('��ֵ��õ�ƽ������ֵ=%5.4f\n',Mdt1);
% ��ͼ
plot(time, x, 'k'); hold on; grid;
plot(time(Locs),Val,'r:','linewidth',3);
xlabel('ʱ��/s'); ylabel('��ֵ'); title('�����źŲ���ͼ')
set(gcf,'color','w');

% 
% 
% 
% 
% 