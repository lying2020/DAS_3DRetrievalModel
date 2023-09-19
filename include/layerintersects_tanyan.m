%
%
%% ----------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to calculate where the line intersects each layer
function  [intersection, idxLayer, point]  = layerintersects_tanyan(layerCoeffModel,layerGridModel, layerRangeModel, startpoint, endpoint)
%% INTRODUCTION
% calculate the intersection points of a given surface and a given line
%% INPUT
% layerGridModel: n*3cell 每行是一个地层的{xMat,yMat,zMat}.地层默认从高到低排列。
% layerCoeffModel:    n*1cell 每个cell对应每个地层在每个网格上的三次多项式拟合参数。
% startpoint: The starting point of the given line; (1* numDim matrix )
% endpoint: The ending point of the given line; (1* numDim matrix )

%% OUTPUT
% intersection: The intersection points of the given surface and the given line
% idxLayer: The index corresponding to the layer where the intersection is
% located。默认顺序为从上到下。
%% --------------------------------------------------------
%
if isa(layerGridModel{1}, 'function_handle')
[intersection, idxLayer]  = layerintersection_curve(layerGridModel, startpoint, endpoint);
point = [];
return;
end
%%  将地层按z值从小到大排序
numLayer = size(layerGridModel,1);
xMat = cell(numLayer,1);
yMat = cell(numLayer,1);
zMat = cell(numLayer,1);
% for iLayer = 1:numLayer
%     zMat{iLayer} = layerGridModel{iLayer,3};
%     meanZ(iLayer, 1) = zMat{iLayer}(1,1);
% end
% [~, idxZ] = sort(meanZ, 'descend');
% layerGridModel = layerGridModel(idxZ, :);
% layerCoeffModel = layerCoeffModel(idxZ,:);
tolt = 1e-2;

%%  将每个地层的Mat裁剪到最小的包含startpoint和endpoint的网格。
inter = layerGridModel{1}(1,2) - layerGridModel{1}(1,1);
xrange = sort([startpoint(1) endpoint(1)]);
yrange = sort([startpoint(2) endpoint(2)]);
point = [];
countpoints = 1;
%z = sort([startpoint(3) endpoint(3)]);
idown = zeros(numLayer,1);
jdown = zeros(numLayer,1);
iup = zeros(numLayer,1);
jup = zeros(numLayer,1);
for iLayer = 1:numLayer
    xMat{iLayer,1} = layerGridModel{iLayer,1};
    yMat{iLayer,1} = layerGridModel{iLayer,2};
    zMat{iLayer,1} = layerGridModel{iLayer,3};
    jdown(iLayer) = floor((xrange(1) - xMat{iLayer}(1,1) )/inter)+1;
    if jdown(iLayer) < 1
        jdown(iLayer) = 1;
    end
    idown(iLayer) = floor((yrange(1) - yMat{iLayer}(1,1) )/inter)+1;
    if idown(iLayer) < 1
        idown(iLayer) = 1;
    end
    jup(iLayer) = floor((xrange(2) - xMat{iLayer}(1,1) )/inter)+2;
    if xrange(2) >= xMat{iLayer}(end,end)
        jup(iLayer) = size(xMat,2);
    end
    iup(iLayer) = floor((yrange(2) - yMat{iLayer}(1,1) )/inter)+2;
    if yrange(2) >= yMat{iLayer}(end,end)
        iup(iLayer) = size(xMat,1);
    end
end

%%   定义线段的t表达式和计算函数
tx=@(t) startpoint(1) + (endpoint(1) - startpoint(1))*t;
ty=@(t) startpoint(2) + (endpoint(2) - startpoint(2))*t;
tz=@(t) startpoint(3) + (endpoint(3) - startpoint(3))*t;
% slopez = (endpoint(3) - startpoint(3))/min([(endpoint(1) - startpoint(1)) (endpoint(2) - startpoint(2))]);
normalx = 0; normaly = 0;
if jup - jdown(1) < 2
    normalx = 1;
else
    xt = @(x) (startpoint(1) - x)/(startpoint(1) - endpoint(1));
end
if iup - idown(1) < 2
    normaly = 1;
else
    yt = @(y) (startpoint(2) - y)/(startpoint(2) - endpoint(2));
end
 
