function t = solveLineCubicPolynomial(coeff,startpoint,endpoint)
%%  求解直线与二元三次多项式交代
%% input:  
%          coeff  10*1矩阵，依次对应x^3 x^2y xy^2 y^3 x^2 xy y^2 x y 1的系数
%          startpoint endpoint  线段的端点。需要将端点坐标平移，使得零点点在拟合多项式拟合的小正方行中心。
%% output:
%          t  交点在线段的t表达式中t的值，startpoint为0.

%% 将多项式转化为t的一元三次方程 t3,t2,t1,t0为该方程系数
% tol = 1e-5;
% tx=@(t) startpoint(1) + (endpoint(1) - startpoint(1))*t;
% ty=@(t) startpoint(2) + (endpoint(2) - startpoint(2))*t;
% tz=@(t) startpoint(3) + (endpoint(3) - startpoint(3))*t;

 x = startpoint(1); y = startpoint(2); z = startpoint(3);
 cox = endpoint(1) - startpoint(1);
 coy = endpoint(2) - startpoint(2);
 coz = endpoint(3) - startpoint(3);

    t0 = coeff(1)* x^3 + coeff(2)* x^2*y + coeff(3)* x*y^2 + coeff(4) * y^3 + ...
        coeff(5)* x^2 + coeff(6)* x*y   + coeff(7)* y^2 + ...
        coeff(8)* x   + coeff(9)* y + coeff(10) - z;
    t1 = coeff(1)*3*cox*x^2 + coeff(2)*(2*cox*x*y + x^2*coy) + coeff(3)*(cox*y^2 + 2*x*coy*y) + coeff(4)*3*coy*y^2+...
        coeff(5)*2*cox*x + coeff(6) *(cox*y + x*coy) + coeff(7) * 2*coy*y + coeff(8) * cox + coeff(9) * coy - coz;
    t2 = coeff(1)*3*cox^2*x + coeff(2)*(cox^2*y + 2*cox*x*coy) + coeff(3)*( 2*cox*y*coy + x*coy^2) + coeff(4)*3*coy^2*y+...
        coeff(5)*cox^2 + coeff(6)*cox*coy + coeff(7)*coy^2;
    t3 = coeff(1)* cox^3 + coeff(2)* cox^2 * coy + coeff(3)* cox* coy^2 + coeff(4)*coy^3;
    coet = [t3 t2 t1 t0];

%     coexxx = coeff(1)* [ cox*cox*cox  3*cox*cox*x              3*cox*x*x           x*x*x];
%     coexxy = coeff(2)* [ cox*cox*coy  2*cox*x*coy + cox*cox*y  2*cox*x*y + x*x*coy x*x*y];
%     coexyy = coeff(3)* [ cox*coy*coy  2*cox*y*coy + x*coy*coy  2*x*coy*y + cox*y*y x*y*y];
%     coeyyy = coeff(4)* [ coy*coy*coy  3*coy*coy*y              3*coy*y*y           y*y*y];
%     coexx  = coeff(5)* [ 0            cox*cox                  2*cox*x             x*x  ];
%     coexy  = coeff(6)* [ 0            cox*coy                  cox*y + coy*x       x*y  ];
%     coeyy  = coeff(7)* [ 0            coy*coy                  2*coy*y             y*y  ];
%     coex   = coeff(8)* [ 0            0                        cox                 x    ];
%     coey   = coeff(9)* [ 0            0                        coy                 y    ];
%     coe1   = coeff(10)*[ 0            0                        0                   1    ];
%     coez   = -1      * [ 0            0                        coz                 z    ];
%     coet = coexxx+coexxy+coexyy+coeyyy+coexx+coexy+coeyy+coex+coey+coe1+coez;
%     
% syms x
% eqn = t3*x^3 + t2*x^2+ t1*x + t0 == 0;
% t = solve(eqn, x,'MaxDegree', 3,'Real',true);
% t = eval(t);
root = roots(coet);
num =length(root);
t = [];
for i= 1:num
    if isreal(root(i))
        t(end+1) = root(i);
    end
end
end
    