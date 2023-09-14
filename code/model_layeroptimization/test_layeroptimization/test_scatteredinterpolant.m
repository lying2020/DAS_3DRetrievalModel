%
%
%
% close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
%
%% scatteredInterpolant
% F = scatteredInterpolant(___,Method,ExtrapolationMethod) ָ���ڲ����巽������ǰ�����﷨������һ����ͬʱ���� Method �� ExtrapolationMethod ��Ϊ����������������
% 
% Method ������ 'nearest'��'linear' �� 'natural'��
% 
% ExtrapolationMethod ������ 'nearest'��'linear' �� 'none'��

%% ʹ�� scatteredInterpolant ������ֵ F��Ȼ��������ʹ�������κ��﷨���ض��㴦���� F��
% 
% Vq = F(Pq)
% Vq = F(Xq,Yq)
% Vq = F(Xq,Yq,Zq)
% Vq = F({xq,yq})
% Vq = F({xq,yq,zq})
% 
% Vq = F(Pq) �ھ��� Pq ��ָ����ѯ�㡣Pq �е�ÿ�ж�������ѯ������ꡣ
% 
% Vq = F(Xq,Yq) �� Vq = F(Xq,Yq,Zq) ����ѯ��ָ��Ϊ������������С��ȵľ���
% 
% Vq = F({xq,yq}) �� Vq = F({xq,yq,zq}) ����ѯ��ָ��Ϊ����������ʹ�ô��﷨������Ҫ��ѯ���͵�����ʱ��ʡ�ڴ档

%% ����һЩ�����㣬��������Щλ�õ����Ǻ�����ֵ����Щ�������ڲ�ֵ������ֵ��
t = linspace(3/4*pi,2*pi,50)';
x = [3*cos(t); 2*cos(t); 0.7*cos(t)];
y = [3*sin(t); 2*sin(t); 0.7*sin(t)];
v = repelem([-0.5; 1.5; 2],length(t));

%% ������ֵ
F = scatteredInterpolant(x,y,v);

%% ����λ�ڲ�ѯλ�� (xq, yq) ���Ĳ�ֵ��
tq = linspace(3/4*pi+0.2,2*pi-0.2,40)';
xq = [2.8*cos(tq); 1.7*cos(tq); cos(tq)];
yq = [2.8*sin(tq); 1.7*sin(tq); sin(tq)];
vq = F(xq,yq);

%% ���ƽ����
plot3(x,y,v,'.',xq,yq,vq,'.'), grid on
title('Linear Interpolation')
xlabel('x'), ylabel('y'), zlabel('Values')
legend('Sample data','Interpolated query data','Location','Best')




















