function [layerGridModel] = grid_tanyan(layerData,basecoord,inter,retractx,retracty)
%%
% input: layerData ���ڲ�ֵ�����ݣ���ʽΪn��n�ǵز���������cell��ÿ��cellΪm*3����mΪÿ���ز����ݵ�������
%        inter ��ֵ��������ݸ��ļ��
%        basecoord ������ԭ�㣬Ϊһ��[x��y]����
%        retractx,retracty��ֵ���������ȷ���ڳ�ʼ���������С��x,y���������ľ��롣ʹ�ò�ֵ��Χ�ڶ��в�ֵ�����
%
% output: layerGridModel  ���Ϊinter�ĵز�������ֵ���
%         ��ʽΪn*3��cell��Ӧn���ز㣬ÿ��Ϊ��ֵ���{xMat��yMat��zMat}��


numLayer =length(layerData);
layerGridModel = cell(numLayer,3);
for iLayer = 1: numLayer
    %% ��ȡ��ֵ����
    layer1 = layerData{iLayer};
    x = layer1(:, 1);
    y = layer1(:, 2);
    z = layer1(:, 3);

%% �����ֵx��y��Χ���������ݵ�x��y����ƽ��ʹ��basecoordλ�ڣ�0,0����
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

%% ����xMat��yMat����griddata���в�ֵ

[xMat,yMat]=meshgrid(minx+retractx : inter : maxx-retractx, miny+retracty : inter : maxy-retracty);
%�������λ�ò�ֵ��Z��ע�⣺��ͬ�Ĳ�ֵ�����õ������߹⻬�Ȳ�ͬ
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
