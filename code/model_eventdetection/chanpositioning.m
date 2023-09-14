%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-07-06: modify the staltaloop recursion function
% 
% This code is used to process  micostrain data, get sta-lta ratio
%
%% -----------------------------------------------------------------------------------------------------
% ���ܣ�����chan�㷨��TDOA��ά��λ
function [zp] = chanpositioning(Noise,MS)
%��վ��Ŀ
BSN = 7;

%��վλ��,ÿһ��Ϊһ����վλ��
BS = [0, 2*sqrt(3),  -2*sqrt(3),  sqrt(3),   -sqrt(3),  -sqrt(3),  sqrt(3); 
      0,         0,           0,      3,          3,        -3,         -3;
      0,         0,           0,      0,          2,         2,         0];
      
%�����������BS��MS�ľ���
for i = 1:BSN
   R0(i) =  sqrt((BS(1,i) - MS(1))^2 + (BS(2,i) - MS(2))^2 + (BS(3,i) - MS(3))^2);
end

%��������
c = 3*10^5;

%�����������BSi��MS�ľ�����BS1��MS�ľ���ʵ����TDOA*c���
for i = 1:BSN-1
   R(i) = R0(i+1) - R0(1) +c*Noise(i,1);
end


%% ��һ��WLS
%k = x^2+y^2+z^2
for i =1:BSN
    k(i) = BS(1,i)^2 + BS(2,i)^2 + BS(3,i)^2;
end

% h
for i = 1:BSN-1
    h(i) = 0.5*(R(i)^2 - k(i+1) + k(1));
end

% Ga
for i = 1:BSN-1
   Ga(i,1) = -BS(1,i+1);
   Ga(i,2) = -BS(2,i+1);
   Ga(i,3) = -BS(3,i+1);
   Ga(i,4) = -R(i);
end

%QΪTDOAϵͳ��Э�������
Q = cov(R);
%za,�����Զʱ
za1 = pinv(Ga'*pinv(Q)*Ga)*Ga'*pinv(Q)*h';

%% �ڶ���WLS
%h2
X1 = BS(1,1);
Y1 = BS(2,1);
Z1 = BS(3,1);
h2 = [
      (za1(1,1) - X1)^2;
      (za1(2,1) - Y1)^2;
      (za1(3,1) - Z1)^2;
       za1(4,1)^2
      ];
  
%Ga2
Ga2 = [1,0,0;0,1,0;0,0,1;1,1,1];

%B2
B2 = [
      za1(1,1)-X1,0,0,0;
      0,za1(2,1)-Y1,0,0;
      0,0,za1(3,1)-Z1,0;
      0,0,0,za1(4,1)
      ];
%za2
za2 = pinv( Ga2' * pinv(B2) * Ga' * pinv(Q) * Ga * pinv(B2) * Ga2) * (Ga2' * pinv(B2) * Ga' * pinv(Q) * Ga * pinv(B2)) * h2;

%zp
zp(1,1) = abs(za2(1,1))^0.5+X1;
zp(2,1) = abs(za2(2,1))^0.5+Y1;
zp(3,1) = abs(za2(3,1))^0.5+Z1;
end
