%% test crosscorrelation function
% this is a demo of the crosscorrelation function
%
close all;
% clear
clc
%%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
% -----------------------------------------------------------------------------------------------------
% clear all; clc; close all;

%% # test 1
arr1 = [1 2 3 4 5 6 7];
arr2 = [3 4 5 6 7 1 2];
[xcorrArray1, timeLag1, fig1] = crosscorrelation(arr1, arr2);

%%
%  We can see the maximum correlation coefficient and the delay
disp(['maxCoor1 = ', num2str(max(xcorrArray1)), ', timeLag1 = ', num2str(timeLag1)]);

%% # test 2
x1 = [0,0,1,2,3,7,9,8,0,0];
x2 = [1,2,3,7,9,8,0,0,0,0];
[xcorrArray2, timeLag2, fig2] = crosscorrelation(x1, x2);

%%
% the maximum correlation coefficient and the delay
disp(['maxCoor2 = ', num2str(max(xcorrArray2)), ', timeLag1 = ', num2str(timeLag2)]);

xcorrTime = (1 : length(xcorrArray2)) - length(x1) - 1;

%%
% Matlab call function xcorr
[xcorrMat, lag] = xcorr(x1, x2, 'coeff');
%%
% plot lag-corr graph.
figure; hold on;
plot(lag, xcorrMat, 'b', 'linewidth', 3);
plot(xcorrTime, xcorrArray2, 'ro-');
legend('xcorr', 'crosscorrelation');  xlabel('time lag');  ylabel('normalized coeff');
%%
% You can see two points ahead

%% # test 3
%
filename = '..\..\testdata\strainMat17.mat';
%%
% filename = '..\..\testdata\strainMat61.mat';
% filename = '..\..\testdata\strainMat44.mat';
% filename = '..\..\testdata\strainMat103.mat';
%
strainMat0 = importdata(filename);
[lenPosition,  lenTime] = size(strainMat0);
time = (1:lenTime);  % *0.064;
[strainMat, timeLag2, maxCorr2, fig]= filteringfunc(strainMat0);
n = lenPosition - 1; plot(axes(figure), time, strainMat0(n, :), 'b', time, strainMat(n, :), 'r');
legend('strain', 'filtered strain');







%{
1.������˹�˲��Ϳ������˲������ԣ��ؼ��Ǹߵͽ�Ƶ��ѡȡ�����Ҫ�������ݵ����ѡ����ʵĲ������˲�����������ʹ��PS���ĳ�����������ʰȡ����
2.����ʱ�����Ǿ����triggering��������΢�����ⴥ���¼���ʹ�ã�
һ�����PS���ʱ����ѡȡ������ʱ����ò�Ҫͬʱ����PS����Ϣ�����糣�ò���60/20 ms��������
�ż�ֵ��Ҫ�������������������һ�£�����1.9 2.0.���ͻ�Ž����ܶ������źţ�������Щ�¼���©����
3. ���˵������ص��һ�û���˽⣬���ܻش������
4. ΢������Ҫ�õ��������¼���͸�䲨����λ�����䲨���䲨�����������������ˣ�
�����ڵ�ʱ����͸�䲨�źš�ʰȡ����ʱֻʰȡ���絽��ġ�
�ز����ǵȱ仯��Ϣ�����������ٶ�ģ���ϣ����ڵ���λ��Ҫһ��ƽ����ٶȳ���������ʱ�����Բ�״�ٶ�ģ��Ҫ��ƽ�⴦����ʹ�÷ֶκ�����


%}















