%
%
%
 close all;
% clear
clc
%  DEBUG ! ! !
dbstop if error;
format long
addpath(genpath('../../../include'));
% -----------------------------------------------------------------------------------------------------
wellCoordSet = importdata('wellModel.mat');
baseCoord = [14620550.3 4650200.4 1514.78];

% %% layer model
type = 'layer';
filenameList_layer = getfilenamelist(type);
tic
[baseCoord, coeffModel, layerGridModel] = getlayermodel(filenameList_layer, baseCoord);
t_layermodel = toc   
% %
% -----------------------------------------------------------------------------------------------------
ax1= axes(figure);
% layerGridModel = [];
[h1, h2, h3, h4, h5] = sourceplot3D(ax1, layerGridModel, wellCoordSet) ; % , sensorCoord);

% %% velocity model
type = 'velocity';
 filenameList_v = getfilenamelist(type, 'off');
tic
[velocityModel, velocityCount, xMat, yMat, zMat, velocityMat]= getvelocitymodel(filenameList_v, baseCoord, coeffModel, layerGridModel);
t_velocity3 = toc
%% 
[xLen, yLen, zLen] = size(zMat);
xx = linspace(min(xMat(:)), max(xMat(:)), xLen);
yy = linspace(min(yMat(:)), max(yMat(:)), yLen);
zz = linspace(min(zMat(:)), max(zMat(:)), zLen);
[xM, yM, zM] = meshgrid(yy, xx, zz);
% slice 
deltaX = (max(xx) - min(xx))/4; 
deltaY = (max(yy) - min(yy))/4;
deltaZ = (max(zz) - min(zz))/4;
% 
yslice = [min(xx) + deltaX, min(xx) + 3*deltaX];
xslice = [min(yy) + 2*deltaY, max(yy)];
zslice = [min(zz), min(zz) + deltaZ*2];
%% ----------------------------------------------------------------------------------------------------
if ~xM, return;  end
ax2 = axes(figure);
slice(ax2, xM, yM, zM,velocityMat, xslice, yslice, zslice);
xlabel(ax2, 'y');  ylabel(ax2, 'x');

figure;
slice(velocityMat,[30, 60],  [90, 180], [1, 60])
view(-34,24)
cb = colorbar;                                  % create and label the colorbar
cb.Label.String = 'velocity distribution.';


%% ���������������ɵ� 10��10��10 ���鲢�������ƽ��������
figure;
% data = rand(10,10,10);
data = velocityMat;
data = smooth3(data,'box',5);

%% ��������ʾΪ���ж˶��ĵ�ֵ��
patch(isocaps(data,.5),...
   'FaceColor','interp','EdgeColor','none');
p1 = patch(isosurface(data,.5),...
   'FaceColor','blue','EdgeColor','none');
isonormals(data,p1);
view(3); 
axis vis3d tight
camlight left
colormap('jet');
lighting gouraud



