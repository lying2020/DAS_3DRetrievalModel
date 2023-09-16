%
%
%
% close all;
% clear
%  DEBUG ! ! !
dbstop if error;
format long 
addpath(genpath('../../../include'));
%% -----------------------------------------------------------------------------------------------------
%
baseCoord = [14620550.3, 4650200.4, 1514.78];
type = 'velocity';
%% filenameList is a cell array
filenameList = getfilenamelist(type);  
tic
%% velocityTmp is a n*7 matrix.
velocityTmp = readtxtdata(filenameList, type);
% velocityTmp = readlayerdata(filenameList);
%% xMat, yMat is a m* n matrix. zMat, velocity is m*n*k matrix.  
% [xMat, yMat, zMat, velocityMat] = layerdatatransform(velocityTmp, baseCoord, type);
[xMat, yMat, zMat, velocityMat] = velocitydata(velocityTmp, baseCoord);     % for velocity model
 t_velocity1 = toc
% disp('GOOD JOB !!!');
%% 
deltaX = max(velocityTmp(:, 4:6)) - min(velocityTmp(:, 4:6))
deltaV = 304800 / min(velocityTmp(:, 7)) - 304800 / max(velocityTmp(:, 7))

%% velocity slice 
figure;
slice(velocityMat,[30, 60],  [90, 180], [1, 60])
view(-34,24)
cb = colorbar;                                  % create and label the colorbar
cb.Label.String = 'velocity distribution.';

%% 生成三维 速度剖面图。
meanV = 3800;  % 4000;  % mean(velocityMat(:));
data = (velocityMat - meanV)/1000;
% rLen = floor(length(data(:)));
% rArray = ceil(rand(rLen, 1)*rLen);
% rArray = unique(rArray);
% data(rArray) = 0; 
%% 创建由随机数据组成的 10×10×10 数组并对其进行平滑处理。
% data = rand(10,10,10);
figure;
%% 将数据显示为带有端顶的等值面
data = smooth3(data, 'box', 5);
 patch(isocaps(data,.5), 'FaceColor', 'interp', 'EdgeColor', 'none');
p1 = patch(isosurface(data, .5), 'FaceColor', 'blue', 'EdgeColor', 'none');
isonormals(data, p1);
view(3); 
axis vis3d tight
camlight left
colormap('jet');
lighting gouraud






