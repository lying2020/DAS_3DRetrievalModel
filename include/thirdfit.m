function [coeff] = thirdfit(fitdata,inter)

%% 给定16个间距为inter的4*4网格点，最小二乘拟合一个二元三次多项式。
%  input： fitdata 一个4*4矩阵，对应每个位置上的z值。
%          inter   小网格点间距。即网格点坐标为-3*inter/2，-1*inter/2，1*inter/2，3*inter/2.
%
%  output： coeff 拟合结果三此矩阵的系数，结构是10*1矩阵，依次对应x^3,x^2*y,
%           x*y^2,y^3,x^2,x*y,y^2,x,y,1的系数。

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
%  对每个格点生成方程系数

B = [x*x*x  x*x*y  x*y*y  y*y*y  x*x  x*y  y*y  x  y  1];
end
