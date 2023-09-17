
%
%
%
% close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
%

clear;clc;
x = 0.1 : 0.1 : 5;
y = 0.1 : 0.1 : 5;
[X, Y] = meshgrid(x, y);
Z = X.^2 + Y.^2 + X.*Y + X + Y + 1;
rng('default');
Zn = awgn(Z, 30, 'measured');
xfit = randi(50, 100, 1) / 10;
yfit = randi(50, 100, 1) / 10;
zfit = zeros(100, 1);
for i = 1 : 100
    zfit(i) = Zn(xfit(i) * 10, yfit(i) * 10);
end
% func = @(var,x) var(1)*x(:,1).^2 + var(2)*x(:,2).^2 + var(3)*x(:,1).*x(:,2) + var(4)*x(:,1) + var(5)*x(:,2) + var(6);
[coeff, func, resnorm] = layersurfacefitting(xfit, yfit, zfit, 'quad');
Zfit = coeff(1) * X.^2 + coeff(2) * Y.^2 + coeff(3) * X.*Y + coeff(4) * X + coeff(5) * Y + coeff(6);
ya = func(coeff, xfit, yfit);
surf(x, y, Zn);
shading interp
% freezeColors
hold on
surf(x, y, Zfit);
colormap hot
shading interp
% scatter3(xfit, yfit, zfit, 50, 'MarkerFaceColor', [0 0 0]);
% scatter3(xfit, yfit, ya, 50, 'MarkerFaceColor', [0 0 1]);
surf(x, y, Z - Zfit);
shading interp
hold off
% legend('Model','Fits','Fit','fit','Error');








