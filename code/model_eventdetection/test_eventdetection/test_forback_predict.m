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
sMat(istrain, :) = forbackpredict(strainMat(sArray(istrain), :), L, 4);        % ����
end

plot3D(axes(figure), strainMat(sArray, :)); title('strainMat');

plot3D(axes(figure), sMat);  title('sMat');




return;  
%% 
Fs=1000;                     % ����Ƶ��
N=251;                       % ������
t=(0:N-1)/Fs;                % ʱ��̶�
f1=10; f2=21;                % �ź�Ƶ��f1��f2
L=20;                        % ���س���
ys=sin(2*pi*f1*t)+sin(2*pi*f2*t);  % �����ź�
yc=cos(2*pi*f1*t)+cos(2*pi*f2*t);  % �����ź�
x1=forbackpredict(ys, L, 4);        % ����
hys=hilbert(ys);             % ��û������ʱ��ϣ�����ر任
hx1=hilbert(x1);             % �����غ����е�ϣ�����ر任
hys1=hx1(L+1:L+N);           % ��ȥ���ص�����

% ��ͼ
subplot 311; plot(t, ys, 'k'); 
axis([0 max(t) -2.4 2.4]); ylabel('ԭʼ�ź�')
subplot 312; plot(t, yc, 'r', 'linewidth', 3); hold on
plot(t, -imag(hys), 'k'); axis([0 max(t) -2.4 2.4]);
ylabel('δ�����صı任')
subplot 313; plot(t, yc, 'r', 'linewidth', 3); hold on
plot(t, -imag(hys1), 'k'); axis([0 max(t) -2.4 2.4]);
ylabel('�����صı任'); xlabel('ʱ��/s')
set(gcf, 'color', 'w');