tArray = [];
tintersection = [];
idxLayer = [];
allbad = [];
%% 找到xy平面上网格与线段在xy平面上的投影线段的所有交点
if normalx == 1 && normaly == 1
    % 此时线段几乎垂直，在xy平面上的投影都在一个网格内部，找到这个网格，对所有地层在这个网格的多项式和线段求交
    for iLayer = 1:numLayer
        % id = idown(iLayer); jd = idown(iLayer);
        jd = floor((xrange(1) - xMat{iLayer}(1,1))/inter)+1;
        id = floor((yrange(1) - yMat{iLayer}(1,1))/inter)+1;
        if idown(iLayer) <= id && id <= iup(iLayer) && jdown(iLayer) <= jd && jd <= jup(iLayer)
            coeff = layerCoeffModel{iLayer}{idown(iLayer),jdown(iLayer)};
            xcoord = xMat{iLayer}(id,jd)+inter/2; ycoord = yMat{iLayer}(id,jd)+inter/2;
            sp = startpoint - [xcoord ycoord 0];
            ep = endpoint - [xcoord ycoord 0];
            t = solveLineCubicPolynomial(coeff,sp,ep);
            t = t(t>=0); t = t(t <=1);
            tintersection = [tintersection t];
            markbad = zeros(1,size(t,2));
            allbad = [allbad markbad];
            idxLayer = [idxLayer iLayer*ones(1,size(t,2))];
            if size(t,2) > 0
                point{countpoints} = [xMat{iLayer}(id,jd) yMat{iLayer}(id,jd) zMat{iLayer}(id,jd);
                    xMat{iLayer}(id,jd+1) yMat{iLayer}(id,jd+1) zMat{iLayer}(id,jd+1);
                    xMat{iLayer}(id+1,jd) yMat{iLayer}(id+1,jd) zMat{iLayer}(id+1,jd);
                    xMat{iLayer}(id+1,jd+1) yMat{iLayer}(id+1,jd+1) zMat{iLayer}(id+1,jd+1)];
                countpoints = countpoints+1;
            end
        end
    end
else
    iupbound = max(iup);
    idobound = min(idown);
    jupbound = max(jup);
    jdobound = min(jdown);
    countt = 1;
    if normaly == 0
        for iMat = 1:1: (iupbound  - idobound)-1
            tArray(countt) = yt( yMat{1}(iMat+idown(1),1));
            countt = countt+1;
        end
    end
    if normalx == 0
        for jMat = 1:1: (jupbound - jdobound)-1
            tArray(countt) = xt( xMat{1}(1,jMat+jdown(1)));
            countt = countt+1;
        end
    end
    tArray = tArray(tArray>=0); 
    tArray = tArray(tArray<=1);
    tArray = sort(tArray);
    numt = size(tArray,2);
%%     遍历网格正方形
%      tArray内都是线段上与网格交点的t值，每两个t值对应的交点在同一个网格正方形边上，
%      因此依次迭代可以遍历所有与线段在xy平面上投影相交的数据网格。
%      然后根据网格上的多项式和z值合理判断并进行交点运算。
    for it = 0:numt
        if it > 0 && it < numt
        p1 = p2;
        p2 = [ tx(tArray(it+1))  ty(tArray(it+1)) p3z];
        elseif it == 0
            p1 = [ tx(0)  ty(0) tz(0)];
            p2 = [ tx(tArray(1))  ty(tArray(1)) tz(tArray(1))];
        elseif it == numt
             p1 = p2;
             p2 = [ tx(1)  ty(1) p3z];
        end
        if it > 1
            p0z =  tz(tArray(it-1));
        else
            p0z =  tz(0);
        end
        if it < numt-1
            p3z =  tz(tArray(it+2));
        else
            p3z =  tz(1);
        end
        linez = sort([p0z p3z]);
        x = min([p1(1) p2(1)]); y = min([p1(2) p2(2)]);
        for iLayer = 1:numLayer
            jd = floor((x - xMat{iLayer}(1,1))/inter)+1;
            id = floor((y - yMat{iLayer}(1,1))/inter)+1;
            if idown(iLayer) <= id && id <= iup(iLayer) && jdown(iLayer) <= jd && jd <= jup(iLayer)
                domainz = [zMat{iLayer}(id,jd) zMat{iLayer}(id+1,jd) zMat{iLayer}(id+1,jd+1) zMat{iLayer}(id,jd+1)];
                domainz = sort(domainz);
