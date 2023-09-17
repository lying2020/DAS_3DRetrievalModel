
%
%
%
%
%
%
%
%
% close all;
clear
%%  -----------------------------------------------------------
%  DEBUG ! ! !
dbstop if error;   
format long
addpath(genpath('../../../include'));
% 
baseCoord =  importdata('baseCoordout6000.mat');
[fileName, pathName] = uigetfile({'*.*'; '*.txt'; '*.mat'}, ' Select the TXT-file ',  'MultiSelect', 'on');
%
if  isa(fileName, 'numeric'), return;  end
%
filenameList = fullfile(pathName, fileName);
%
if isa(filenameList, 'char')
   tmp{1, 1} = filenameList;
   filenameList = tmp;
end
% filenameList is a cell array
num = length(filenameList);
type = 'layer';
layerdata = cell(num, 1);
inter = 10;

for iFile = 1:num
    layerdata{iFile} = readlayerdata(filenameList{iFile});
end

%layerGridModel = grid_tanyan(layerdata,baseCoord,inter,150,300);
 layerGridModel = grid_tanyan(layerdata,baseCoord,inter,20,20); % new data
[layerCoeffModel, ~] = fitting_tanyan(layerGridModel);

fileprename = "layerModel/";
filesufname = "6000";
save(fileprename + "layerGridModel" + filesufname,'layerGridModel');
save(fileprename + "layerCoeffModel" + filesufname,'layerCoeffModel');
% save(fileprename + "layerCoeffModel_zdomain6000",'layerCoeffModel_zdomain');
save(fileprename + "baseCoordout" + filesufname,'baseCoord');

for iFile = 1:num
    figure(iFile);
    x = layerGridModel{iFile,1};
    y = layerGridModel{iFile,2};
    z = layerGridModel{iFile,3};
    [row,col] = size(x);
    i = floor(rand(1)*(row-10)+2); j = floor(rand(1)*(col-10)+2);
    for k = -1:3
        for d = -1:2
            plot3(x(i+k,j+d),y(i+k,j+d),z(i+k,j+d),'b.','markersize',10);hold on
        end
    end
    coeff1 = layerCoeffModel{iFile,1}{i,j};
    coeff2 = layerCoeffModel{iFile,1}{i+1,j};
    %syms p q
     func1 = @(x) coeff1(1) * x(1)*x(1)*x(1) + coeff1(2) * x(1)*x(1)*x(2) + ...
        coeff1(3) * x(1)*x(2)*x(2) + coeff1(4) * x(2)*x(2)*x(2) +...
        coeff1(5) * x(1)*x(1)      + coeff1(6) * x(1)*x(2)      +  coeff1(7) * x(2)*x(2) + ...
        coeff1(8) * x(1)           + coeff1(9) * x(2)           +  coeff1(10) * 1;
    func2 = @(x) coeff2(1) * x(1)*x(1)*x(1) + coeff2(2) * x(1)*x(1)*x(2) + ...
        coeff2(3) * x(1)*x(2)*x(2) + coeff2(4) * x(2)*x(2)*x(2) +...
        coeff2(5) * x(1)*x(1)      + coeff2(6) * x(1)*x(2)      +  coeff2(7) * x(2)*x(2) + ...
        coeff2(8) * x(1)           + coeff2(9) * x(2)           +  coeff2(10) * 1;
    f1 = @(d) func1(d - [x(i,j)+inter/2  y(i,j)+inter/2]);
    f2 = @(d) func2(d - [x(i+1,j)+inter/2  y(i+1,j)+inter/2]);
    p = x(i,j-1):1:x(i,j+2);
    q1 = y(i-1,j):1:y(i+2,j);
    q2 = y(i,j):1:y(i+3);
    numx = size(p,2);
    numy = size(q1,2);
    for ip = 1:numx
        for iq = 1:numy
            W1(iq,ip) = f1([p(ip),q1(iq)]);
            W2(iq,ip) = f2([p(ip),q2(iq)]);
        end
    end
    surf(p,q1,W1); hold on
    surf(p,q2,W2); hold on

end