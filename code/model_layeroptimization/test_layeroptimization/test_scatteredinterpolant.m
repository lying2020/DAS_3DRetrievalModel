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
% F = scatteredInterpolant(___,Method,ExtrapolationMethod) 指定内插和外插方法。在前三个语法的任意一个中同时传递 Method 和 ExtrapolationMethod 作为最后两个输入参数。
% 
% Method 可以是 'nearest'、'linear' 或 'natural'。
% 
% ExtrapolationMethod 可以是 'nearest'、'linear' 或 'none'。

%% 使用 scatteredInterpolant 创建插值 F。然后，您可以使用以下任何语法在特定点处计算 F：
% 
% Vq = F(Pq)
% Vq = F(Xq,Yq)
% Vq = F(Xq,Yq,Zq)
% Vq = F({xq,yq})
% Vq = F({xq,yq,zq})
% 
% Vq = F(Pq) 在矩阵 Pq 中指定查询点。Pq 中的每行都包含查询点的坐标。
% 
% Vq = F(Xq,Yq) 和 Vq = F(Xq,Yq,Zq) 将查询点指定为两个或三个大小相等的矩阵。
% 
% Vq = F({xq,yq}) 和 Vq = F({xq,yq,zq}) 将查询点指定为网格向量。使用此语法可在您要查询大型点网格时节省内存。

%% 定义一些样本点，并计算这些位置的三角函数的值。这些点是用于插值的样本值。
t = linspace(3/4*pi,2*pi,50)';
x = [3*cos(t); 2*cos(t); 0.7*cos(t)];
y = [3*sin(t); 2*sin(t); 0.7*sin(t)];
v = repelem([-0.5; 1.5; 2],length(t));

%% 创建插值
F = scatteredInterpolant(x,y,v);

%% 计算位于查询位置 (xq, yq) 处的插值。
tq = linspace(3/4*pi+0.2,2*pi-0.2,40)';
xq = [2.8*cos(tq); 1.7*cos(tq); cos(tq)];
yq = [2.8*sin(tq); 1.7*sin(tq); sin(tq)];
vq = F(xq,yq);

%% 绘制结果。
plot3(x,y,v,'.',xq,yq,vq,'.'), grid on
title('Linear Interpolation')
xlabel('x'), ylabel('y'), zlabel('Values')
legend('Sample data','Interpolated query data','Location','Best')




















