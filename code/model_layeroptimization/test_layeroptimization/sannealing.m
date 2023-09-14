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
%��ʼ���ڴ桢ͼ��

kb=8.6173324e-5;
%������������

x=-1000:1000;
f=0.3*sin(x/10).*exp(-abs(x/300));
g=1.5*exp(-abs(x/400));
E=f-g;
%�������кܶ����Сֵ�����ܺ���

pos0=666;
e0=E(pos0);
%��������ʼλ��

T=3000;
%�趨��ʼ�¶ȣ���ʼ�˻�
for i=1:500
    tem=[num2str(T),' K'];
    for k=1:10000
        if(rand()<0.5)
            pos=pos0+1;
        else
            pos=pos0-1;
        end
        %���Ǩ��һ��
        
        e=E(pos);
        %Ǩ�ƺ������
        if (rand()<exp((e0-e)/kb/T))
            %������metropolis�о�ʱ�����ܴ˴�Ǩ��
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
    %�����켣ͼ
    
    subplot(2,1,2)
    rho=exp(-E/kb/T)/max(exp(-E/kb/T));
    plot(x,rho,'r-')
    axis([-1000 1000 0 1.1])
    ylabel('Probability density');set(gca,'xtick',[]);set(gca,'ytick',[]);
    %�����ܶ�ͼ
    
    rgb = frame2im(getframe(gcf));
    %����ǰ֡ͼת��ΪRGB����
    [I, map] = rgb2ind(rgb,20);
    %��RGB����ת��Ϊindexͼ���Լ�������color map
    if (i ==1)
        imwrite(I,map,'sim_anneal.gif','gif','Loopcount',0,'DelayTime',0.005);
        %��һ֡
    else
        imwrite(I,map,'sim_anneal.gif','gif','WriteMode','append','DelayTime',0.005);
    end
    %��֡д��gif�ļ�
    T=round(T*0.995);
    %����
end