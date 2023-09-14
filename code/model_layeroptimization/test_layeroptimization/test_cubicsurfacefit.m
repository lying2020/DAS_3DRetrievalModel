
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
%

zMat = [0.9501    0.7620    0.6153    0.4057
    0.2311    0.4564    0.7919    0.9354
    0.6068    0.0185    0.9218    0.9169
    0.4859    0.8214    0.7382    0.4102];
d = [0.0578
    0.3528
    0.8131
    0.0098
    0.1388];

zMat = [2.3, 3.4; 1.4, 2.33];
[coeff1, func1, resnorm1, xMat, yMat] = cubicsurfacefit(zMat, 1, 'linear');
[coeff2, func2, resnorm2] = surfacefitting(xMat, yMat, zMat, 'linear');

coeff1
func1

coeff2
func2 





