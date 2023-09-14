 clear
%addpath ..\
%% Data initial?
% load layergriddataold;
% load layerModelold;
load layergriddatanew;
load layerModelnew;
load layerModel_zdomainnew;
load VelModnew;
minx = layergriddata{2,1}(1,1);
miny = layergriddata{2,2}(1,1);
% VelMod = [0;3640.90010132031;4120.98796657918;4523.06608475320;4624.27005780428;4173.29245948519;4353.12705311226;4053.43720554458;3988.73293632264;4382.21136690776;4389.63944905434;4402.79727144361;4499.96072985868];

%% 取用部分地层，平均合并地层的波传播速度
% ilayer = [1 4 6 7 8 9 10 11 12];
ilayer = 1:1:12;
tempVelMod = zeros(1,size(ilayer,2)+1);
for j = 1:1:ilayer(1)
    tempVelMod(1) =  VelMod(j) + tempVelMod(1);
end
tempVelMod(1) = tempVelMod(1)/(ilayer(1));
for i = 1:size(ilayer,2)-1
    for j = ilayer(i)+1:1:ilayer(i+1)
        tempVelMod(i+1) = VelMod(j) + tempVelMod(i+1);
    end
    tempVelMod(i+1) = tempVelMod(i+1)/(ilayer(i+1) - ilayer(i)); 
end
for j = ilayer(end)+1:1:size(VelMod,2)
    tempVelMod(end) =  VelMod(j) + tempVelMod(end);
end
tempVelMod(end) = tempVelMod(end)/(size(VelMod,2) - ilayer(end));
VelMod = tempVelMod;

%% cycle test
baseCoord =  [14620730 4650330 1500];
sensorPositions = zeros(35,3);
sensorup = [14620550.308 4650200.4000 1375.0900000] - baseCoord;
sensordo = [14620546.050 4650153.1130 -2567.894000] - baseCoord;
sensorleng = norm(sensorup - sensordo);
sensordist = 35;
for isensor = 1:1:20
    sensorPositions(isensor,:) = sensordo + (isensor-1)*sensordist/sensorleng .*(sensorup - sensordo);
end
sourcePositions =[3250,1100,-3700]+[minx,miny,0];
ma = 1;
markPosition4 = zeros(100,30);
markPosition13 = zeros(3,30,100);
markinitialguessVel = zeros(100,30);
markerrort = zeros(100,1);
marktrivalt = zeros(100,300);
marksnell = zeros(100,100);
marksnellerror = zeros(100,100);
countmark = 1;
% Detector = [-183.690032826743,-173.994513485590,-3822.91121297440];
% sourcePositions = [1397.00100086494,476.866471529248,-3709.61430859999 ;
%     1380, 470, -3700];
 for j = 1:2
%      for i  =1:10
        %for k = 1:10
%           i = 10; %j =0;
%           j = 8;
Detector = sensorPositions(j,:); 
Source = sourcePositions;
% Detector=[500,0,0]+[minx,miny,0] + [i*250 j*100 0];
% Source =[750,100,-6000]+[minx,miny,0];
% Source =[3250,1100,-6000]+[minx,miny,0];
% Source =[3250,100,-6000]+[minx,miny,0];
% Source =[750,1100,-6000]+[minx,miny,0];
% Source =[2000,600,-6000]+[minx,miny,0];
% ilayer = [ 3 ];



[Position, markX0, initialguessVel, errort,trivalt] = RayTrace3D_layerModel(layerModel(ilayer),layerModel_zdomain(ilayer),layergriddata(ilayer,:),VelMod,Detector,Source);
numP = size(Position,2);
markPosition4(countmark,1:numP) = Position(4,:);
markPosition13(1:3,1:numP,countmark) = Position(1:3,:);
markinitialguessVel(countmark,1:numP-1) = initialguessVel(:);
markerrort(countmark) = errort;
numtrivalt = length(trivalt);
marktrivalt(countmark,1:numtrivalt) = trivalt(:);
numX0 = size(markX0,3);
%storemarkX0(1:4,1:40,1:numX0,countmark) = markX0(:,:,:);
countmark = countmark+1;



%% plotfigure
plotFigure(Position,layergriddata(ilayer,1),layergriddata(ilayer,2),layergriddata(ilayer,3),ma)
ma = 2;

%% snelltest %%%
snellcoeff=testsnell(layerModel(ilayer),layergriddata(ilayer,:),Position,initialguessVel);
row = size(snellcoeff);
for i = 1:2:row
    marksnellerror(countmark-1,floor((i+1)/2)) = norm((snellcoeff(i) - snellcoeff(i+1))/snellcoeff(i));
end
marksnell(countmark-1,1:row) = snellcoeff(:);
%          end
%     end
end