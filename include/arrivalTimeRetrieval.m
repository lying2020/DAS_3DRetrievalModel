function [result] = arrivalTimeRetrieval(arrivalTime,sensorid,optional,retrievaldata1,retrievaldata2)

% % add path.
currentpath = mfilename('fullpath');
[pathname0] = fileparts(currentpath);
% pathname = [pathname, filesep, '..', filesep, '..', filesep, 'include'];
addpath(genpath(pathname0));
% pathname = pwd; 
%  retrievalType = ["fault", "cubicSmall", "cubicLarge"];
if nargin < 3
    optional.numoutput = 100;
    optional.retrievaldomain = "cubicSmall";
    optional.DeleteOddresidual = 2;
    optional.residualway = 1;
    optional.acceptresi = 2;
    optional.pathname = pathname0; 
end
pathname = optional.pathname; 
if nargin < 5
%     addpath ../layer_new_tanyan/
%     addpath ../layer_new_tanyan/layerModel
    addpath(genpath([pathname, filesep, '..', filesep, 'layer_new_tanyan']));
    addpath(genpath([pathname, filesep, '..', filesep, 'layer_new_tanyan', filesep, 'layerModel']));
    if optional.retrievaldomain == "fault"
        faultPositions = importdata([pathname,    filesep, 'faultCoordSet96881_Positions.mat']);
        faultVDTForm = importdata([pathname,   filesep, 'faultCoordSet96881_VDTForm.mat']);
    elseif optional.retrievaldomain == "cubicSmall"
        retrievaldata2 = importdata([pathname,  filesep, 'Domain_-450-650,400,-600-1000m_10m_139sensors.mat']);
        retrievaldata1 = importdata([pathname,  filesep, 'VDTForm_-450-650,400,-600-1000m_10m_139sensors.mat']);
    elseif optional.retrievaldomain == "cubicLarge"
        retrievaldata2 = importdata([pathname,  filesep, 'Domain_-1500--1500,-1500--1500,-600-1000m_20-10m_139sensors.mat']);
        retrievaldata1 = importdata([pathname,  filesep, 'VDTForm_-1500--1500,-1500--1500,-600-1000m_20-10m_139sensors.mat']);
    end
end

%% Convert time s to ms and sensorid underground have to minus number of overground sensors
if find((sensorid < 1) .* (sensorid > 139),1)
    warning("sensor id have overground sensors");
end

%% For different search domain import different Retrieval data VDTForm
if optional.retrievaldomain == "fault"
    tempfaultVDTForm = faultVDTForm(:,sensorid,:);
    [retrievalLocation] = FaultRetrieval(tempfaultVDTForm,faultPositions,arrivalTime,optional);
    numoutput = min(optional.numoutput, size(retrievalLocation,1));
    result = retrievalLocation(1:numoutput,1:4);
else
%     optional.retrievaldomain == "cubic"
%     sourceLocationDomain = importdata('Domain_-450-650,400,-600-1000m_10m_139sensors.mat');
%     VDTForm = importdata('VDTForm_-450-650,400,-600-1000m_10m_139sensors.mat');
    VDTForm = retrievaldata1;
    sourceLocationDomain = retrievaldata2;
    clear retrievaldata1 retrievaldata2 
    undergroundCoord = importdata([pathname,  filesep, 'undergroundCoord6000.mat']);
    sensordo = undergroundCoord(end,:);
    
    [retrievalLocation] = sourceRetrieval(VDTForm(:,:,:,sensorid,:),sourceLocationDomain,arrivalTime,optional);
    numoutput = min(optional.numoutput, size(retrievalLocation,1));
    result = retrievalLocation(1:numoutput,1:4) + [sensordo 0];    
end


