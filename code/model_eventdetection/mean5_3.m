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
% this code is used to caculate five-point moving average value.
%% -----------------------------------------------------------------------------------------------------
function yMat = mean5_3(xMat, m)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% xMat: num*lenTime matrix, original data.
% m: number of smooth
%
% OUTPUT:
% yMat:
% -----------------------------------------------------------------------------------------------------
[num, lenTime] = size(xMat);
%
tmpMat = zeros(num, lenTime);
%
for k=1: m
    tmpMat(:, 1) = (69*xMat(:, 1) +4*(xMat(:, 2) +xMat(:, 4)) -6*xMat(:, 3) -xMat(:, 5)) /70;
    tmpMat(:, 2) = (2*(xMat(:, 1) +xMat(:, 5)) +27*xMat(:, 2) +12*xMat(:, 3) -8*xMat(:, 4)) /35;
    for j=3:lenTime-2
        tmpMat(:, j) = (-3*(xMat(:, j-2) +xMat(:, j+2)) +12*(xMat(:, j-1) +xMat(:, j+1)) +17*xMat(:, j)) /35;
    end
    tmpMat(:, lenTime-1) = (2*(xMat(:, lenTime) +xMat(:, lenTime-4)) +27*xMat(:, lenTime-1) +12*xMat(:, lenTime-2) -8*xMat(:, lenTime-3)) /35;
    tmpMat(:, lenTime) = (69*xMat(:, lenTime) +4* (xMat(:, lenTime-1) +xMat(:, lenTime-3)) -6*xMat(:, lenTime-2) -xMat(:, lenTime-4)) /70;
    % -----------------------------------------------------------------------------------------------------
    xMat = tmpMat;
end
%
yMat = xMat;
%
end
% -----------------------------------------------------------------------------------------------------
%
% 
% 
% 
%






