
%
%
%
close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../include'));
%% -----------------------------------------------------------------------------------------------------
%
filename = '..\..\testdata\strainMat17.mat';
% filename = '..\..\testdata\strainMat61.mat';
% filename = '..\..\testdata\strainMat44.mat';
% filename = '..\..\testdata\strainMat103.mat';
%
strainMat = importdata(filename);
[lenPosition,  lenTime] = size(strainMat);
strainMat1 = filteringfunc(strainMat);
% 
xx = 3;
% 
x = strainMat(xx, :);
time=0.064*(1:length(strainMat(1, :)));                   % ʱ������
% 
xmean=mean5_3(x, 100);            % ����mean5_3����,ƽ������
% ��ͼ
subplot 211; plot(time, x, 'k');
xlabel('ʱ��/s'); ylabel('��ֵ')
title('ԭʼ����'); xlim([0 max(time)]);
% 
subplot 212; plot(time, xmean, 'k'); 
xlabel('ʱ��/s'); ylabel('��ֵ')
title('ƽ������������'); xlim([0 max(time)]);
set(gcf,'color','w');


z1=smooth(y,51,'moving'); 






