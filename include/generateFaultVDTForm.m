function VDTForm = generateFaultVDTForm(layerCoeffModel, layerGridModel, velocityModel, sensorPositions,  faultPositions)
%%  
%% input 
% layerGridModel
% velocityModel     1* (numlayer-1)
% sensorPositions     numsensor * numDim
% sourceLocation     Dim*2  3*2
% inter           Xs
%% output 
% arrivaltimeForm   numx*numy*numz *
% numsensor  arrivaltimedata sourceLocationDomain


numfault = size(faultPositions,1);
nums = size(sensorPositions,1);
numpool = 4;
nCores = feature('numcores');
startmatlabpool(numpool,10000);   
numi = floor(numfault/numpool);
tempfaultPositions = zeros(numi,numpool,3);
if numi > 0
    for ipool = 1:numpool
        tempfaultPositions(1:numi,ipool,:) = faultPositions((numi*(ipool-1) +1):numi*(ipool),:);
    end
    parfor ipool = 1:numpool
        for ifault = 1:numi
            sourceLocation = zeros(1,3);
            sourceLocation(1:3) = tempfaultPositions(ifault,ipool,:);
            [equalVelocity, ~,equalTime] = computeequalvelocity(layerCoeffModel, layerGridModel, velocityModel, sensorPositions, sourceLocation);
            tempVDTForm(ifault,ipool,:,:) = [equalVelocity';equalTime']';
        end
    end
    VDTForm = zeros(numfault,nums,2);
    for ipool = 1:numpool
        VDTForm((1:numi)+numi*(ipool-1),:,:) = tempVDTForm(1:numi,ipool,:,:);
    end
end
for ifault = (numi*numpool+1):numfault
    sourceLocation = faultPositions(ifault,:);
    [equalVelocity, ~,equalTime] = computeequalvelocity(layerGridModel, layerCoeffModel, velocityModel, sensorPositions, sourceLocation);
    VDTForm(ifault,:,:) = [equalVelocity';equalTime']';
end
closematlabpool;

end