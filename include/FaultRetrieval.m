function retrievalLocation = FaultRetrieval(faultVDTForm,faultPositions,arrivalTime,optional)
%% 
%% input
%  arrivaltimeForm   
%  sourceLocationDomain 
%  sensorPositions   
%  arrivaltime       
%  optional     
%% output
%  retrievalLocation
%  numLocation*4,

if nargin == 4
    DeleteOddresidual = optional.DeleteOddresidual;
    residualway = optional.residualway;
    acceptresi = optional.acceptresi;
else
    DeleteOddresidual = 3;
    residualway = 1;
    acceptresi = 3;
end

[numfault,numSensor,~] = size(faultVDTForm);
tempresidualAnalysis = zeros(numfault,1);
equalVelocity = faultVDTForm(:,:,1);
% equalDistance = VDTForm(:,:,:,:,2);
equalTime     = faultVDTForm(:,:,2);
equalDistance = equalTime .* equalVelocity;

for ix = 1:numfault
    count = 0;
    residual = zeros(numSensor*(numSensor-1)/2,1);
    for i=1:numSensor - 1
        for j = i+4: numSensor
            count = count +1;
            if residualway == 1
                residual(count) =    equalVelocity(ix,i)* equalDistance(ix,j) - equalVelocity(ix,j)* equalDistance(ix,i) + ...
                    equalVelocity(ix,i) * equalVelocity(ix,j) * ( arrivalTime(i) - arrivalTime(j));
            elseif residualway == 2
                residual(count) =  (arrivalTime(i) - equalTime(ix,i) ) - (arrivalTime(j) - equalTime(ix,j) );
            end
        end
    end
    numresidual = size(residual,1);
    normresi = abs(residual);
    %             normresi = zeros(numresidual��1);
    %             for iresi = 1:numresidual
    %                 normresi(iresi) = norm(residual(iresi,:));
    %             end
    [~, ia] = sort(normresi(:),'descend');
    residual(ia(1:floor(numresidual/DeleteOddresidual))) = [];
    numresidual = size(residual,1);
    tempresidualAnalysis(ix) = norm(residual)/sqrt(numresidual);
    
end
residualAnalysis = tempresidualAnalysis;

minresi = min(residualAnalysis);
id = find((residualAnalysis >= minresi));% .* (residualAnalysis < minresi + 10000 * acceptresi));
numloc = size(id,1);
retrievalLocation = zeros(numloc,4);
for iloc = 1:numloc
    retrievalLocation(iloc,1:3) = faultPositions(id(iloc),:);
    retrievalLocation(iloc,4) = residualAnalysis(id(iloc));
end

[~ ,iretrieval] = sort(retrievalLocation(1:numloc,4));
retrievalLocation(1:numloc,:) = retrievalLocation(iretrieval,:);
