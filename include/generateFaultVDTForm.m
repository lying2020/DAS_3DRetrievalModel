function VDTForm = generateFaultVDTForm(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorPositions,  faultPositions)
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

numfault = size(faultPositions, 1);
nums = size(sensorPositions, 1);

nCores = feature('numcores');
startmatlabpool(nCores,10000);
% numi = floor(numfault/numpool);
% numi = 0;
% tempfaultPositions = zeros(numi,numpool,3);
% if numi > 0
%     for ipool = 1:numpool
%         tempfaultPositions(1:numi,ipool,:) = faultPositions((numi*(ipool-1) +1):numi*(ipool),:);
%     end
%     parfor ipool = 1:numpool
%         for ifault = 1:numi
%             sourceLocation = zeros(1,3);
%             sourceLocation(1:3) = tempfaultPositions(ifault,ipool,:);
%             [equalVelocity, ~,equalTime] = computeequalvelocity(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorPositions, sourceLocation);
%             tempVDTForm(ifault, ipool, :, :) = [equalVelocity'; equalTime']';
%             displaytimelog(['numpool: ', num2str(numpool), 'ipool: ', num2str(ipool), ', numi: ', num2str(numi), ', ifault: ', num2str(ifault)]);
%         end
%     end
%     VDTForm = zeros(numfault,nums,2);
%     for ipool = 1:numpool
%         VDTForm((1:numi)+numi*(ipool-1), :, :) = tempVDTForm(1:numi, ipool, :, :);
%     end
% end

VDTForm = cell(numfault);
% for ifault = 1 : numfault
parfor ifault = 1 : numfault
    sourceLocation = faultPositions(ifault, :);
    [equalVelocity, ~, equalTime] = computeequalvelocity(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, sensorPositions, sourceLocation);
    VDTForm{ifault} = [equalVelocity'; equalTime']';
    displaytimelog(['numfault: ', num2str(numfault), ', ifault: ', num2str(ifault), ', sourceLocation: ', num2str(sourceLocation)]);
end
% closematlabpool;

end