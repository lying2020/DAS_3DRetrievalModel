function Result = Broydensolver(layerCoeffModel,layerGridModel, layerRangeModel, Ft,Fun,DFun,initialX,Toler,Maxnumiter)
%%INPUT:
%*Fun:   a cell containing function handle-- such as F=@(X) X(1)+X(2)
%*Toler:
%*Maxnumiter: the maxmum number of iterations
%%OUTPUT:
%*Solution:
% 迭代求解传播时间函数最小值。
X0 = initialX(:,2);
xmax = layerGridModel{1,1}(end,end);
xmin = layerGridModel{1,1}(1,1);
ymax = layerGridModel{1,2}(end,end);
ymin = layerGridModel{1,2}(1,1);
acstep = 0;
numsolution = length(Fun);
F00=zeros(numsolution,1);
DF = zeros(numsolution,numsolution);
X1=[0; 0; X0(3)];X2=[0; 0; X0(3)];
for i =1:1:numsolution
    F00(i) = Fun{i}(X0);
end

count=0;

for i=1:1:numsolution
    for j=1:1:numsolution
        count = count+1;
        DF(i,j) = DFun{count}(X0);
    end
end
ApproJacob=DF;
InvA00=pinv(ApproJacob);
step = InvA00*F00;
if step == 0
    Result = X0;
    return
end
while norm(step) > 100
    step = step/10;
end
while norm(step) < 1 && norm(step) ~=0
    step = step*10;
end
smallt = Ft(X0);
smallX = X0;
X1([1,2]) = X0([1,2]) - step;
if X1(1) < xmin
    X1(1) = xmin+1;
elseif X1(1) > xmax
    X1(1) = xmax-1;
end
if X1(2) < ymin
    X1(2) = ymin+1;
elseif X1(2) > ymax
    X1(2) = ymax-1;
end
step = X1(1:2) -X0(1:2);
if step == 0
    Result = X0;
    return
end
acstep = acstep + norm(step);
X1(3) = layerz_tanyan(layerCoeffModel,layerGridModel,layerRangeModel, X1([1,2])',1);
if smallt > Ft(X1)
    smallt = Ft(X1);
    smallX = X1;
end
F0=F00;
InvA0=InvA00;
for j=1:Maxnumiter
    F1=zeros(numsolution,1);
    for i =1:1:numsolution
        F1(i) = Fun{i}(X1);
    end    
    if acstep > 10
        acstep = 0;
        count=0;
        for i=1:1:numsolution
            for k=1:1:numsolution
                count = count+1;
                DF(i,k) = DFun{count}(X1);
            end
        end
        ApproJacob=DF;
        InvA1=pinv(ApproJacob);
        step =  InvA1*F1;
        if step == 0
            break;
        end
        while norm(step) > 100
            step = step/10;
        end
        X2([1,2]) = X1([1,2]) - step;
        if X2(1) < xmin
            X2(1) = xmin+1;
        elseif X2(1) > xmax
            X2(1) = xmax-1;
        end
        if X2(2) < ymin
            X2(2) = ymin+1;
        elseif X2(2) > ymax
            X2(2) = ymax-1;
        end
        step = X2(1:2) -X1(1:2);
        if step == 0
            Result = X0;
            return
        end
        acstep = acstep + norm(step);
        X2(3) = layerz_tanyan(layerCoeffModel,layerGridModel,layerRangeModel, X2([1,2])',1);
        if smallt > Ft(X2)
            smallt = Ft(X2);
            smallX = X2;
        end
    else
        y1=F1-F0;
        s1=-InvA0*F0;
        InvA1 = InvA0+(1/(s1'*InvA0*y1))*((s1-InvA0*y1)*s1'*InvA0);
        step =  InvA1*F1;
        if step == 0
            break;
        end
        while norm(step) > 100
            step = step/10;
        end
        X2([1,2]) = X1([1,2]) - step;
        if X2(1) < xmin
            X2(1) = xmin+1;
        elseif X2(1) > xmax
            X2(1) = xmax-1;
        end
        if X2(2) < ymin
            X2(2) = ymin+1;
        elseif X2(2) > ymax
            X2(2) = ymax-1;
        end
        step = X2(1:2) -X1(1:2);
        if step == 0
            Result = X0;
            return
        end
        acstep = acstep + norm(step);
        X2(3) = layerz_tanyan(layerCoeffModel,layerGridModel,layerRangeModel, X2([1,2])',1);
        if smallt > Ft(X2)
            smallt = Ft(X2);
            smallX = X2;
        end
    end
    residual = max(abs(X1-X2)) ;
    if residual < Toler
        break
    else
        InvA0 = InvA1;
        X1=X2;
        F0=F1;
    end
end
Result = smallX;
end

