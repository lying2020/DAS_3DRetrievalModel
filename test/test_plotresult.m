clear 

addpath ../layer_new_tanyan/
addpath ../layer_new_tanyan/layerModel
addpath ./arrivaltimedata/
undergroundCoord = importdata('undergroundCoord6000.mat');
sensordo = undergroundCoord(end,:);
sensorPositions = undergroundCoord(1:1:size(undergroundCoord,1),:);

%% test1 plot
load Retrievalresult/test1data.mat
numtest = size(testsourcePositions,1);
for itest = 1:numtest
    [ax] = plotresult({result{itest} resultturb1{itest} resultturb2{itest}},sensorPositions(sensorid{itest},:),testsourcePositions(itest,:));
    [x1, y1, t1, ax1] = crosscorrelation(arrivalTime{itest},arrivalTimeturb1{itest});legend('Show');
    [x2, y2, t2, ax2] = crosscorrelation(arrivalTime{itest},arrivalTimeturb2{itest});legend('Show');
    saveas(ax,"figure/test1_" + num2str(itest) + ".fig");
    saveas(ax1,"figure/test1_" + num2str(itest) + "correlation1.fig");
    saveas(ax2,"figure/test1_" + num2str(itest) + "correlation2.fig");
end

%% test2 plot
load Retrievalresult/test2data.mat
numtest = size(result,1);
for itest = 1:numtest
    [ax] = plotresult({result{itest}},sensorPositions(sensorid{itest}-78,:));
    [x1, y1, t1, ax1] = crosscorrelation(arrivalTime{itest},resultarrivalTime{itest}(1,:));legend('Show');
    [x2, y2, t2, ax2] = crosscorrelation(arrivalTime{itest},resultarrivalTime{itest}(2,:));legend('Show');
    [x3, y3, t3, ax3] = crosscorrelation(arrivalTime{itest},resultarrivalTime{itest}(3,:));legend('Show');
    legend('Show');
    fid = fopen("figure\test2_result" + num2str(itest) + ".txt", 'wt');
    mat = result{itest};
    for i = 1:size(mat, 1)
        fprintf(fid, '%f\t', mat(i,:));
        fprintf(fid, '\n');
    end
    fclose(fid);
    saveas(ax,"figure/test2_" + num2str(itest) + ".fig");
    saveas(ax1,"figure/test2_" + num2str(itest) + "correlation1.fig");
    saveas(ax2,"figure/test2_" + num2str(itest) + "correlation2.fig");
    saveas(ax3,"figure/test2_" + num2str(itest) + "correlation3.fig");
end

%% test3 plot
load Retrievalresult/test3data.mat
numtest = size(testsourcePositions,1);
for itest = 1:numtest
    [ax] = plotresult({result{itest} resultturb1{itest} resultturb2{itest}},sensorPositions(sensorid,:),testsourcePositions(itest,:));
    [x1, y1, t1, ax1] = crosscorrelation(arrivalTime{itest},arrivalTimeturb1{itest});legend('Show');
    [x2, y2, t2, ax2] = crosscorrelation(arrivalTime{itest},arrivalTimeturb2{itest});legend('Show');
    legend('Show')
    saveas(ax,"figure/test3_" + num2str(itest) + ".fig");
    saveas(ax1,"figure/test3_" + num2str(itest) + "correlation1.fig");
    saveas(ax2,"figure/test3_" + num2str(itest) + "correlation2.fig");
end