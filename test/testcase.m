clear

addpath ../layer_new_tanyan/
addpath ../layer_new_tanyan/layerModel
addpath ./arrivaltimedata/

%% Data initial?
layerGridModel = importdata('layergriddata1000.mat');
layerCoeffModel = importdata('layerModel1000.mat');
VelMod = importdata('VelModnew.mat');

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
testPositions = importdata('faultPositions/refinedFaultModel3(1).mat');

optional.numoutput = 100;
optional.retrievaldomain = "cubic";
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
    result{itest} = arrivalTimeRetrieval(arrivalTime{itest},sensorid{itest},VDTForm,sourceLocationDomain,optional);
    arrivalTimeturb1{itest} = disturbtime(arrivalTime{itest},optional.timeturbcoef);
    resultturb1{itest} = arrivalTimeRetrieval(arrivalTimeturb1{itest},sensorid{itest},VDTForm,sourceLocationDomain,optional);
    arrivalTimeturb2{itest} = disturbtime(arrivalTime{itest},optional.timeturbcoef,optional.timeturbway);
    resultturb2{itest} = arrivalTimeRetrieval(arrivalTimeturb2{itest},sensorid{itest},VDTForm,sourceLocationDomain,optional);
    [xcorrArray1{itest}, timeLag1{itest}] = crosscorrelation(arrivalTime{itest}, arrivalTimeturb1{itest});
    [xcorrArray2{itest}, timeLag2{itest}] = crosscorrelation(arrivalTime{itest}, arrivalTimeturb2{itest});
end
save('Retrievalresult/test1data.mat','testsourcePositions','sensorid','arrivalTime','arrivalTimeturb1','arrivalTimeturb2','result','resultturb1','resultturb2','xcorrArray1','timeLag1','xcorrArray2','timeLag2');
clear testsourcePositions arrivalTime arrivalTimeturb1 arrivalTimeturb2 result resultturb1 resultturb2 sensorid xcorrArray1 timeLag1 xcorrArray2 timeLag2;
%% test part 2
arrivalname = "arrivaldata/";
arrivalTime = importdata(arrivalname + "wdArray13.mat");
sensorid = importdata(arrivalname + "seqArray13.mat");
numsource = size(arrivalTime,1);
numrefract = 3;
result = cell(numsource,1);
resultarrivalTime = cell(numsource,1);
xcorrArray = cell(numsource,numrefract);
timeLag = cell(numsource,numrefract);
parfor isource = 1:numsource
    tmpsensorid = sensorid{isource}-78;
    [result{isource}] = arrivalTimeRetrieval(arrivalTime{isource},tmpsensorid,VDTForm,sourceLocationDomain,optional);
end
for isource = 1:numsource
    numresult = size(result{isource},1);
    numres = min(numresult,numrefract);
    for ires = 1:numres
        sourcePosition = result{isource}(ires,1:3);
        resultarrivalTime{isource}(ires,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid{isource}-78,:), sourcePosition);
        [xcorrArray{isource,ires}, timeLag{isource,ires}] = crosscorrelation(arrivalTime{isource}, resultarrivalTime{isource}(ires,:));
    end
end
save('Retrievalresult/test2data.mat','arrivalTime','result','xcorrArray','timeLag', 'sensorid','resultarrivalTime');
clear arrivalTime result xcorrArray timeLag sensorid;


%% test part 3
tempP = (sensorPositions(89,:) + sensorPositions(90,:))/2;
testsourcePositions = tempP + [0 0 0;4 3 0; 8 6 0; 16 12 0; 40 30 0; 80 60 0];
numtest = size(testsourcePositions,1);
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
sensorid = sensorid2;
parfor itest = 1:numtest
    sourcePosition = testsourcePositions(itest,:);
    arrivalTime{itest} = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
    result{itest} = arrivalTimeRetrieval(arrivalTime{itest},sensorid,VDTForm,sourceLocationDomain,optional);
    arrivalTimeturb1{itest} = disturbtime(arrivalTime{itest},optional.timeturbcoef);
    resultturb1{itest} = arrivalTimeRetrieval(arrivalTimeturb1{itest},sensorid,VDTForm,sourceLocationDomain,optional);
    arrivalTimeturb2{itest} = disturbtime(arrivalTime{itest},optional.timeturbcoef,optional.timeturbway);
    resultturb2{itest} = arrivalTimeRetrieval(arrivalTimeturb2{itest},sensorid,VDTForm,sourceLocationDomain,optional);
    [xcorrArray1{itest}, timeLag1{itest}] = crosscorrelation(arrivalTime{itest}, arrivalTimeturb1{itest});
    [xcorrArray2{itest}, timeLag2{itest}] = crosscorrelation(arrivalTime{itest}, arrivalTimeturb2{itest});
