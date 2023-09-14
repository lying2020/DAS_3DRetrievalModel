function Position=calculateSingleIntersection_layerCoeffModel_temp(initialX, Vel, layerCoeffModel, layerGridModel)
% the number of refraction points is one
%  
F=cell(2,1);
DF=cell(4,1);
X1=initialX(:,1); X3=initialX(:,3); 
V1=Vel(1); V2=Vel(2);
xMat = layerGridModel{1,1};
yMat = layerGridModel{1,2};
minx = xMat(1,1);
miny = yMat(1,1);
inter =  xMat(1,2) -  xMat(1,1);
coeff = layerCoeffModel{1,1};
%% Define function likes dz/dx dz^2/dxdy...
id = @(y) floor((y - miny)/inter +1);
jd = @(x) floor((x - minx)/inter +1);
pdzdx = @(X,id,jd) (coeff{id,jd}(1)*3*X(1)^2 + coeff{id,jd}(2)*2*X(1)*X(2) + coeff{id,jd}(3)*X(2)^2 +...
    coeff{id,jd}(5)*2*X(1) + coeff{id,jd}(6)*X(2) + coeff{id,jd}(8));
pdzdy = @(X,id,jd) (coeff{id,jd}(2)*X(1)^2 + coeff{id,jd}(3)*2*X(1)*X(2) + coeff{id,jd}(4)*3*X(2)^2 + ...
    coeff{id,jd}(6)*X(1) + coeff{id,jd}(7)*2*X(2) + coeff{id,jd}(9));
pdzdxdx = @(X,id,jd) (coeff{id,jd}(1)*3*2*X(1) + coeff{id,jd}(2)*2*X(2) + coeff{id,jd}(5)*2);
pdzdxdy = @(X,id,jd) (coeff{id,jd}(2)*2*X(1) + coeff{id,jd}(3)*2*X(2) + coeff{id,jd}(6));
pdzdydy = @(X,id,jd) (coeff{id,jd}(3)*2*X(1) + coeff{id,jd}(4)*3*2*X(2) + coeff{id,jd}(7)*2);
dzdx = @(X) pdzdx(X - [xMat(1,jd(X(1)))  yMat(id(X(2)),1) 0]' - [inter/2  inter/2  0]',id(X(2)),jd(X(1)));
dzdy = @(X) pdzdy(X - [xMat(1,jd(X(1)))  yMat(id(X(2)),1) 0]' - [inter/2  inter/2  0]',id(X(2)),jd(X(1)));
dzdxdx = @(X) pdzdxdx(X - [xMat(1,jd(X(1)))  yMat(id(X(2)),1) 0]' - [inter/2  inter/2  0]',id(X(2)),jd(X(1)));
dzdxdy = @(X) pdzdxdy(X - [xMat(1,jd(X(1)))  yMat(id(X(2)),1) 0]' - [inter/2  inter/2  0]',id(X(2)),jd(X(1)));
dzdydy = @(X) pdzdydy(X - [xMat(1,jd(X(1)))  yMat(id(X(2)),1) 0]' - [inter/2  inter/2  0]',id(X(2)),jd(X(1)));


%%  
Ftime = @(X) norm(X - X1)/V1 + norm(X3 -X)/V2;

F{1} = @(X) ((X(1) - X1(1)) + (X(3) - X1(3))*(dzdx(X)))/(V1*norm(X - X1)) - ...
    ((X3(1) - X(1)) + (X3(3) - X(3))*(dzdx(X)))/(V2*norm(X3 - X));
F{2} = @(X) ((X(2) - X1(2)) + (X(3) - X1(3))*(dzdy(X)))/(V1*norm(X - X1)) - ...
    ((X3(2) - X(2)) + (X3(3) - X(3))*(dzdy(X)))/(V2*norm(X3 - X));


DF{1} = @(X) (1 + dzdx(X)*dzdx(X) + (X(3) - X1(3))*(dzdxdx(X)))/(V1*norm(X-X1)) + ...
    (1 + dzdx(X)*dzdx(X) - (X3(3) - X(3))*(dzdxdx(X)))/(V2*norm(X3-X)) - ...
    ((X(1) - X1(1)) + (X(3) - X1(3))*(dzdx(X)))^2 / (V1*norm(X-X1)^3) - ...
    ((X3(1) - X(1)) + (X3(3) - X(3))*(dzdx(X)))^2 / (V2*norm(X3-X)^3);
DF{2} = @(X) (dzdx(X)*dzdy(X) + (X(3) - X1(3))*(dzdxdy(X)))/(V1*norm(X-X1)) + ...
    (dzdx(X)*dzdy(X) - (X3(3) - X(3))*(dzdxdy(X)))/(V2*norm(X3-X)) - ...
    ((X(1) - X1(1)) + (X(3) - X1(3))*(dzdx(X)))*((X(2) - X1(2)) + (X(3) - X1(3))*(dzdy(X)))/(V1*norm(X-X1)^3) - ...
    ((X3(1) - X(1)) + (X3(3) - X(3))*(dzdx(X)))*((X3(2) - X(2)) + (X3(3) - X(3))*(dzdy(X)))/(V2*norm(X3-X)^3);
DF{3} = @(X) (dzdx(X)*dzdy(X)+(X(3) - X1(3))*(dzdxdy(X)))/(V1*norm(X-X1)) + ...
    (dzdx(X)*dzdy(X) - (X3(3) - X(3))*(dzdxdy(X)))/(V2*norm(X3-X)) - ...
    ((X(1) - X1(1)) + (X(3) - X1(3))*(dzdx(X)))*((X(2) - X1(2)) + (X(3) - X1(3))*(dzdy(X)))/(V1*norm(X-X1)^3) - ...
    ((X3(1) - X(1)) + (X3(3) - X(3))*(dzdx(X)))*((X3(2) - X(2)) + (X3(3) - X(3))*(dzdy(X)))/(V2*norm(X3-X)^3);
DF{4} = @(X) (1 + dzdy(X)*dzdy(X)+ (X(3) - X1(3))*(dzdydy(X)))/(V1*norm(X-X1)) + ...
    (1 + dzdy(X)*dzdy(X) - (X3(3) - X(3))*(dzdydy(X)))/(V2*norm(X3-X)) - ...
    ((X(2) - X1(2)) + (X(3) - X1(3))*(dzdy(X)))^2 / (V1*norm(X-X1)^3) - ...
    ((X3(2) - X(2)) + (X3(3) - X(3))*(dzdy(X)))^2 / (V2*norm(X3-X)^3);

%%  
% X0=initialX(:,2);
Position = Broydensolver(layerCoeffModel,layerGridModel,Ftime,F,DF,initialX,1e-7,10);
end