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
%forback_predict����
%% -----------------------------------------------------------------------------------------------------
function [x, bp, fp] = forbackpredict(y,  L,  p)
y=y(:);                      % ��yתΪ������
bp=backpredict(y,  L,  p);     % ���������������
fp=forpredict(y,  L,  p);      % ����ǰ����������
x=[bp; y; fp];               % ��ǰ����Ԥ����y�ϲ���������

end


function y=backpredict(x, M, p)   
x=x(:);                 % ��xתΪ������
ar1=arburg(x, p);        % �����Իع����ar
yy=zeros(M, 1);          % ��ʼ��
yy=[yy; x(1:p)];        % ׼������Ԥ�������
for l=1 : M             % ����Ԥ���M����
    for k=1 : p         % ��ʽ(4-6-27)�ۼ�
        yy(M+1-l)=yy(M+1-l)-yy(M+1-l+k)*ar1(k+1);
    end
    yy(M+1-l)=real(yy(M+1-l));
end
y=yy(1:M);              % �ú���Ԥ�������


end


function y=forpredict(x, N, p)
x=x(:);                 % ��xתΪ������
M=length(x);            % x����
L=M-p;                  % ����ǰ��Ԥ��λ��
ar=arburg(x, p);         % �����Իع����ar
xx=x(L+1:L+p);          % ׼��ǰ��Ԥ�������
for i=1:N               % ��ǰԤ���N����
    xx(p+i)=0;          % ��ʼ��
    for k=1:p           % ��ʽ(4-6-3)�ۼ�
        xx(p+i)=xx(p+i)-xx(p+i-k)*ar(k+1);
    end
end
y=xx(p+1:p+N);          % ��ǰ��Ԥ�������

end










