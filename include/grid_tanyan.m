function [layerGridModel] = grid_tanyan(layerData,basecoord,inter,retractx,retracty)
%%
% input: layerData 用于插值的数据，格式为n（n是地层数量）个cell，每个cell为m*3矩阵（m为每个地层数据点数量）
%        inter 插值结果中数据格点的间距
%        basecoord 坐标轴原点，为一个[x，y]坐标
%        retractx,retracty插值结果的上下确界在初始数据最大最小的x,y向内收缩的距离。使得插值范围内都有插值结果。
%
% output: layerGridModel  间距为inter的地层网格点插值结果
%         格式为n*3个cell对应n个地层，每行为插值结果{xMat，yMat，zMat}。


numLayer =length(layerData);
layerGridModel = cell(numLayer,3);
for iLayer = 1: numLayer
    %% 提取插值数据
    layer1 = layerData{iLayer};
    x = layer1(:, 1);
    y = layer1(:, 2);
    z = layer1(:, 3);

%% 计算插值x，y范围，并将数据点x，y坐标平移使得basecoord位于（0,0）。
    minx = min(x) - basecoord(1);
    maxx = max(x) - basecoord(1);
    miny = min(y) - basecoord(2);
    maxy = max(y) - basecoord(2);

    count = 1;
for i = 1: length(x)
    x(count, 1) = x(count, 1) - basecoord(1);
    y(count, 1) = y(count, 1) - basecoord(2);
    z(count, 1) = z(count, 1) - basecoord(3);
    count = count + 1;
end

%% 计算xMat和yMat，用griddata进行插值

[xMat,yMat]=meshgrid(minx+retractx : inter : maxx-retractx, miny+retracty : inter : maxy-retracty);
%在网格点位置插值求Z，注意：不同的插值方法得到的曲线光滑度不同
zMat=griddata(x,y,z,xMat,yMat,'cubic');
%Z2=griddata(x,y,z,X,Y,'v4');

layerGridModel{iLayer,1} = xMat;
layerGridModel{iLayer,2} = yMat;
layerGridModel{iLayer,3} = zMat;
end

clear zMat;
for iLayer = 1:numLayer
    zMat{iLayer} = layerGridModel{iLayer,3};
    meanZ(iLayer, 1) = zMat{iLayer}(1,1);
end
[~, idxZ] = sort(meanZ);
layerGridModel = layerGridModel(idxZ, :);
end
