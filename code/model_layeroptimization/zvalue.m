%
%
%
%% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-29: Modify the description and comments
% this code is used to obtain the z0 value after fixing x0 and y0 on the discrete surface
%% -----------------------------------------------------------------------------------------------------
function [z0, rc] = zvalue(coeffMat, xMat, yMat, xy0, intervalM)
% -----------------------------------------------------------------------------------------------------
%  INPUT:
% coeffMat: (m -1)*(n -1) cell matrix. the fitting polynomial coefficients set of the corresponding layer.
% each cell contains 1* numCoeff array fitting polynomial coefficients for each grid point.
% xMat, yMat: m* n matrix, grid point data of x, y-direction.
% xy0: 1*2 array. the x, y coordinates of a point on a stratigraphic interface.
% OUTPUT:
% z0: z coordinate of a point with fixed x, y on a stratigraphic interface.
% func_name = mfilename;
% disp(['func_name: ', func_name]);

%% -----------------------------------------------------------------------------------------------------
%
[rLen, cLen] = size(xMat);
xxArray = xMat(:, floor(cLen / 2));    yyArray = yMat(floor(rLen / 2), :);
x0 = xy0(1);  y0 = xy0(2);

% if nargin < 5
%     % intervalM = [10, 10];
%     %% find the average interval of x, y
%     intervalM = [mean(diff(xxArray)), mean(diff(yyArray))];
% end
% 
% intervalX = intervalM(1);  intervalY = intervalM(end);
%% -----------------------------------------------------------------------------------------------------
% % find the grid points, sx, sy, sol is global indexes: sol = xLen*(col - 1) + row;
% %% matrix global index
% % sx1 = find(xMat >= (x0 - intervalX - 1));
% % sx2 = find(xMat <= (x0 + intervalX + 1));
% % % sx = find(abs(xMat - x0) <= intervalX + 1);
% % sx = intersect(sx1, sx2);
% % sy1 = find(yMat >= (y0 - intervalY - 1));
% % sy2 = find(yMat <= (y0 + intervalY + 1));
% % % sy = find(abs(yMat - y0) <= intervalY + 1);
% % sy = intersect(sy1, sy2);
% % sol = intersect(sx, sy);
% %% matrix row and column index.
% % r =  sol - (ceil(sol / rLen) - 1) * rLen;
% % c = ceil(sol / rLen);    %% ceil: round up to an integer
% % rc = [r, c];
% !!! rc may be a null value with the method above.
%% -----------------------------------------------------------------------------------------------------
rc = find_xy0_grid_index(xxArray, yyArray, xy0);
%% -----------------------------------------------------------------------------------------------------
% r = find(abs(xxArray - x0) <= intervalX + 1);
% c = find(abs(yyArray - y0) <= intervalY + 1);
% if (isempty(r) || isempty(c)) 
%     sx1 = find(xxArray >= (x0 - intervalX - 1));
%     if (isempty(sx1)), sx1 = rLen; end
%     sx2 = find(xxArray <= (x0 + intervalX + 1));
%     if (isempty(sx2)), sx2 = 1; end
%     r = intersect(sx1, sx2);
%     sy1 = find(yyArray >= (y0 - intervalY - 1));
%     if (isempty(sy1)), sy1 = cLen; end
%     sy2 = find(yyArray <= (y0 + intervalY + 1));
%     if (isempty(sy2)), sy2 = 1; end
%     c = intersect(sy1, sy2);
% end

% %%
% rowArray = min(r): max(r);
% colArray = min(c): max(c);
% rc0 = [min(r), min(c)];
% %
% % -----------------------------------------------------------------------------------------------------
% % !!! function should never enter this logic
% if isempty(rowArray) || isempty(colArray)
%     z0 = 0;  rc = 0;
%     disp("ERROR FUNCTION -- zvalue, rowArray and colArray could not be empty !!!");
%     return;
% end

% %
% rc = rc0;

% % A more detailed search, finds the unique grid point that contains the target point
% xMat0 = xMat(rowArray, colArray);
% yMat0 = yMat(rowArray, colArray);
% %
% np = 1;
% for ir = 1: length(rowArray)-1
%     for ic = 1:length(colArray)-1
%         px = [xMat0(ir, ic), xMat0(ir, ic+1), xMat0(ir+1, ic+1), xMat0(ir, ic+1)]';
%         py = [yMat0(ir, ic), yMat0(ir, ic+1), yMat0(ir+1, ic+1), yMat0(ir, ic+1)]';
%         flagX = (x0 >= min(px) ) && (x0 < max(px));
%         flagY = (y0 >= min(py) ) && (y0 < max(py));
%         if (flagX && flagY)
%             rc(np, :) = rc0 + [ir, ic] - [1, 1];
%             np = np +1;
%         end
%     end
% end
% %% ---------------------------------------------------------------------------------------------------

%
%% get z0 !!!
coeff = zeros(1, 10);
z0 = zeros(size(rc, 1), 1);
% the normal condition, size(rc, 1) == 1;
for i = 1: size(rc, 1)
    coeff0 = coeffMat{rc(i, 1), rc(i, 2)};
    coeffLen = length(coeff0);
    coeff(1: coeffLen) = coeff0;
    % % function: layerdatafitting
    % Linear | Quadric | Cubic function fitted at mesh point
    gridsfunc = @(x, y) coeff(10)*x.*x.*x + coeff(9)*x.*x.*y + coeff(8)*x.*y.*y + coeff(7)*y.*y.*y + ...
                coeff(6)*x.^2 + coeff(5)*y.^2 + coeff(4)*x.*y + coeff(3)*x + coeff(2)*y + coeff(1)*1;

    % function: cubicsurfacefit
    % gridsfunc = @(x, y) coeff(1)*x.*x.*x + coeff(2)*x.*x.*y + coeff(3)*x.*y.*y + coeff(4)*y.*y.*y + ...
    %             coeff(5)*x.^2 + coeff(6)*y.^2 + coeff(7)*x.*y + coeff(8)*x + coeff(9)*y + coeff(10)*1;

    z0(i) = gridsfunc(x0, y0);
end
%
%
%
end

function rc = find_xy0_grid_index(xxArray0, yyArray0, xy0)
    x0 = xy0(1);  y0 = xy0(2);
    [xx, index_xx] = sort(abs(xxArray0 - x0));
    r = index_xx(1);
    if (abs(xxArray0(index_xx(1)) - xxArray0(index_xx(2))) == (xx(1) + xx(2)))
        r = min(index_xx(1), index_xx(2));
    end

    [yy, index_yy] = sort(abs(yyArray0 - y0));
    c = index_yy(1);
    if (abs(yyArray0(index_yy(1)) - yyArray0(index_yy(2))) == (yy(1) + yy(2)))
        c = min(index_yy(1), index_yy(2));
    end

    rc = [r, c];
end



