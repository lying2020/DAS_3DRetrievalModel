clear
tArray = [];
transit = [1000 1000 1000];
%for i = 1:100
coeff = rand(10,1);
startpoint = rand(3,1) + transit;
endpoint = rand(3,1)+ transit;
% startpoint = p1;
% endpoint = p2;
    
    tx=@(t) startpoint(1) + (endpoint(1) - startpoint(1))*t;
ty=@(t) startpoint(2) + (endpoint(2) - startpoint(2))*t;
tz=@(t) startpoint(3) + (endpoint(3) - startpoint(3))*t;
ts = -100:0.01:100;
x = tx(ts);y = ty(ts); z = tz(ts);
    
    func = @(x) coeff(1) * x(1)*x(1)*x(1) + coeff(2) * x(1)*x(1)*x(2) + ...
        coeff(3) * x(1)*x(2)*x(2) + coeff(4) * x(2)*x(2)*x(2) +...
        coeff(5) * x(1)*x(1)      + coeff(6) * x(1)*x(2)      +  coeff(7) * x(2)*x(2) + ...
        coeff(8) * x(1)           + coeff(9) * x(2)           +  coeff(10) * 1;
%     xrang = sort([startpoint(1) endpoint(1)]);
%     yrang = sort([startpoint(2) endpoint(2)]);
%     zrang = sort([startpoint(3) endpoint(3)]);
    X = -10+transit(1):0.1:+10+transit(1);
    Y = -10+transit(2):0.1:+10+transit(2);
    row = size(Y,2);
    col = size(X,2);
    for i = 1:row
        for j = 1:col
            Z(i,j) = func([X(j) Y(i)] - transit(1:2))+transit(3);
        end
    end
    mesh(X,Y,Z);hold on
%     shading( 'faceted');
    plot3(x,y,z); hold on
    
    t = solveLineCubicPolynomial(coeff,startpoint- transit(1),endpoint - transit(2));
    a = tx(t);b = ty(t); c = tz(t);
    plot3(a,b,c,'b.','markersize',30); hold on
    tArray = [tArray, t];
%end