%                 maxz = domainz(4); minz = domainz(1);
                %if (4*maxz - 3*minz - linez(1)+ 2*slopez * inter) * (4*minz - 3*maxz - linez(2) - 2*slopez * inter) < 0 %  当线段的z值范围与正方形顶点z值范围接近时判断有解
                if (4*domainz(4) - 3*domainz(1) - linez(1)) * (4*domainz(1) - 3*domainz(4) - linez(2)) < 0     
                    coeff = layerCoeffModel{iLayer}{id,jd};
                    xcoord = xMat{iLayer}(id,jd)+inter/2; ycoord = yMat{iLayer}(id,jd)+inter/2;
                    transp1 = p1 - [xcoord ycoord 0];
                    transp2 = p2 - [xcoord ycoord 0];
                    t = solveLineCubicPolynomial(coeff,transp1,transp2);  % 求交点以及添加容忍度
                    tless0 = t(t < 0);tless0 = tless0(tless0 > -tolt);
                    tbig1  = t(t > 1);tbig1  = tbig1 (tbig1 < 1 +tolt);
                    t = t(t >=0);t = t(t <=1);
                    bad0 = 0; bad1 = 0;
                    if ~isempty(tless0)
                        t = [0 t]; bad0 = 1;
                    end
                    if ~isempty(tbig1)
                        t = [t 1]; bad1 = 1;
                    end
                   % xco = transp1(1) + (transp2(1) - transp1(1))*t;
                    markbad = zeros(1,size(t,2));
                    if bad0 == 1
                        markbad(1) = 1;
                    end
                    if bad1 == 1
                        markbad(end) = 1;
                    end
                    allbad = [allbad markbad];
                    if normalx == 0
                        xco = transp1(1) + (transp2(1) - transp1(1))*t;
                        %t = xt(xco + xcoord);
                        t = (startpoint(1) - xco - xcoord)/(startpoint(1) - endpoint(1));
                    else
                        yco = transp1(2) + (transp2(2) - transp1(2))*t;
                        t = yt(yco + ycoord);
                    end
                    %t = t(t >=tArray(it)); t = t(t <=tArray(it+1));
                    tintersection = [tintersection t];
                    idxLayer = [idxLayer iLayer*ones(1,size(t,2))];
                    if size(t,2) > 0
                        point{countpoints} = [xMat{iLayer}(id,jd) yMat{iLayer}(id,jd) zMat{iLayer}(id,jd);
                            xMat{iLayer}(id,jd+1) yMat{iLayer}(id,jd+1) zMat{iLayer}(id,jd+1);
                            xMat{iLayer}(id+1,jd) yMat{iLayer}(id+1,jd) zMat{iLayer}(id+1,jd);
                            xMat{iLayer}(id+1,jd+1) yMat{iLayer}(id+1,jd+1) zMat{iLayer}(id+1,jd+1)];
                        countpoints = countpoints+1;
                    end
                end
            end
        end
    end
end
intersection = [];
%%  去除tintersection中的重复点，并转化成输出格式。以startpoint到endpoint的方向排序
if ~isempty(tintersection)
[tintersection ,ia] =  uniquetol(tintersection,1e-6);
idxLayer = idxLayer(ia);
allbad = allbad(ia);
num = size(tintersection,2);
intersection = zeros(num,3);
for i = 1:num
    intersection(i,1) = tx(tintersection(i));
    intersection(i,2) = ty(tintersection(i));
    intersection(i,3) = tz(tintersection(i));
end
badid = find((allbad>0.5) == 1);
deletep = [];
%% 处理线段与地层界面的拟合多项式交点不在定义域时产生的不正常交点。
for ibad = 1:size(badid,2)
    id = badid(ibad);
    if id > 1 && norm(intersection(id,1:2) - intersection(id-1,1:2)) < inter  && ...
            (isempty(deletep) || deletep(end) ~= (id-1))
        deletep = [deletep id];
    elseif id < size(intersection,1) && norm(intersection(id,1:2) - intersection(id+1,1:2)) < inter
        deletep = [deletep id];
    end
end
intersection(deletep,:) = [];
idxLayer(deletep) = [];
end
    


end