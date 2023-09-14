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

%% 创建由随机数据组成的 10×10×10 数组并对其进行平滑处理。
data = rand(10,10,10);
data = smooth3(data,'box',5);

%% 将数据显示为带有端顶的等值面
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















