%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-07-14: sta-lta and AIC method
% 2020-10-29: Modify the description and comments
%forback_predict函数
%% -----------------------------------------------------------------------------------------------------
function [x, bp, fp] = forbackpredict(y,  L,  p)
y=y(:);                      % 把y转为列序列
bp=backpredict(y,  L,  p);     % 计算后向延拓序列
fp=forpredict(y,  L,  p);      % 计算前向延拓序列
x=[bp; y; fp];               % 把前后向预测与y合并成新序列

end


function y=backpredict(x, M, p)   
x=x(:);                 % 把x转为列序列
ar1=arburg(x, p);        % 计算自回归求得ar
yy=zeros(M, 1);          % 初始化
yy=[yy; x(1:p)];        % 准备后向预测的序列
for l=1 : M             % 朝后预测得M个数
    for k=1 : p         % 按式(4-6-27)累加
        yy(M+1-l)=yy(M+1-l)-yy(M+1-l+k)*ar1(k+1);
    end
    yy(M+1-l)=real(yy(M+1-l));
end
y=yy(1:M);              % 得后向预测的序列


end


function y=forpredict(x, N, p)
x=x(:);                 % 把x转为列序列
M=length(x);            % x长度
L=M-p;                  % 设置前向预测位置
ar=arburg(x, p);         % 计算自回归求得ar
xx=x(L+1:L+p);          % 准备前向预测的序列
for i=1:N               % 朝前预测得N个数
    xx(p+i)=0;          % 初始化
    for k=1:p           % 按式(4-6-3)累加
        xx(p+i)=xx(p+i)-xx(p+i-k)*ar(k+1);
    end
end
y=xx(p+1:p+N);          % 得前向预测的序列

end










