function  [Position, markX0 ,initialguessVel,errort,trivalt] = RayTrace3D_layerModel_initialed(layerCoeffModel,layerGridModel,VelMod,initialguessVel,X0)
%% Describe:
% The program calculates ray paths for the horizontal layers, when the source and detector position
% are known. A quasi-Newton method called Broyden's method is used to
% approximate the solution to a nonlinear system.
%% INPUT: 
% * VelMod: the acoustic velocity model. ( (NumLayer-1)*1 )
% * Decotor: the position of dector. (Dim*1)
% * Source:  the position of seismic source. (Dim*1)
% * Layer:  layer information.  (function or data)
%% OUTPUT:
% * Position: the position of refraction position. (M*1)

%% CONSTENT
% compute the intersection points (the initial points of iteration) and the
% the corresponding velocity.
iteratorstep = 200;
maxrefractionpoint = 40;
inter = layerGridModel{1,1}(2,2) - layerGridModel{1,1}(1,1);

%%  
countma = 1;
markX0 = zeros(4,maxrefractionpoint,iteratorstep);
markinitialguessVel = zeros(1,maxrefractionpoint,iteratorstep);
nump(countma) = size(X0,2);
markX0(1:4,1:nump(countma),countma) = X0(1:4,:); %  
markinitialguessVel(1,1:nump(countma)-1,countma) = initialguessVel(:);
countma = countma+1;
trivalt(1) = trivaltime(initialguessVel,X0);  
smallt = 1;
countinstop = 10;
countin = 0;
for j=1:iteratorstep
    X00=X0;
    %  
    k=size(X0,2);
    for ii=k-1:-1:2
        iteraX=X0(1:3,[ii-1,ii,ii+1]);
        iteraVelMod=initialguessVel([ii-1,ii]);
        X0(1:3,ii) = calculateSingleIntersection_layerModel_temp(iteraX,iteraVelMod,layerCoeffModel(X0(4,ii)),layerGridModel(X0(4,ii),:));
        errorz = layerz(layerCoeffModel(X0(4,ii)),layerGridModel(X0(4,ii),:),X0(1:2,ii)',1) - X0(3,ii);
        if norm(errorz) > 1e-1
%             warning('z coordinate error wrong');
        end
    end
    move = max(max(abs(X00(1:3,:)-X0(1:3,:))));
    % 
    if k <= 2
        break;
    end
    deleteX0 = [];
    if norm(X0(1:3,k) - X0(1:3,k-1)) < inter/100
        deleteX0(end+1) = k-1;
    end
    if norm(X0(1:3,2) - X0(1:3,1)) < inter/100
        deleteX0(end+1) = 2;
    end
    for iX0 = k-1:-1:3
        if X0(4,iX0) == X0(4,iX0-1)
            if norm(X0(1:3,iX0) - X0(1:3,iX0-1)) < inter
                deleteX0(end+1) = iX0;
            end
        end
    end
    X0(:,deleteX0) = [];
    %  
    clear initialguessVel;
    initialguessVel = zeros(1,size(X0',1)-1);
    for iX0 = 1:size(X0',1)-1
        p = (X0(:,iX0) + X0(:,iX0+1))./2;
        p = p';
        m = size(layerCoeffModel,1);
        xyArray(1:m,1) = p(1,1);
        xyArray(1:m,2) = p(1,2);
        idx = (1:m)';
        z = [layerz(layerCoeffModel,layerGridModel,xyArray,idx);p(1,3)];
        z = sortrows(z,1);
        [row,~] = find(z == p(1,3));
        initialguessVel(iX0) = VelMod(row(1));
    end
    nump(countma) = size(X0,2);
    markX0(1:4,1:nump(countma),countma) = X0(1:4,:);
    markinitialguessVel(1,1:nump(countma)-1,countma) = initialguessVel(:);
    trivalt(countma) = trivaltime(initialguessVel,X0);
    countma = countma+1;
    % 
    if trivalt(end) > trivalt(smallt) - 1e-5  
        countin = countin+1;   
    else
        countin = 0;
    end
    if trivalt(end) < trivalt(smallt)
        smallt = countma-1;
    end
    if move<1e-6
        break
    elseif countin > countinstop
        break
    end
end
Position = markX0(:,1:nump(smallt),smallt);
initialguessVel = markinitialguessVel(1,1:nump(smallt)-1,smallt);
errort = trivalt(1) - trivalt(smallt);
end