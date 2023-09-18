
function VDTForm = generateVDTForm(layerCoeffModel, layerGridModel, velocityModel, undergroundCoordsSet,  ...
                                                      retrieval_relative_model_domain, retrieval_model_grid_size, output_retrieval_model_filename)
%%
%% input 
% layerGridModel
% velocityModel     1* (numlayer-1)
% undergroundCoordsSet     numsensor * numDim
% retrieval_relative_model_domain     Dim*2, 3*2
%% output 
% VDTForm       numx*numy*numz *numSensors*2
func_name = mfilename;
displaytimelog(['func: ', func_name]);

mkdir(output_retrieval_model_filename);
displaytimelog(['func: ', func_name, '. ' 'output_retrieval_model_filename: ' output_retrieval_model_filename]);

num_xyz = floor(abs(retrieval_relative_model_domain(:, 2) - retrieval_relative_model_domain(:, 1)) ./ retrieval_model_grid_size) + 1;

coordBegin = retrieval_relative_model_domain(1:3,1)';
% VDTForm = zeros(numx, numy, numz, nums, 2);
numSensors = size(undergroundCoordsSet, 1);
nCores = feature('numcores');
displaytimelog(['func: ', func_name, '. ' 'nCores: ', num2str(nCores), ', numSensors: ', num2str(numSensors), ', coordBegin: ', num2str(coordBegin)]);
startmatlabpool(nCores,10000);
% pplayerCoeffModel = parallel.pool.Constant(layerCoeffModel);
% mpiprofile on;
displaytimelog(['func: ', func_name, '. ' 'nCores: ', num2str(nCores), ', [num_xyz] = [', num2str(num_xyz'), '] ']);
numx = num_xyz(1); numy = num_xyz(2);  numz = num_xyz(3);

tempVDTForm = cell(numx, numy, numz);
for ix = 1:numx
% parfor ix = 1:numx
    tmpVDTForm_X = cell(numy, numz);
    X_time_start = str2num(showtimenow(0));
    %  for iy = 1:numy
    parfor iy = 1:numy
        for iz = 1:numz
             tic
             sourceLocationCoord = coordBegin + retrieval_model_grid_size' .* [ix-1, iy-1, iz-1];
             [equalVelocity, ~, equalTime] = computeequalvelocity(layerCoeffModel, layerGridModel, velocityModel, undergroundCoordsSet, sourceLocationCoord);
             tmp =  [equalVelocity'; equalTime']';
             tempVDTForm{ix, iy, iz} = tmp;
             tmpVDTForm_X{iy, iz} = tmp;
             % tempVDTForm{ix, iy, iz} = [equalVelocity'; equalDistance'; equalTime']';
             disp_toc = toc;
             displaytimelog(['func: ', func_name, '. ' ' [ix, iy, iz] =  [', num2str(ix), ', ', num2str(iy), ', ', num2str(iz), '], cost time: ', num2str(disp_toc)]);
        end
    end
    X_time_end = str2num(showtimenow(0));
    filename = ['vdt_x_', num2str(ix), 'time_cost_', num2str(X_time_end - X_time_start)];
    displaytimelog(['func: ', func_name, '. ' ' filename: ', filename, '. X_time: ', num2str(X_time_start), ' -- ', num2str(X_time_end)]);
    savedata(tmpVDTForm_X, output_retrieval_model_filename, filename, '.mat');

end

VDTForm = tempVDTForm;
closematlabpool;


end