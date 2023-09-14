clear

for  l= 1:10000
fitdata = rand(4,4);
inter = 1;

coeff = thirdfit(fitdata,inter);

func = @(x)coeff(1) * x(1)*x(1)*x(1) + coeff(2) * x(1)*x(1)*x(2) + ...
    coeff(3) * x(1)*x(2)*x(2) + coeff(4) * x(2)*x(2)*x(2) +...
    coeff(5) * x(1)*x(1)      + coeff(6) * x(1)*x(2)      +  coeff(7) * x(2)*x(2) + ...
    coeff(8) * x(1)           + coeff(9) * x(2)           +  coeff(10) * 1;

% options = optimoptions('fmincon','ConstraintTolerance',1e-2,'Display','off');%'PlotFcn', @gaplotbestf,
% [k,minz] = fmincon(func,[0 0],[],[],[],[],[-inter/2,-inter/2],[inter/2,inter/2],[],options);
% options = optimoptions('ga','ConstraintTolerance',1e-2,'Display','off');%'PlotFcn', @gaplotbestf,
% [k,minz] = ga(func,2,[],[],[],[],[-inter/2,-inter/2],[inter/2,inter/2],[],options);
% plot3(k(1),k(2),minz,'b.','markersize',10);
% hold on;
% 
% x = -3*inter/2: 0.01:3*inter/2;
% y = x;
% [X,Y] = meshgrid(x,y);
% [row,col] = size(X);
% for i = 1:row
%     for j =1:col
%         Z(i,j) = func([X(i,j),Y(i,j)]);
%     end
% end
% mesh(X,Y,Z);
% hold on
% for i =1:4
%     for j = 1:4
%         x = i*inter - 2.5*inter;
%         y = j*inter - 2.5*inter;
%         z = fitdata(i,j);
%         plot3(x,y,z,'r.','markersize',10)
%     end
%     endXs
end
