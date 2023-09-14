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
function yMat = smoothmean(xMat, m, method)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% xMat: num*lenTime matrix, original data.
% m: number of smooth
% method:  {'moving', 'lowess', 'loess', 'sgolay', 'rlowess', 'rloess'};
% OUTPUT:
% yMat:
% -----------------------------------------------------------------------------------------------------
%    Z = SMOOTH(Y) smooths data Y using a 5-point moving average.
%
%   Z = SMOOTH(Y,SPAN) smooths data Y using SPAN as the number of points used
%   to compute each element of Z.
%
%   Z = SMOOTH(Y,SPAN,METHOD) smooths data Y with specified METHOD. The
%   available methods are:
%
%           'moving'   - Moving average (default)
%           'lowess'   - Lowess (linear fit)
%           'loess'    - Loess (quadratic fit)
%           'sgolay'   - Savitzky-Golay
%           'rlowess'  - Robust Lowess (linear fit)
%           'rloess'   - Robust Loess (quadratic fit)
%% -----------------------------------------------------------------------------------------------------
%  some parameters set.   
if nargin < 3, method = 'moving';   end
if nargin < 2, m = 5;    end
% -----------------------------------------------------------------------------------------------------
enum = {'moving', 'lowess', 'loess', 'sgolay', 'rlowess', 'rloess'};
% isMethod is a logical array.  
isMethod = strcmpi(method, enum); 

if ~any(isMethod)
    warning('func: smoothmean -- an error method string ! '); 
    yMat = xMat;
    return;   
end
    
[num, lenTime] = size(xMat);
%
yMat = zeros(num, lenTime);
tmp = zeros(lenTime, 1);
% 
for i = 1:num 
    tmp(:) = xMat(i, :);
    tmp = smooth(tmp,m, method);  
    yMat(i, :) = tmp;
%     
end

end















