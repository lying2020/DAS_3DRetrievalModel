function chazhi

% griddedInterpolant   

xgv = -1.5:0.25:1.5;

ygv = -3:0.5:3;
 
[X,Y] = ndgrid(xgv,ygv);



% Create two distinct value sets for this grid



V1 = X.^3 - 3*(Y.^2);

V2 = 0.5*(X.^2) - 0.5*(Y.^2);



% Now create an interpolant for the first value set

F = griddedInterpolant(X,Y,V1, 'cubic');

xqgv = -1.5:0.1:1.5;

yqgv = -3:0.1:3;

[Xq,Yq] = ndgrid(xqgv,yqgv);



Vq1 = F(Xq,Yq);
figure

surf(Xq,Yq,Vq1);

title('Cubic Interpolation of V1 Dataset', 'fontweight','b');

F.Values = V2

Vq2 = F(Xq,Yq);

figure

surf(Xq,Yq,Vq2);

title('Cubic Interpolation of V2 Dataset', 'fontweight','b');

%% --------------------------------------------------------------------------------------------

V = peaks(10);

F = griddedInterpolant(V,'cubic')

firstgridvector = F.GridVectors{1}

secondgridvector = F.GridVectors{2}

Vq = F({1:0.5:10, 1:0.5:10});

figure

surf(V);

title('Sample Values', 'fontweight','b');



figure

surf(Vq);

title('Cubic Interpolation using a Compact Grid', 'fontweight','b');


%% ----------------------------------------------------------------------------------------------

% 样本数据集

[X, Y, Z] = ndgrid(1:100);

V = X.^2 + Y.^2 + Z.^2;


% INTERPN的性能数据

tic;

for i = 1:1000

   Xq = 100*rand();

   Yq = 100*rand();

   Zq = 100*rand();

   Vq = interpn(X,Y,Z,V,Xq,Yq,Zq,'cubic');

end

interpnTiming = toc

tic;

% 网格代理性能数据
F = griddedInterpolant(X,Y,Z,V, 'cubic');

for i = 1:1000

   Xq = 100*rand();

   Yq = 100*rand();

   Zq = 100*rand();

   Vq = F(Xq,Yq,Zq);

end

griddedInterpolantTiming = toc















end

















