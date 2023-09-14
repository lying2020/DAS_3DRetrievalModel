%
%
%
%
%
%
%
%
% clear;clc;close all;
%%  -----------------------------------------------------------
%  DEBUG ! ! !
dbstop if error;
format long
% addpath(genpath('../../include'));
%

set(0,'defaultfigurecolor','w');
figure;
set(gcf,'Position',[200 100 600 600]);
ax=[-1000 1000 -2 0];
%初始化内存、图像

kb=8.6173324e-5;
%玻尔兹曼常数

x=-1000:1000;
f=0.3*sin(x/10).*exp(-abs(x/300));
g=1.5*exp(-abs(x/400));
E=f-g;
%构建具有很多局域极小值的势能函数

pos0=666;
e0=E(pos0);
%随便设个初始位置

T=3000;
%设定初始温度，开始退火
for i=1:500
    tem=[num2str(T),' K'];
    for k=1:10000
        if(rand()<0.5)
            pos=pos0+1;
        else
            pos=pos0-1;
        end
        %随机迁移一步
        
        e=E(pos);
        %迁移后的能量
        if (rand()<exp((e0-e)/kb/T))
            %当满足metropolis判据时，接受此次迁移
            pos0=pos;
            e0=e;
        end
    end
    
    clf;
    subplot(2,1,1)
    plot(x,E,'b-');hold on;
    plot(pos0-1001,E(pos0),'r.', 'markersize', 15);
    axis(ax);text(-100,-0.5,tem);
    ylabel('Energy (eV)'); set(gca,'xtick',[]);
    %搜索轨迹图
    
    subplot(2,1,2)
    rho=exp(-E/kb/T)/max(exp(-E/kb/T));
    plot(x,rho,'r-')
    axis([-1000 1000 0 1.1])
    ylabel('Probability density');set(gca,'xtick',[]);set(gca,'ytick',[]);
    %概率密度图
    
    rgb = frame2im(getframe(gcf));
    %将当前帧图转换为RGB数据
    [I, map] = rgb2ind(rgb,20);
    %将RGB数据转换为index图像，以及关联的color map
    if (i ==1)
        imwrite(I,map,'sim_anneal.gif','gif','Loopcount',0,'DelayTime',0.005);
        %第一帧
    else
        imwrite(I,map,'sim_anneal.gif','gif','WriteMode','append','DelayTime',0.005);
    end
    %逐帧写入gif文件
    T=round(T*0.995);
    %降温
end