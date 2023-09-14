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
% 功能：基于chan算法的TDOA三维定位的MSE曲线
clear;
clc;
account_test =1000;
Counter_Size=account_test;
Zp_mean1=zeros(2,6);
Zp_mse1=zeros(1,6);
M=7;
k=1;
c = 3*10^5;                      % 单位km
MS = [1,2.5,1];

for Noise_db = -16:2:-6                 % 信道所受到的噪声干扰
    Sigma = 10^(Noise_db./10)/c; 
    
    for m = 1:1:Counter_Size%%%%%%%%%%%%%%%%%%%%cishu 
        for i = 1:1:M-1
            Noise(i, 1) = gngauss(Sigma);
        end
          [ zp ] = chanpositioning(Noise,MS);
          Zp(:,m) = zp;
    end 

   Zp_all(:,1) = 0;
   Zp_mse_all = 0;
   for i = 1:1:Counter_Size
      Zp_all = Zp_all + Zp( :, i);
      Zp_mse_all = Zp_mse_all + (Zp(1,i) - MS(1,1))^2 + (Zp(2,i) - MS(1,2))^2 + (Zp(3,i) - MS(1,3))^2;
   end
   Zp_mean= Zp_all / Counter_Size ;   % 计算chan所得的均值
   Zp_mean1(1:1:3,k) =Zp_mean;

   Zp_mse  = Zp_mse_all / Counter_Size ;  % 计算chan所得的均方误差MSE
   Zp_mse1(1,k)=Zp_mse;
   
   
   k=k+1;

end
Zp_mean1
Zp_mse1
plot(-16:2:-6,Zp_mse1,'bo--')
xlabel('10lg(cσ)/dB')
ylabel('均方误差MSE/km')
legend('Chan算法')
