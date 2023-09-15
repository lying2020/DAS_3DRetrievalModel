
%
%
%% ----------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% this code is used to compute retrieval model searchable areas
function retrieval_model_area = compute_retrieval_model_area(layerGridModel, undergroundCoordsSet, retrieval_model_area)

%
%  DEBUG ! ! !
dbstop if error;
format long % short % 
%
% clear
func_name = mfilename;
disp(['func_name: ', func_name]);
%% --------------------------------------------------------------------------

numLayer = size(layerGridModel, 1);

for ilayer = 1 : numLayer
    xMat = layerGridModel{ilayer, 1};
    xArray = xMat(:, [1, end]);
    retrieval_model_area(1, 1) = max(min(xArray(:)), retrieval_model_area(1, 1));
    retrieval_model_area(1, 2) = min(max(xArray(:)), retrieval_model_area(1, 2));
    yMat = layerGridModel{ilayer, 2};
    yArray = xMat([1, end], :);
    retrieval_model_area(2, 1) = max(min(yArray(:)), retrieval_model_area(2, 1));
    retrieval_model_area(2, 2) = min(max(yArray(:)), retrieval_model_area(2, 2));

end

retrieval_model_area(3, 2) = min(abs(undergroundCoordsSet(1, 3) - undergroundCoordsSet(end, 3)) - 100, retrieval_model_area(3, 2));

retrieval_model_area = mod(retrieval_model_area, 10);


















end
