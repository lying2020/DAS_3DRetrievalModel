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

%% ���������������ɵ� 10��10��10 ���鲢�������ƽ������
data = rand(10,10,10);
data = smooth3(data,'box',5);

%% ��������ʾΪ���ж˶��ĵ�ֵ��
patch(isocaps(data,.5),...
   'FaceColor','interp','EdgeColor','none');
p1 = patch(isosurface(data,.5),...
   'FaceColor','blue','EdgeColor','none');
isonormals(data,p1);
view(3); 
axis vis3d tight
camlight left
colormap('jet');
lighting gouraud















