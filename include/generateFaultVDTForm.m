function VDTForm = generateFaultVDTForm(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, ...
                                                                                undergroundCoordsSet,  faultPositions, output_faultmodel_filename)
%%  
%% input 
% layerGridModel
% velocityModel     1* (numlayer-1)
% undergroundCoordsSet     numsensor * numDim
% sourceLocation     Dim*2  3*2
% inter           Xs
%% output 
% arrivaltimeForm   numx*numy*numz *
% numsensor  arrivaltimedata sourceLocationDomain
func_name = mfilename;
displaytimelog(['func: ', func_name]);

numfaultPositions = size(faultPositions, 1);
nums = size(undergroundCoordsSet, 1);

% nCores = feature('numcores');
% startmatlabpool(nCores,10000);

% numi = floor(numfaultPositions/numpool);
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
%             [equalVelocity, ~,equalTime] = computeequalvelocity(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, undergroundCoordsSet, sourceLocation);
%             tempVDTForm(ifault, ipool, :, :) = [equalVelocity'; equalTime']';
%             displaytimelog(['numpool: ', num2str(numpool), 'ipool: ', num2str(ipool), ', numi: ', num2str(numi), ', ifault: ', num2str(ifault)]);
%         end
%     end
%     VDTForm = zeros(numfaultPositions,nums,2);
%     for ipool = 1:numpool
%         VDTForm((1:numi)+numi*(ipool-1), :, :) = tempVDTForm(1:numi, ipool, :, :);
%     end
% end

mkdir(output_faultmodel_filename);
nCores = feature('numcores');
startmatlabpool(nCores,10000);

tmpN = 100;
tmpnumfault = floor(numfaultPositions / tmpN);
VDTForm = zeros(numfaultPositions, nums,2);

tmpN = tmpN + 1;
for i_tmp = 1: tmpN
    X_time_start = str2num(showtimenow(0));
    displaytimelog(['func: ', func_name, '. ', 'tmpN: ', num2str(tmpN), ', i_tmp: ', num2str(i_tmp), '. X_time_start: ', num2str(X_time_start)]);
    fault_loop = (tmpnumfault * (i_tmp - 1) + 1) :  min((tmpnumfault * i_tmp), numfaultPositions);
    tmpVDTForm = zeros(length(fault_loop), nums, 2);
    for ifault = fault_loop
%     parfor ifault = fault_loop
        tic
        sourceLocation = faultPositions(ifault, :);
        %     displaytimelog(['func: ', func_name, 'numfaultPositions: ', num2str(numfaultPositions), ', ifault: ', num2str(ifault), ', sourceLocation: ', num2str(sourceLocation)]);
        [equalVelocity, ~, equalTime] = computeequalvelocity(layerCoeffModel, layerGridModel, layerRangeModel, velocityModel, undergroundCoordsSet, sourceLocation);
        tmpVDTForm(ifault, :, :) = [equalVelocity'; equalTime']';
        VDTForm(ifault, :, :) = [equalVelocity'; equalTime']';
        disp_toc = toc;
        displaytimelog(['func: ', func_name, '. ',  'numfaultPositions: ', num2str(numfaultPositions), ', ifault: ', num2str(ifault), ', cost time: ', num2str(disp_toc)]);
    end
    X_time_end = str2num(showtimenow(0));
    filename = ['fault_tmpN_', num2str(tmpN), '_i_tmp_', num2str(i_tmp), '_time_cost_', num2str(X_time_end - X_time_start)];
    displaytimelog(['func: ', func_name, '. ', 'tmpN: ', num2str(tmpN), ', filename: ', filename, '. X_time: ', num2str(X_time_start), ' -- ', num2str(X_time_end)]);
    savedata(tmpVDTForm , output_faultmodel_filename, filename, '.mat');

end

closematlabpool;

end