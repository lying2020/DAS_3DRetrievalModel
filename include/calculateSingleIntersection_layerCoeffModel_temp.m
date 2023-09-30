function Position = calculateSingleIntersection_layerCoeffModel_temp(initialX, Vel, layerCoeffModel, layerGridModel, layerRangeModel)
% the number of refraction points is one
%
F = cell(2, 1);
DF = cell(4, 1);
X1 = initialX(:, 1);
X3 = initialX(:, 3); 
V1 = Vel(1); V2 = Vel(2);
xMat = layerGridModel{1, 1};
yMat = layerGridModel{1, 2};
coeffCellMat = layerCoeffModel{1, 1};
% coeff = coeffCellMat{i_row, i_col}; : 1 *  numCoeff matrix.
% coeff = [a1, a2, ..., a9, a10];
%  f(a, x, y) = a1 + a2 * y +a3 * x + a4 * x * y  + a5 * y * y + a6 * x * x + a7 * y * y * y + a8 * x * y * y + a9 * x * x * y + a10 * x * x * x;

langeRange =  layerRangeModel{1, :};
intervalXY =[langeRange(1, 3), langeRange(2, 3)];  % xMat(2, 1) - xMat(1, 1);
%% Define function likes dz/dx dz^2/dxdy...
func_i_row = @(x) floor((x - langeRange(1, 1)) / intervalXY(1) +1);
func_i_col = @(y) floor((y - langeRange(2, 1)) / intervalXY(2) +1);

  pdzdx = @(X, i_row, i_col) (coeffCellMat{i_row, i_col}(10) * 3 * X(1)^2 + coeffCellMat{i_row, i_col}(9) * 2 * X(1) * X(2) + coeffCellMat{i_row, i_col}(8) * X(2)^2 + ...
                              coeffCellMat{i_row, i_col}(6) * 2 * X(1)    + coeffCellMat{i_row, i_col}(4) * X(2)         +    coeffCellMat{i_row, i_col}(3));

  pdzdy = @(X, i_row, i_col) (coeffCellMat{i_row, i_col}(9) * X(1)^2 + coeffCellMat{i_row, i_col}(8) * 2 * X(1) * X(2) + coeffCellMat{i_row, i_col}(7) * 3 * X(2)^2 + ...
                              coeffCellMat{i_row, i_col}(4) * X(1)   + coeffCellMat{i_row, i_col}(5) * 2 * X(2)     +    coeffCellMat{i_row, i_col}(2));

pdzdxdx = @(X, i_row, i_col) (coeffCellMat{i_row, i_col}(10) * 3 * 2 * X(1) + coeffCellMat{i_row, i_col}(9) * 2 * X(2)  +    coeffCellMat{i_row, i_col}(6) * 2);
pdzdxdy = @(X, i_row, i_col) (coeffCellMat{i_row, i_col}(9) * 2 * X(1)   +    coeffCellMat{i_row, i_col}(8) * 2 * X(2)  +    coeffCellMat{i_row, i_col}(4));
pdzdydy = @(X, i_row, i_col) (coeffCellMat{i_row, i_col}(8) * 2 * X(1)   +    coeffCellMat{i_row, i_col}(7) * 3 * 2 * X(2) + coeffCellMat{i_row, i_col}(5) * 2);

  dzdx  = @(X) pdzdx(  X - [xMat(func_i_row(X(1)), 1),  yMat(1, func_i_col(X(2))), 0]' - [intervalXY/2, 0]', func_i_row(X(1)), func_i_col(X(2)));
  dzdy  = @(X) pdzdy(  X - [xMat(func_i_row(X(1)), 1),  yMat(1, func_i_col(X(2))), 0]' - [intervalXY/2, 0]', func_i_row(X(1)), func_i_col(X(2)));
dzdxdx  = @(X) pdzdxdx(X - [xMat(func_i_row(X(1)), 1),  yMat(1, func_i_col(X(2))), 0]' - [intervalXY/2, 0]', func_i_row(X(1)), func_i_col(X(2)));
dzdxdy  = @(X) pdzdxdy(X - [xMat(func_i_row(X(1)), 1),  yMat(1, func_i_col(X(2))), 0]' - [intervalXY/2, 0]', func_i_row(X(1)), func_i_col(X(2)));
dzdydy  = @(X) pdzdydy(X - [xMat(func_i_row(X(1)), 1),  yMat(1, func_i_col(X(2))), 0]' - [intervalXY/2, 0]', func_i_row(X(1)), func_i_col(X(2)));


