% load layergriddatanew;
% load layerModelnew;
% load layerModel_zdomainnew;
% load VelModnew;
% 
layerGridModel = load_mat_data('layergriddata1000.mat');
layerCoeffModel = load_mat_data('layerModel1000.mat');

minx = layerGridModel{2,1}(1,1);
miny = layerGridModel{2,2}(1,1);
minx = layerGridModel{2,1}(1,1);
miny = layerGridModel{2,2}(1,1);
startpoint = [0 0 0];
for i =1:10
    for j = 1:10
        %for k = 1:10
        k = 0;
        ep=[500,0,0]+[minx,miny,0] + [i*250 j*100 -k*100];
        sp =[750,100,-6000]+[minx,miny,0];
        [intersection, idxLayer, points]  = layerintersects_tanyan(layerCoeffModel, layerGridModel, sp, ep);
        markintersection{i,j} = intersection;
        markidxLayer{i,j} = idxLayer;
        %end
    end
end