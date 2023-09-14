%
%
%
%% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to solve all fitting polynomial coefficients of a given layer grid point data.
%% -----------------------------------------------------------------------------------------------------
function [coeffMat, resnormMat] = layerdatafitting(xMat, yMat, zMat, fittingType)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% xMat, yMat, zMat: xLen* yLen matrix, containing grid points data of x, y, z - direction of the given surface;
% fittingType: fitting type: 'cubic'  | 'quad'  | 'nonlinear' | 'linear'
%
% OUTPUT:
%  coeffMat: (xLen -1)* (yLen -1) cell, and each cell contains a 1* numCoeff  array.
% 1* numCoeff  aa: func(aa, x, y) = aa(1) + aa(2)*y + aa(3)*x + aa(4)*x.*y + aa(5)*y.*y + aa(6)*x.*x + aa(7)*y.*y.*y + ... ;
% % coeff = [a1, a2, ..., a9, a10];
%  f(a, x, y) = a1 + a2*y +a3*x + a4*x*y  + a5*y*y + a6*x*x + a7*y*y*y + a8*x*y*y + a9*x*x*y + a10*x*x*x;
%  resnormMat: (xLen -1)* (yLen -1) matrix,
% each element represents the residual 2-norm between the fitted polynomial and the discrete data

%% -----------------------------------------------------------------------------------------------------
% some default parameters set.     
if nargin < 4, fittingType = 'linear';     end
if isempty(xMat), coeffMat = cell(0); resnormMat = []; return; end
% -----------------------------------------------------------------------------------------------------
[xLen, yLen] = size(xMat);
% Extend the boundary of the matrix. size(xMat) = [xLen+2, yLen+2];
xMat = extendmatrix(xMat );
yMat = extendmatrix(yMat);
zMat = extendmatrix(zMat);
% initialize coeffMat and resnormMat.
coeffMat = cell(xLen-1, yLen-1);
resnormMat = zeros(xLen-1, yLen-1);
%
for ir = 2:xLen
    for ic = 2:yLen
        rArray =  ir-1 : ir+2; % ir : ir+1;
        cArray = ic-1 : ic+2; % ic : ic+1;
        [coeff, ~, resnorm] = surfacefitting(xMat(rArray, cArray) , yMat(rArray, cArray), zMat(rArray, cArray), fittingType);
        coeffMat{ir-1, ic-1} = coeff;
        resnormMat(ir-1, ic-1) = resnorm;
       %% --  test ---------------------------------------------------------------------------------------------------
        %         tmp1 = xMat(ir : ir+1, ic : ic+1);
        %         tmp2 = yMat(ir : ir+1, ic : ic+1);
        %         tmp3 = zMat(ir : ir+1, ic : ic+1);
        %         points = {[tmp1(:), tmp2(:), tmp3(:)]};
        %         coeff1{1, 1} = coeff;
        %         p4surf(coeff1, points, [], [], ax1);
        %% -----------------------------------------------------------------------------------------------------
    end
end
%
%

end
%
%
%
%
%
function cMat = extendmatrix(cMat0)
%% -----------------------------------------------------------------------------------------------------
% Extend the boundary of the matrix.
% INPUT:
% cMat0: xLen*yLen matrix.
% OUTPUT:
% cMat: (xLen+2)* (yLen+2) matrix.
%
% z: initial data;     x: extended data
%     x  x  x  x  x
%     x  z  z  z  x
%     x  z  z  z  x
%     x  z  z  z  x
%     x  x  x  x  x
%% -----------------------------------------------------------------------------------------------------
[xLen, yLen] = size(cMat0);
% central initial data
cMat= zeros(xLen+2, yLen+2);
%  upper-left corner
cMat(2:end-1, 2:end-1) = cMat0;
%   upper-left corner and upper-right corner boundary value.
cMat(1, 1) = 2*cMat0(1, 1) - cMat0(2, 2);
cMat(1, end) = 2*cMat0(1, end) - cMat0(2, end-1);
%  lower-left corner and lower-right corner boundary value.
cMat(end, 1) = 2*cMat0(end, 1) - cMat0(end-1, 2);
cMat(end, end) = 2*cMat0(end, end) - cMat0(end-1, end-1);
%  upper and lower boundary value.
cMat(1, 2:end-1) = 2* cMat0(1, :) - cMat0(2, :);
cMat(end, 2:end-1) = 2* cMat0(end, :) - cMat0(end-1, :);
% left and right boundary value.
cMat(2:end-1, 1) = 2* cMat0(:, 1) - cMat0(:, 2);
cMat(2:end-1, end) = 2* cMat0(:, end) - cMat0(:, end-1);
%
%
%
end









