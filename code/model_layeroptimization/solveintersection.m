%
%
%
%% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to solve the intersection of a line segment and a grid surface
%% -----------------------------------------------------------------------------------------------------
function intersection = solveintersection(aa, points, sp, ep, reference_point)
% -----------------------------------------------------------------------------------------------------
% aa: 1* numCoeff array. the fitting polynomial coefficients array of the corresponding point.
% points:  n* numDim  matrix
% sp: startpoint
% ep: endpoint
%
% intersection: num* numDim matrix, 
% Normally, there is only one intersection. num = 1;
%
%% -----------------------------------------------------------------------------------------------------
% zero reference_point
sp = sp - reference_point;
ep = ep - reference_point;
v0 = ep - sp;
%  v0 = [ep(1) - sp(1), ep(2) - sp(2), ep(3) - sp(3)];
%  
coeff = zeros(1, 10);
aaLen = length(aa);
coeff(1: aaLen) = aa;
%% -----------------------------------------------------------------------------------------------------
% Linear | Quadric | Cubic function fitted at mesh point
% gridsfunc = @(x, y) coeff(1)+ coeff(2)*y+ coeff(3)*x+ coeff(4)*x.*y+ coeff(5)*y.^2+ coeff(6)*x.^2 ...
%     + coeff(7)*y.*y.*y+ coeff(8)*x.*y.*y+ coeff(9)*x.*x.*y+ coeff(10)*x.*x.*x;
% -----------------------------------------------------------------------------------------------------
% the parameter expression for the given line
% syms t
% x0 = sp(1) + v0(1)* t;
% y0 = sp(2) + v0(2)* t;
% z0 = sp(3) + v0(3)* t;
% % solve symbolically the intersection point equation
% pt = double(solve( gridsfunc(x0, y0) - z0 == 0, 'Real', true))
%
%% -----------------------------------------------------------------------------------------------------
%  find the intersection of a quadratic/linear/other surface fitting function and the line segment
switch aaLen
    case 3   %  Linear polynomial surface
        % gridsfunc = coeff(1)+ coeff(2)*y0+ coeff(3)*x0;
        pt = ( coeff(1)+ coeff(2)*sp(2)+ coeff(3)*sp(1) - sp(3) ) / (coeff(3) + v0(3) - (coeff(1)+ coeff(2)*v0(2)+ coeff(3)*v0(1)) );
    case 10    % aaLen == 10;                   %  2D-cubic polynomial surface
        pt = solvecubic(coeff, sp, v0);
    otherwise   %  aaLen == 4 || aaLen == 6     %  2D-quadratic polynomial surface
        pt = solvequadratic(coeff, sp, v0);
end
%
% -----------------------------------------------------------------------------------------------------
% delete the point that does not satisfy  $$ interpoint \in [sp, ep]$$.
pt(pt>1) =[];
pt(pt<0) =[];
% pt=sort(pt);
%
% -----------------------------------------------------------------------------------------------------
% ÌÞ³ýÖØ¸´×ø±êÐÐ
% points =  unique(points, 'rows');  % uniquetol(points,1e-6);   %

% intersection = zeros(length(pt), 3);
intersection = [];

% % count = 0;
% X = points(:, 1);
% Y = points(:, 2);
% Z = points(:, 3);
% %
% for it=1:length(pt)
%     tmp = sp + (ep - sp)* pt(it);
%     % Determine if the intersection is within the rectangular region
%     flagX = (tmp(1) >= min(X)) && (tmp(1) <= max(X));
%     flagY = (tmp(2) >= min(Y)) && (tmp(2) <= max(Y));
%     flagZ = (tmp(3) >= min(Z)) && (tmp(3) <= max(Z));
%     if flagX && flagY && flagZ
%         intersection = [intersection; tmp];
%     end
% end

points = points - reference_point;
tolerance = [3.0, 3.0, 5.0];
minCoord = min(points) - tolerance;
maxCoord = max(points) + tolerance; 
for it=1:length(pt)
    tmp = sp + (ep - sp)* pt(it);
    % Determine if the intersection is within the rectangular region
    if all(tmp < maxCoord) && all( tmp > minCoord)
        tmp = tmp + reference_point;
        intersection = [intersection; tmp];
    end
end
% If you have multiple points, you go to an average.   
intersection = mean(intersection, 1);
end
% 
% 
% 
%
%% ----------------------------------------------------------------------------------------------------- 
function realRoot = solvequadratic(coeff, sp, v0)
% ----------------------------------------------------------------------------------------------------- 
% solve a quadratic equation
% gridsfunc(x0, y0) - z0 == 0
% aa(6)* (sp(1) + v0(1)* t).^2 + aa(5)* (sp(2) + v0(2)* t).^2 + aa(4)* (sp(1) + v0(1)* t).* (sp(2) + v0(2)* t) + aa(3)* (sp(1) + v0(1)* t) + aa(2)* (sp(2) + v0(2)* t) + aa(1) - sp(3) - v0(3)*t== 0;
% ----------------------------------------------------------------------------------------------------- 
% m*x^2 + n*x + k = 0;
m =coeff(6)*v0(1)*v0(1) + coeff(5)*v0(2)*v0(2) + coeff(4)*v0(1)*v0(2);
%
n = 2* coeff(6)* sp(1)* v0(1) + 2* coeff(5)* sp(2)* v0(2) + ...
    coeff(4)* sp(1) *v0(2) + coeff(4)* sp(2)* v0(1) + coeff(3)* v0(1) + coeff(2)* v0(2) - v0(3);
