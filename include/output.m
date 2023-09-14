function [Retrievalresult,resultnearest,dist, resi, mindist, resinearest,numresult,markiminnorm,distance,mindistoutput, iminnormoutput] ...\
    = output(distance,optional)
% [retrievalLocation] = sourceRetrieval(VDTForm,sourceLocationDomain,tmparrivalTime,optional);
numresult = size(distance,2);
[~ ,ia] = sort(distance(4,1:numresult));
distance(:,1:numresult) = distance(:,ia);
resi = distance(4,1);
Retrievalresult = distance(1:3,1);
dist = norm([distance(1,1) distance(2,1) distance(3,1)]);
normdist = zeros(1,numresult);
for i = 1:numresult
    normdist(i) = norm([distance(1,i) distance(2,i) distance(3,i)]);
end
[mindist, iminnorm] = min(normdist);
numoutput = min(numresult,optional.numoutput);
[mindistoutput, iminnormoutput] = min(normdist(1:numoutput));
markiminnorm = iminnorm;
resinearest = distance(4,iminnorm);
resultnearest = distance(1:3,iminnorm);
end