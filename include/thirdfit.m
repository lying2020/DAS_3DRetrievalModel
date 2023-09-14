function [coeff] = thirdfit(fitdata,inter)

%% ����16�����Ϊinter��4*4����㣬��С�������һ����Ԫ���ζ���ʽ��
%  input�� fitdata һ��4*4���󣬶�Ӧÿ��λ���ϵ�zֵ��
%          inter   С������ࡣ�����������Ϊ-3*inter/2��-1*inter/2��1*inter/2��3*inter/2.
%
%  output�� coeff ��Ͻ�����˾����ϵ�����ṹ��10*1�������ζ�Ӧx^3,x^2*y,
%           x*y^2,y^3,x^2,x*y,y^2,x,y,1��ϵ����

x = [-3*inter/2,-1*inter/2,1*inter/2,3*inter/2];
y = [-3*inter/2,-1*inter/2,1*inter/2,3*inter/2];

% A = [x(1)*x(1)*x(1)  x(1)*x(1)*y(1)  x(1)*y(1)*y(1)  y(1)*y(1)*y(1)  x(1)*x(1)  x(1)*y(1)  y(1)*y(1)  x(1)  y(1)  1;
%      x(1)*x(1)*x(1)  x(1)*x(1)*y(2)  x(1)*y(2)*y(2)  y(2)*y(2)*y(2)  x(1)*x(1)  x(1)*y(2)  y(2)*y(2)  x(1)  y(2)  1;
%      x(1)*x(1)*x(1)  x(1)*x(1)*y(3)  x(1)*y(3)*y(3)  y(3)*y(3)*y(3)  x(1)*x(1)  x(1)*y(3)  y(3)*y(3)  x(1)  y(3)  1;
%      x(1)*x(1)*x(1)  x(1)*x(1)*y(4)  x(1)*y(4)*y(4)  y(4)*y(4)*y(4)  x(1)*x(1)  x(1)*y(4)  y(4)*y(4)  x(1)  y(4)  1;
%      ]
count = 1;
A = zeros(16,10);
for i=1:4
    for j=1:4
        A(count,:) = getequation(x(i),y(j));
        count= count+1;
    end
end
b = [fitdata(1,1);fitdata(1,2);fitdata(1,3);fitdata(1,4);
    fitdata(2,1);fitdata(2,2);fitdata(2,3);fitdata(2,4);
    fitdata(3,1);fitdata(3,2);fitdata(3,3);fitdata(3,4);
    fitdata(4,1);fitdata(4,2);fitdata(4,3);fitdata(4,4)];

%coeff = (pinv(A)*b)';
coeff = (A\b)';



end


function [B] = getequation(x,y)
%  ��ÿ��������ɷ���ϵ��

B = [x*x*x  x*x*y  x*y*y  y*y*y  x*x  x*y  y*y  x  y  1];
end
