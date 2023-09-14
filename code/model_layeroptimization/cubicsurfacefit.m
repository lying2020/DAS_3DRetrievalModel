%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to convert the velocity discrete data into grid point data
% and select a reference original point
%% -----------------------------------------------------------------------------------------------------
function [coeff, func, resnorm, X, Y] = cubicsurfacefit(zMat, interval, type)
% -----------------------------------------------------------------------------------------------------
%% ����16�����Ϊinter��4*4����㣬��С�������һ����Ԫ���ζ���ʽ
% ����Ҫ���ǵ����������ֻ������ж���������ϻ�������������ϵ�ʱ����ô���ٵ��ظ����ô��롣
% ��������ֻ��9���㣬������16�����ʱ���ֿ�����ôȥ����
% INPUT:
% zMat: 4*4 matrix, ��Ӧÿ��λ���ϵ�zֵ
% interval: 1*2 matrix or a scale, x, y��С������ࡣ�����������Ϊ:
% x = [-3/2, -1/2, 1/2,  3/2] * interval(1);
% y = [-3/2, -1/2, 1/2,  3/2] * interval(2);
% type: fitting type: 'cubic'  | 'quad'  |  'linear'
% 
% OUTPUT:
% coeff: 1* 10 matrix. ��ϵĶ�Ԫ���ζ���ʽ��ϵ������
% coeff = [a1, a2, ..., a9, a10];
%  f(x,y) = a1*x*x*x + a2*x*x*y + a3*x*y*y + a4*y*y*y + ...
%              a5*x*x + a6*y*y + a7*x*y + a8*x + a9*y + a10;   
% resnorm: residual norm.
% coeffMat: (m - 1)* (n - 1) cell matrix. each cell includes 10 parameters
% zRange: (m -1)* (n - 1) cell matrix, each cell includes 2 parameters.
%
%% -----------------------------------------------------------------------------------------------------
% default parameter set.
if nargin < 3, type = 'cubic';     end
if nargin < 2, interval = 1;   end
% -----------------------------------------------------------------------------------------------------
% grid point coordinate. chose fitting type ...
if contains('cubic', type)
    xyArray = [-1.5, -0.5, 0.5, 1.5];   % zMat: 4*4 matrix
elseif contains('quadratic', type)
    xyArray = [-1.0, 0.0, 1.0];           % zMat: 3*3 matrix
else  % linear fitting
    xyArray = [-0.5, 0.5];             % zMat: 2*2 matrix
end
%
%% -----------------------------------------------------------------------------------------------------
% Generate grid point data X and Y.
xyLen = length(xyArray);
X = repmat(xyArray', 1, xyLen)* interval(1);
Y =  repmat(xyArray, xyLen, 1)* interval(end);
X = X(:);    Y= Y(:);
%
xLen = length(X);
% -----------------------------------------------------------------------------------------------------
% chose fitting type ...
if contains('cubic', type)
%     xLen = 10;
     A = [X.*X.*X,  X.*X.*Y,  X.*Y.*Y,  Y.*Y.*Y,  X.*X, Y.*Y, X.*Y, X,  Y,  ones(xLen, 1)];
    func = @(var,x, y) var(1)*x(:).^3 + var(2)*x(:).*x(:).*y(:) + var(3)*x(:).*y(:).*y(:) + var(4)*y(:).^3 + ...
                             var(5)*x(:).*x(:) + var(6)*y(:).*y(:) + var(7)*x(:).*y(:) + var(8)*x(:) + var(9)*y(:) + var(10);
elseif contains('quadratic', type)  % Quadratic polynomial surface
%    xLen = 6;
       A = [X.*X, Y.*Y,  X.*Y,  X,  Y,  ones(xLen, 1)];
   func = @(var, x, y) var(1)*x(:).*x(:) + var(2)*y(:).*y(:) + var(3)*x(:).*y(:) + var(4)*x(:) + var(5)*y(:) + var(6);
else    %  Linear polynomial surface
%    xLen = 4;
       A = [X.*Y,  X,  Y,  ones(xLen, 1)];
 func = @(var, x, y) var(1)*x(:).*y(:) + var(2)*x(:) + var(3)*y(:) + var(4);
end
% -----------------------------------------------------------------------------------------------------
% [coeff, resnorm] = lsqlin(A, b);   coeff = coeff';
coeff = (pinv(A)* zMat(:))';
resnorm = norm(func(coeff, X, Y) - zMat(:));