end
save('Retrievalresult/test3data.mat','testsourcePositions','sensorid','arrivalTime','arrivalTimeturb1','arrivalTimeturb2','result','resultturb1','resultturb2','xcorrArray1','timeLag1','xcorrArray2','timeLag2');
clear testsourcePositions arrivalTime arrivalTimeturb1 arrivalTimeturb2 result resultturb1 resultturb2 sensorid xcorrArray1 timeLag1 xcorrArray2 timeLag2;

% tempsensor = sensorPositions(109,:);
% sourcePosition = [471.637318614727,56.4648981531604,-3898.50159181775];
% dist = sourcePosition - tempsensor;
% arrivalTime1(5,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% [result] = arrivalTimeRetrieval(arrivalTime1(5,:),sensorid,VDTForm,sourceLocationDomain,optional);
% figure(1); hold on;
% plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10)
% legend({'sensorPositions','result','sourcePosition'});
% sourcePosition = tempsensor + dist *1/5;
% arrivalTime1(1,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% [result] = arrivalTimeRetrieval(arrivalTime1(1,:),sensorid,VDTForm,sourceLocationDomain,optional);
% figure(2)
% plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10);
% legend({'sensorPositions','result','sourcePosition'});
% sourcePosition = tempsensor + dist *2/5;
% arrivalTime1(2,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% sourcePosition = tempsensor + dist .*3/5;
% arrivalTime1(3,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% [result] = arrivalTimeRetrieval(arrivalTime1(3,:),sensorid,VDTForm,sourceLocationDomain,optional);
% figure(3)
% plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10);
% legend({'sensorPositions','result','sourcePosition'});
% sourcePosition = tempsensor + dist .*4/5;
% arrivalTime1(4,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% 
% %% testcase2
% sensorid = (81:1:121) - 78;
% tempsensor = sensorPositions(109,:);
% sourcePosition = [471.637318614727,56.4648981531604,-3898.50159181775];
% dist = sourcePosition - tempsensor;
% arrivalTime(5,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% [result] = arrivalTimeRetrieval(arrivalTime(5,:),sensorid,VDTForm,sourceLocationDomain,optional);
% figure(4); hold on;
% plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10)
% legend({'sensorPositions','result','sourcePosition'});
% sourcePosition = tempsensor + dist *1/5;
% arrivalTime(1,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% [result] = arrivalTimeRetrieval(arrivalTime(1,:),sensorid,VDTForm,sourceLocationDomain,optional);
% figure(5)
% plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10);
% legend({'sensorPositions','result','sourcePosition'});
% sourcePosition = tempsensor + dist *2/5;
% arrivalTime(2,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% sourcePosition = tempsensor + dist .*3/5;
% arrivalTime(3,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% [result] = arrivalTimeRetrieval(arrivalTime(3,:),sensorid,VDTForm,sourceLocationDomain,optional);
% figure(6)
% plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10);
% legend({'sensorPositions','result','sourcePosition'});
% sourcePosition = tempsensor + dist .*4/5;
% arrivalTime(4,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% 
% 
% %% testcase3
% sensorid = (118:1:150) - 78;
% optional.retrievaldomain = "fault";
% optional.numoutput = 30;
% sourcePosition = (faultPositions(580,:) + faultPositions(581,:))/2;
% arrivalTime2(1,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% [result] = arrivalTimeRetrieval(arrivalTime2(1,:),sensorid,faultVDTForm,faultPositions,optional);
% figure(7); hold on;
% plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10)
% legend({'sensorPositions','result','sourcePosition'});
% 
% optional.numoutput = 100;
% [result] = arrivalTimeRetrieval(arrivalTime2(1,:),sensorid,faultVDTForm,faultPositions,optional);
% figure(8); hold on;
% plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10)
% legend({'sensorPositions','result','sourcePosition'});
% 
% 
% % sensorid = (180:1:212) - 78;
% % optional.retrievaldomain = "fault";
% % optional.numoutput = 10;
% % sourcePosition = faultPositions(950,:);
% % arrivalTime2(2,:) = gettraveltime(layerCoeffModel, layerGridModel, VelMod, sensorPositions(sensorid,:), sourcePosition);
% % [result] = arrivalTimeRetrieval(arrivalTime2(2,:),sensorid,faultVDTForm,faultPositions,optional);
% % figure(8); hold on;
% % plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% % plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% % plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10)
% % legend({'sensorPositions','result','sourcePosition'});
% % 
% % optional.numoutput = 100;
% % [result] = arrivalTimeRetrieval(arrivalTime2(2,:),sensorid,faultVDTForm,faultPositions,optional);
% % figure(9); hold on;
% % plot3(sensorPositions(sensorid,1),sensorPositions(sensorid,2),sensorPositions(sensorid,3),'o','MarkerSize',3,'Color','b');hold on;
% % plot3(result(:,1),result(:,2),result(:,3),'o','MarkerSize',3,'Color','r');hold on; 
% % plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',10)
% % legend({'sensorPositions','result','sourcePosition'});