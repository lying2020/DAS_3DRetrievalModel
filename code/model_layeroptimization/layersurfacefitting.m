%
%
%
%% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to calculate the polynomial fitting coefficient for the given data.  
% we have to think about how quickly we can reuse code if we're only going to do quadric or linear surface fitting.
% and, what can we do when we only give 9 points instead of 16 points for xMat ...
%% -----------------------------------------------------------------------------------------------------
function [coeff, func, resnorm] = layersurfacefitting(xMat, yMat, zMat, gridStepSize, fittingType)
% -----------------------------------------------------------------------------------------------------
% 我们要考虑到，如果我们只打算进行二次曲面拟合或者线性曲面拟合的时候，怎么快速的重复利用代码。
% 或者我们只给9个点，而不是16个点的时候，又可以怎么去处理。
% INPUT:
% xMat, yMat, zMat: 4 * 4 matrix, discrete point data to be fitted.
% fittingType: fitting type. ( 'cubic'  | 'quad'  |  'nonlinear'  |  'linear')
%                       num coeff =      10              6                  4                       3
%
% OUTPUT:
% coeff: 1* numCoeff matrix.
% coeff = [a1, a2, ..., a9, a10];
%  f(a, x, y) = a1 + a2*y +a3*x + a4*x*y  + a5*y*y + a6*x*x + a7*y*y*y + a8*x*y*y + a9*x*x*y + a10*x*x*x;
% resnorm: residual 2-norm of fitting function and discrete data
% func: function handle.
%  func = @(aa, x, y) aa(1) + aa(2)*y + aa(3)*x + aa(4)*x.*y ... ;
%% -----------------------------------------------------------------------------------------------------
% default parameter set.
% some default parameters set.     
if nargin < 4, fittingType = 'linear';  end
if nargin < 3, gridStepSize = [10, 10]; end
% -----------------------------------------------------------------------------------------------------
% A * aa = f; => aa = pin(A)*f;
mX = mean(xMat(:));  % xMat(2, 1) + gridStepSize(1) / 2.0;  %
mY = mean(yMat(:));  % yMat(1, 2) + gridStepSize(2) / 2.0;  %

% x1    x1    x1    x1
% 
% x2    x2    x2    x2
%         [mX]
% x3    x3    x3    x3
% 
% x4    x4    x4    x4

X = xMat(:) - mX;    Y = yMat(:) - mY;     f = zMat(:);

% chose fitting type ...
if contains('cubic', fittingType)
    func = @(aa, x, y) aa(10)*x.*x.*x + aa(9)*x.*x.*y + aa(8)*x.*y.*y + aa(7)*y.*y.*y ...
        + aa(6)*x.^2+aa(5)*y.^2+aa(4)*x.*y+aa(3)*x+aa(2)*y+aa(1);
    A = [ ones(length(X), 1),  Y,  X,  X.*Y,  Y.*Y,  X.*X,  Y.*Y.*Y,  X.*Y.*Y,  X.*X.*Y,  X.*X.*X];
    %         xLen = 10;
    %     func = @(var,x) var(1)*x(:,1).^3 + var(2)*x(:,1).*x(:,1).*x(:, 2) + var(3)*x(:,1).*x(:,2).*x(:, 2) + var(4)*x(:,2).^3 + ...
    %         var(5)*x(:,1).^2 + var(6)*x(:,1).*x(:,2) + var(7)*x(:,2).^2 + var(8)*x(:,1) + var(9)*x(:,2) + var(10);
    %     func = @(var,x) var(10)*x(:,1).^3 + var(9)*x(:,1).*x(:,1).*x(:, 2) + var(8)*x(:,1).*x(:,2).*x(:, 2) + var(7)*x(:,2).^3 + ...
    %         var(6)*x(:,1).*x(:, 1) + var(5)*x(:,2).*x(:, 2) + var(4)*x(:,1).*x(:,2) + var(3)*x(:,1) + var(2)*x(:,2) + var(1);
elseif contains('quadratic', fittingType)  % Quadratic polynomial surface
    func = @(aa, x, y) aa(6)*x.*x+aa(5)*y.*y+aa(4)*x.*y+aa(3)*x+aa(2)*y+aa(1);
    A = [ ones(length(X), 1),  Y,  X,  X.*Y,  Y.*Y,  X.*X];
    %         xLen = 6;
    %     func = @(var, x) var(6)*x(:,1).*x(:, 1) + var(5)*x(:,2).*x(:, 2) + var(4)*x(:,1).*x(:,2) + var(3)*x(:,1) + var(2)*x(:,2) + var(1);
elseif contains('nonlinear', fittingType)    %  nonlinear polynomial surface
    func = @(aa, x, y) aa(4)*x.*y+aa(3)*x+aa(2)*y+aa(1);
    A = [ ones(length(X), 1),  Y,  X,  X.*Y];
    %     xLen = 4;
    %     func = @(var,x) var(4)*x(:,1).*x(:,2) + var(3)*x(:,1) + var(2)*x(:,2) + var(1);
else
    func = @(aa, x, y) aa(3)*x+aa(2)*y+aa(1);
    A = [ ones(length(X), 1),  Y,  X];
    %     xLen = 3;
    %     func = @(var,x) var(3)*x(:,1) + var(2)*x(:,2) + var(1);
end
%
%% -----------------------------------------------------------------------------------------------------
% % function lsqcurvefit, initial value = ones(1, xLen);
% [coeff, resnorm] = lsqcurvefit(func,  ones(1, xLen), [X, Y], f);
% 
coeff = (pinv(A)* f)';
resnorm = norm(func(coeff, X, Y) - f);
%
% %  [X,RESNORM] = lsqlin(C,d) returns the value of the squared 2-norm of the residual: norm(C*X-d)^2.
% [coeff, resnorm] = lsqlin(A, f);
% coeff = coeff';



end















