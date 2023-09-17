clear

addpath ../layer_new_tanyan/
addpath ../layer_new_tanyan/layerModel
addpath ./arrivaltimedata/

%% Data initial?
layerGridModel = importdata('layergriddata6000.mat');
layerCoeffModel = importdata('layerModel6000.mat');
% layerGridModel = load_mat_data('layergriddata1000.mat');
% layerCoeffModel = load_mat_data('layerModel1000.mat');

VelMod = importdata('VelModnew.mat'); 
layerModelCombine(:,1:3) = layerGridModel(:,:);
layerModelCombine(:,4) = layerCoeffModel(:);
undergroundCoord = importdata('undergroundCoord6000.mat');
sensordo = undergroundCoord(end,:);
sensorPositions = undergroundCoord(1:1:size(undergroundCoord,1),:);
% faultfilename = "faultCoordSet3";
% filenamepre = "arrivaltimedata/";
% faultVDTFormname = filenamepre+ faultfilename + "_VDTForm.mat";
% faultPositonsname = filenamepre + faultfilename + "_Positions.mat";
% faultPositions = importdata(faultPositonsname);
% faultVDTForm = importdata(faultVDTFormname);
sourceLocationDomain = importdata('Domain_-450-650,400,-600-1000m_10m_139sensors.mat');
VDTForm = importdata('VDTForm_-450-650,400,-600-1000m_10m_139sensors.mat');
testPositions = importdata('faultPositions/refinedFaultModel3.mat');

optional.numoutput = 100;
optional.retrievaldomain = "fault";
optional.DeleteOddresidual = 2;
optional.residualway = 1;
optional.acceptresi = 2;
optional.timeturbcoef = 0.2;
optional.timeturbway = 2;

% startmatlabpool(27,1000);
%% testpart 1
sensorid1 = (81:1:121) - 78;
sensorid2 = (160:1:200) - 78;

testsourcePositions =zeros(27,3);
count = 1;
testi = [ 20 40 60; 5  15 25; 10 20 30];
testj = [ 30 60 90; 15 30 45; 15 30 45];
for ifault = 1:size(testPositions,1)
    xMat = testPositions{ifault,1};yMat = testPositions{ifault,2}; zMat = testPositions{ifault,3};
    i(:) = testi(ifault,:);
    j(:) = testj(ifault,:);
    testsourcePositions(count,:) = [xMat(i(1),j(1)) yMat(i(1),j(1)) zMat(i(1),j(1))];count = count +1;
    testsourcePositions(count,:) = [xMat(i(2),j(1)) yMat(i(2),j(1)) zMat(i(2),j(1))];count = count +1;
    testsourcePositions(count,:) = [xMat(i(3),j(1)) yMat(i(3),j(1)) zMat(i(3),j(1))];count = count +1;
    testsourcePositions(count,:) = [xMat(i(1),j(2)) yMat(i(1),j(2)) zMat(i(1),j(2))];count = count +1;
    testsourcePositions(count,:) = [xMat(i(2),j(2)) yMat(i(2),j(2)) zMat(i(2),j(2))];count = count +1;
    testsourcePositions(count,:) = [xMat(i(3),j(2)) yMat(i(3),j(2)) zMat(i(3),j(2))];count = count +1;
    testsourcePositions(count,:) = [xMat(i(1),j(3)) yMat(i(1),j(3)) zMat(i(1),j(3))];count = count +1;
    testsourcePositions(count,:) = [xMat(i(2),j(3)) yMat(i(2),j(3)) zMat(i(2),j(3))];count = count +1;
    testsourcePositions(count,:) = [xMat(i(3),j(3)) yMat(i(3),j(3)) zMat(i(3),j(3))];count = count +1;
end

numtest = size(testsourcePositions,1);
sensorid = cell(numtest,1);
for itest = 1:numtest
    if testsourcePositions(itest,3) < -3700
        sensorid{itest} = sensorid2;
    else
        sensorid{itest} = sensorid1;
    end
end

arrivalTime = cell(numtest,1);
arrivalTimeturb1 = cell(numtest,1);
arrivalTimeturb2 = cell(numtest,1);
result = cell(numtest,1);
resultturb1 = cell(numtest,1);
resultturb2 = cell(numtest,1);
xcorrArray1 = cell(numtest,1);
timeLag1 = cell(numtest,1);
xcorrArray2 = cell(numtest,1);
timeLag2 = cell(numtest,1);
for itest = 1:numtest
    sourcePosition = testsourcePositions(itest,:);
    arrivalTime{itest} = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid{itest},:), sourcePosition);
    result{itest} = arrivalTimeRetrieval(arrivalTime{itest},sensorid{itest},optional);
    arrivalTimeturb1{itest} = disturbtime(arrivalTime{itest},optional.timeturbcoef);
    resultturb1{itest} = arrivalTimeRetrieval(arrivalTimeturb1{itest},sensorid{itest},optional);
    arrivalTimeturb2{itest} = disturbtime(arrivalTime{itest},optional.timeturbcoef,optional.timeturbway);
    resultturb2{itest} = arrivalTimeRetrieval(arrivalTimeturb2{itest},sensorid{itest},optional);
    [xcorrArray1{itest}, timeLag1{itest}] = crosscorrelation(arrivalTime{itest}, arrivalTimeturb1{itest});
    [xcorrArray2{itest}, timeLag2{itest}] = crosscorrelation(arrivalTime{itest}, arrivalTimeturb2{itest});
end
save('Retrievalresult/test1datafault.mat','testsourcePositions','sensorid','arrivalTime','arrivalTimeturb1','arrivalTimeturb2','result','resultturb1','resultturb2','xcorrArray1','timeLag1','xcorrArray2','timeLag2');

numtest = size(testsourcePositions,1);
for itest = 1:numtest
    [ax] = plotresult({result{itest} resultturb1{itest} resultturb2{itest}},sensorPositions(sensorid{itest},:),testsourcePositions(itest,:));
    [x1, y1, t1, ax1] = crosscorrelation(arrivalTime{itest},arrivalTimeturb1{itest});legend('Show');
    [x2, y2, t2, ax2] = crosscorrelation(arrivalTime{itest},arrivalTimeturb2{itest});legend('Show');
    saveas(ax,"figure/test1_" + num2str(itest) + ".fig");
    saveas(ax1,"figure/test1_" + num2str(itest) + "correlation1.fig");
    saveas(ax2,"figure/test1_" + num2str(itest) + "correlation2.fig");
end