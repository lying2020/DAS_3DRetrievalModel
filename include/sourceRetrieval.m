function retrievalLocation = sourceRetrieval(VDTForm,sourceLocationDomain,arrivalTime,optional)

if nargin == 4
    DeleteOddresidual = optional.DeleteOddresidual;
    residualway = optional.residualway;
    acceptresi = optional.acceptresi;
else
    DeleteOddresidual = 3;
    residualway = 1;
    acceptresi = 3;
end

[numx,numy,numz,numSensor,~] = size(VDTForm);
tempresidualAnalysis = zeros(numx,numy,numz);
interxy = sourceLocationDomain(4,1);
if sourceLocationDomain(4,2) ~= 0
    interz = sourceLocationDomain(4,2);
else
    interz = interxy;
end
if size(VDTForm,5) == 2
    equalVelocity = VDTForm(:,:,:,:,1);
    % equalDistance = VDTForm(:,:,:,:,2);
    equalTime     = VDTForm(:,:,:,:,2);
    equalDistance = equalTime .* equalVelocity;
else
    equalVelocity = VDTForm(:,:,:,:,1);
    equalDistance = VDTForm(:,:,:,:,2);
    equalTime     = VDTForm(:,:,:,:,3);
end

for ix = 1:numx
    for iy = 1:numy
        for iz = 1:numz
            count = 0;
            residual = zeros((numSensor)*(numSensor-1)/2,1);
            for i=1:numSensor - 1
                for j = i+1: numSensor
                    count = count +1;
%                     if residualway == 1
                        residual(count) =    equalVelocity(ix,iy,iz,i)* equalDistance(ix,iy,iz,j) - equalVelocity(ix,iy,iz,j)* equalDistance(ix,iy,iz,i) + ...
                            equalVelocity(ix,iy,iz,i) * equalVelocity(ix,iy,iz,j) * ( arrivalTime(i) - arrivalTime(j));
%                     elseif residualway == 2
%                         residual(count) =  (arrivalTime(i) - equalTime(ix,iy,iz,i) ) - (arrivalTime(j) - equalTime(ix,iy,iz,j) );
%                     end
                end
            end
            numresidual = size(residual,1);
            normresi = abs(residual);
            [~, ia] = sort(normresi(:),'descend');
            residual(ia(1:floor(numresidual/DeleteOddresidual))) = [];
            numresidual = size(residual,1);
            tempresidualAnalysis(ix,iy,iz) = norm(residual)/sqrt(numresidual);
        end
    end
end
residualAnalysis = tempresidualAnalysis;

minresi = min(min(min(residualAnalysis)));
id = find((residualAnalysis >= minresi) .* (residualAnalysis < minresi +  interxy * 1000 *acceptresi));
numx = numx* ones(size(id,1),1);
numy = numy* ones(size(id,1),1);
idz = fix((id-1)./(numx.*numy))+1;
idy = fix(rem(id-1,numx.*numy)./numx)+1;
idx = rem(rem((id-1),numx.*numy),numx)+1;
numloc = size(idx,1);
% interxy = sourceLocationDomain(4,1);
retrievalLocation = zeros(numloc,4);
for iloc = 1:numloc
    retrievalLocation(iloc,1) = sourceLocationDomain(1,1) + interxy * (idx(iloc)-1);
    retrievalLocation(iloc,2) = sourceLocationDomain(2,1) + interxy * (idy(iloc)-1);
    retrievalLocation(iloc,3) = sourceLocationDomain(3,1) + interz * (idz(iloc)-1);
    retrievalLocation(iloc,4) = residualAnalysis(idx(iloc),idy(iloc),idz(iloc));
end

[~ ,iretrieval] = sort(retrievalLocation(1:numloc,4));
retrievalLocation(1:numloc,:) = retrievalLocation(iretrieval,:);

