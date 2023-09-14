%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-07-06: modify the staltaloop recursion function
% characteristicfunc is a characteristic function.
%% -----------------------------------------------------------------------------------------------------
function tmp = characteristicfunc(x)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% x is a m*(n + 1) matrix
%
% OUTPUT:
% tmp is a m*1 vetor
% 
% -----------------------------------------------------------------------------------------------------
% 
% % cf # 1   cf(i) = x(i)^2
%  tmp0 = x(:, 2:end).*x(:, 2:end);
% 
% % cf # 2   cf(i) = x(i)^2 + |x(i) - x(i -1)|
tmp0 = x(:, 2:end).*x(:, 2:end)  + abs(x(:, 2:end) - x(:, 1:(end - 1)) ); 
% 
%  cf # 3  cf(i) = x(i)^2 + |x(i) - x(i -1)|^2
% tmp0 = x(:, 2:end).*x(:, 2:end) + (x(:, 2:end) - x(:, 1:(end - 1))).* (x(:, 2:end) - x(:, 1:(end - 1) ));
% 
% %  cf # 4  cf(i) = abs(x(i));
%  tmp0 = abs(x(:, 2:end));
% 
% %  cf # 5  cf(i) = |x(i) - x(i -1)|
%  tmp0 = abs(x(:, 2:end) - x(:, 1:(end - 1)) ); 
% 
tmp = sum(tmp0, 2);
% 
end