%%  
Ftime = @(X) norm(X - X1)/V1 + norm(X3 - X)/V2;

F{1} = @(X) ((X(1) - X1(1)) + (X(3) - X1(3)) * (dzdx(X)))/(V1 * norm(X - X1)) - ...
    ((X3(1) - X(1)) + (X3(3) - X(3)) * (dzdx(X)))/(V2 * norm(X3 - X));
F{2} = @(X) ((X(2) - X1(2)) + (X(3) - X1(3)) * (dzdy(X)))/(V1 * norm(X - X1)) - ...
    ((X3(2) - X(2)) + (X3(3) - X(3)) * (dzdy(X)))/(V2 * norm(X3 - X));


DF{1} = @(X) (1 + dzdx(X) * dzdx(X) + (X(3) - X1(3)) * (dzdxdx(X)))/(V1 * norm(X - X1)) + ...
    (1 + dzdx(X) * dzdx(X) - (X3(3) - X(3)) * (dzdxdx(X)))/(V2 * norm(X3 - X)) - ...
    ((X(1) - X1(1)) + (X(3) - X1(3)) * (dzdx(X)))^2 / (V1 * norm(X - X1)^3) - ...
    ((X3(1) - X(1)) + (X3(3) - X(3)) * (dzdx(X)))^2 / (V2 * norm(X3 - X)^3);

DF{2} = @(X) (dzdx(X) * dzdy(X) + (X(3) - X1(3)) * (dzdxdy(X)))/(V1 * norm(X - X1)) + ...
    (dzdx(X) * dzdy(X) - (X3(3) - X(3)) * (dzdxdy(X)))/(V2 * norm(X3 - X)) - ...
    ((X(1) - X1(1)) + (X(3) - X1(3)) * (dzdx(X))) * ((X(2) - X1(2)) + (X(3) - X1(3)) * (dzdy(X)))/(V1 * norm(X - X1)^3) - ...
    ((X3(1) - X(1)) + (X3(3) - X(3)) * (dzdx(X))) * ((X3(2) - X(2)) + (X3(3) - X(3)) * (dzdy(X)))/(V2 * norm(X3 - X)^3);

DF{3} = @(X) (dzdx(X) * dzdy(X)+(X(3) - X1(3)) * (dzdxdy(X)))/(V1 * norm(X - X1)) + ...
    (dzdx(X) * dzdy(X) - (X3(3) - X(3)) * (dzdxdy(X)))/(V2 * norm(X3 - X)) - ...
    ((X(1) - X1(1)) + (X(3) - X1(3)) * (dzdx(X))) * ((X(2) - X1(2)) + (X(3) - X1(3)) * (dzdy(X)))/(V1 * norm(X - X1)^3) - ...
    ((X3(1) - X(1)) + (X3(3) - X(3)) * (dzdx(X))) * ((X3(2) - X(2)) + (X3(3) - X(3)) * (dzdy(X)))/(V2 * norm(X3 - X)^3);

DF{4} = @(X) (1 + dzdy(X) * dzdy(X)+ (X(3) - X1(3)) * (dzdydy(X)))/(V1 * norm(X - X1)) + ...
    (1 + dzdy(X) * dzdy(X) - (X3(3) - X(3)) * (dzdydy(X)))/(V2 * norm(X3 - X)) - ...
    ((X(2) - X1(2)) + (X(3) - X1(3)) * (dzdy(X)))^2 / (V1 * norm(X - X1)^3) - ...
    ((X3(2) - X(2)) + (X3(3) - X(3)) * (dzdy(X)))^2 / (V2 * norm(X3 - X)^3);

%%
% X0 = initialX(:, 2);
Position = Broydensolver(layerCoeffModel, layerGridModel, layerRangeModel, Ftime, F, DF, initialX, 1e-2, 10);
end