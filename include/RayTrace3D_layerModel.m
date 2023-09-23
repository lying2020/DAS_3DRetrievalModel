function  [Position, markX0 , initialguessVel, errort, trivalt] = RayTrace3D_layerModel(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorCoord, sourceCoord)
%% Describe:
% The program calculates ray paths for the horizontal layers, when the source and sensor position
% are known. A quasi-Newton method called Broyden's method is used to
% approximate the solution to a nonlinear system.
%% INPUT: 
% * velocityModel: the acoustic velocity model. ( (NumLayer-1)*1 )
% * sensorCoord: the position of dector. (Dim*1)
% * sourceCoord:  the position of seismic source. (Dim*1)
% * Layer:  layer information.  (function or data)
%% OUTPUT:
% * Position: the position of refraction position. (M*1)

%% CONSTENT
% compute the intersection points (the initial points of iteration) and the
% the corresponding velocity.
iteratorstep = 200;
maxrefractionpoint = 40;

%% 
if (sourceCoord(3) == sensorCoord(3))
    sourceCoord(3) = sourceCoord(3) + 1e-6;
end
[intersecp, idxLayer]=computelayerintersectscoords(layerCoeffModel, layerGridModel, layerRangeModel, sourceCoord, sensorCoord);
initialguess = intersecp;
intervalXY = layerGridModel{1, 1}(2, 2) - layerGridModel{1, 1}(1, 1);


%% 
% [initialguess, ia]= sortrows([sourceCoord; initialguess; sensorCoord], 3);
if isempty(initialguess)
    if sourceCoord(3) < sensorCoord(3)
        initialguess = [sourceCoord; initialguess; sensorCoord];
    else
        initialguess = [sensorCoord; initialguess; sourceCoord];
    end
else
    [initialguess, ia]= sortrows(initialguess, 3);
    idxLayer = idxLayer(ia)';
    if sourceCoord(3) < sensorCoord(3)
        initialguess = [sourceCoord; initialguess; sensorCoord];
    else
        initialguess = [sensorCoord; initialguess; sourceCoord];
    end
end

%%
initialguess= initialguess';
X0=[initialguess;0 idxLayer' 0] ;
k = size(X0, 2);
if k <= 2

else
    deleteX0 = [];
    if norm(X0(1:3, k) - X0(1:3, k-1)) < intervalXY/10
        deleteX0(end+1) = k-1;
    end
    if norm(X0(1:3, 2) - X0(1:3, 1)) < intervalXY/10
        deleteX0(end+1) = 2;
    end
    for iX0 = k-1:-1:3
        if X0(4, iX0) == X0(4, iX0-1)
            if norm(X0(1:3, iX0) - X0(1:3, iX0-1)) < intervalXY
                deleteX0(end+1) = iX0;
            end
        end
    end
    X0(:, deleteX0) = [];
end
%
clear initialguessVel;
initialguessVel = zeros(1, size(X0', 1)-1);
for iX0 = 1:size(X0', 1)-1
    p = (X0(:, iX0) + X0(:, iX0+1))./2;
    p = p';
    m = size(layerCoeffModel, 1);
    xyArray(1:m, 1) = p(1, 1);
    xyArray(1:m, 2) = p(1, 2);
    idx = (1:m)';
    z = [computelayerz(layerCoeffModel, layerGridModel, layerRangeModel, xyArray, idx); p(1, 3)];
    z = sortrows(z, 1);
    [row, ~] = find(z == p(1, 3));
    initialguessVel(iX0) = velocityModel(row(1));
end

%%
countma = 1;
markX0 = zeros(4, maxrefractionpoint, iteratorstep);
markinitialguessVel = zeros(1, maxrefractionpoint, iteratorstep);
nump(countma) = size(X0, 2);
markX0(1:4, 1:nump(countma), countma) = X0(1:4, :); %  
markinitialguessVel(1, 1:nump(countma)-1, countma) = initialguessVel(:);
countma = countma+1;
trivalt(1) = trivaltime(initialguessVel, X0); %  
smallt = 1;
countinstop = 10;
countin = 0;
for j=1:iteratorstep
    X00=X0;
    %
    k=size(X0, 2);
    for ii=k-1:-1:2
        iteraX=X0(1:3, [ii-1, ii, ii+1]);
        iteraVelMod=initialguessVel([ii-1, ii]);
        X0(1:3, ii) = calculateSingleIntersection_layerCoeffModel_temp(iteraX, iteraVelMod, layerCoeffModel(X0(4, ii)), layerGridModel(X0(4, ii), :), layerRangeModel(X0(4, ii), :));
        errorz = computelayerz(layerCoeffModel(X0(4, ii)), layerGridModel(X0(4, ii), :), layerRangeModel(X0(4, ii), :), X0(1:2, ii)', 1) - X0(3, ii);
        if norm(errorz) > 1
%             warning('z coordinate error wrong');
        end
    end
    move = max(max(abs(X00(1:3, :)-X0(1:3, :))));
    % 
    if k <= 2
        break;
    end
    deleteX0 = [];
    if norm(X0(1:3, k) - X0(1:3, k-1)) < intervalXY/100
        deleteX0(end+1) = k-1;
    end
    if norm(X0(1:3, 2) - X0(1:3, 1)) < intervalXY/100
        deleteX0(end+1) = 2;
    end
    for iX0 = k-1:-1:3
        if X0(4, iX0) == X0(4, iX0-1)
            if norm(X0(1:3, iX0) - X0(1:3, iX0-1)) < intervalXY
                deleteX0(end+1) = iX0;
            end
        end
    end
    X0(:, deleteX0) = [];
    clear initialguessVel;
    initialguessVel = zeros(1, size(X0', 1)-1);
    for iX0 = 1:size(X0', 1)-1
        p = (X0(:, iX0) + X0(:, iX0+1))./2;
        p = p';
        m = size(layerCoeffModel, 1);
        xyArray(1:m, 1) = p(1, 1);
        xyArray(1:m, 2) = p(1, 2);
        idx = (1:m)';
        z = [computelayerz(layerCoeffModel, layerGridModel, layerRangeModel, xyArray, idx);p(1, 3)];
        z = sortrows(z, 1);
        [row, ~] = find(z == p(1, 3));
        initialguessVel(iX0) = velocityModel(row(1));
    end
    nump(countma) = size(X0, 2);
    markX0(1:4, 1:nump(countma), countma) = X0(1:4, :);
    markinitialguessVel(1, 1:nump(countma)-1, countma) = initialguessVel(:);
    trivalt(countma) = trivaltime(initialguessVel, X0);
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
Position = markX0(:, 1:nump(smallt), smallt);
initialguessVel = markinitialguessVel(1, 1:nump(smallt)-1, smallt);
errort = trivalt(1) - trivalt(smallt);
if size(Position, 2) ~= size(initialguessVel, 2)+1
    r = 0;
end
end