%
k = coeff(1) + coeff(2)*sp(2) + coeff(3)*sp(1) + coeff(4)*sp(1)*sp(2) + coeff(5)*sp(2)*sp(2) + coeff(6)*sp(1)*sp(1) - sp(3);
%
realRoot(1) = (-n + sqrt(n*n - 4* m* k)) / (2* m);
realRoot(2) = (-n - sqrt(n* n - 4* m* k)) / (2*m);
if ~isreal(realRoot), realRoot = []; end
%
%
end
% 
% 
% 
%
%% ----------------------------------------------------------------------------------------------------- 
function realRoot = solvecubic(coeff, sp, v0)
% ----------------------------------------------------------------------------------------------------- 
% solve a cubic equation 
% gridsfunc(x0, y0) - z0 == 0;
% coeff(1)+ coeff(2)*y0+ coeff(3)*x0+ coeff(4)*x0.*y0+ coeff(5)*y0.^2+ coeff(6)*x0.^2 ...
% + coeff(7)*y0.*y0.*y0+ coeff(8)*x0.*y0.*y0+ coeff(9)*x0.*x0.*y0+ coeff(10)*x0.*x0.*x0 - z0 = 0;
% ------------------------------------------------------------------------------------------------------
% coeff(1) + coeff(2).*( sp(2) + v0(2)* t) + coeff(3).*(sp(1) + v0(1)* t) +
% coeff(4)*(sp(1) + v0(1)*t).*(sp(2) + v0(2)*t) + coeff(5)*(sp(2) + v0(2)*t).^2 + coeff(6)*(sp(1) + v0(1)*t).^2 +
% coeff(7)*(sp(2) + v0(2)*t).^3 + coeff(8)*(sp(2) + v0(2)*t).*(sp(2) + v0(2)*t).*(sp(1) + v0(1)*t) +
% coeff(10)*(sp(1) + v0(1)*t).^3 + coeff(9)*(sp(2) + v0(2)*t).*(sp(1) + v0(1)*t).*(sp(1) + v0(1)*t) - (sp(3) + v0(3)*t) = 0;
% ------------------------------------------------------------------------------------------------------
% a*x^3 + b*x^2 + c*x + d = 0;   (a != 0)
% 
a = coeff(10)*v0(1)*v0(1)*v0(1) + coeff(9)*v0(1)*v0(1)*v0(2) + coeff(8)*v0(1)*v0(2)*v0(2) + coeff(7)*v0(2)*v0(2)*v0(2);
%
b = coeff(10)*3*sp(1)*v0(1)*v0(1) + coeff(9)*sp(2)*v0(1)*v0(1) + coeff(9)*2*sp(1)*v0(1)*v0(2) + ...
    coeff(7)*3*sp(2)*v0(2)*v0(2) +  coeff(8)*sp(1)*v0(2)*v0(2) + coeff(8)*2*sp(2)*v0(1)*v0(2) + ...
    coeff(6)*v0(1)*v0(1) + coeff(5)*v0(2)*v0(2) + coeff(4)*v0(1)*v0(2);
%
c = coeff(10)*3*sp(1)*sp(1)*v0(1) + coeff(9)*sp(1)*sp(1)*v0(2) + coeff(9)*2*sp(1)*v0(1)*sp(2) + ...
    coeff(7)*3*sp(2)*sp(2)*v0(2) + coeff(8)*sp(2)*sp(2)*v0(1) + coeff(8)*2*sp(1)*v0(2)*sp(2) + ...
    coeff(6)*2*sp(1)*v0(1) + coeff(5)*2*sp(2)*v0(2) + coeff(4)*sp(1)*v0(2) +coeff(4)*sp(2)*v0(1) + ...
    coeff(3)*v0(1) + coeff(2)*v0(2) - v0(3);
%
d = coeff(10)*sp(1)*sp(1)*sp(1) + coeff(9)*sp(1)*sp(1)*sp(2) + coeff(8)*sp(1)*sp(2)*sp(2) + coeff(7)*sp(2)*sp(2)*sp(2) + ...
    coeff(6)*sp(1)*sp(1) + coeff(5)*sp(2)*sp(2) + coeff(4)*sp(1)*sp(2) + coeff(3)*sp(1) + coeff(2)*sp(2) + coeff(1) - sp(3);
%
realRoot = [];
tmp = roots([a b c d]);
for iroot = 1 : length(tmp)
    if isreal(tmp(iroot)),  realRoot = [realRoot, tmp(iroot)];    end
end
% %% ---------------------------------------------------------------------------------------------------------------------------
% % Cardan formula !!!
% % y^3 + py +q = 0;
% p0 = (3*a*c - b*b)/(3*a*a);
% %
% q0 = (2*b*b*b - 9*a*b*c + 27*a*a*d) / (27*a*a*a);
% %
% delta0 =q0*q0/4 + p0*p0*p0/27;
% %
% omega1 = (-1 + 1.732050807568877i )*0.5;
% omega2 = (-1 - 1.732050807568877i )*0.5;
% t1 = [1; omega1; omega2];
% t2 = [1; omega2; omega1];
% realRoot = [];
% % delete the imaginary root.
% for iroot = 1:3
%     tmp = - b/(3*a) + t1(iroot)*(-0.5*q0 + sqrt(delta0) )^(1/3) + t2(iroot)*(-0.5*q0 - sqrt(delta0) )^(1/3);
%     if isreal(tmp),  realRoot = [realRoot, tmp];    end
% end
% %% ------------------------------------------------------------------------------------------------------------------------------
% 
%
end




