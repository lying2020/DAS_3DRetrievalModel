clear ZZ x y m n;
%ilayer = 4;
num = size(ilayer,2);
if num > 2
else
for i = 1:num
minx = layerGridModel{ilayer(i),1}(1,1);
miny = layerGridModel{ilayer(i),2}(1,1);
maxx = layerGridModel{ilayer(i),1}(end,end);
maxy = layerGridModel{ilayer(i),2}(end,end);
x(i,:) = minx:10:maxx-10;
y(i,:) = miny:10:maxy-10;
[XX,YY] = meshgrid(x,y);
[m(i)] = size(x(i,:),2);
n(i) = size(y(i,:),2);
end
% Z = @(X,Y) norm([X Y layerz(layerCoeffModel(ilayer),layerGridModel(ilayer,:),[X Y],1)] - Source)/VelMod(1) + ...
%     norm([X Y layerz(layerCoeffModel(ilayer),layerGridModel(ilayer,:),[X Y],1)] - Detector)/VelMod(2);
if num == 1
    for i  = 1:m(1)
        for j = 1:n(1)
            P = [Source;[x(i) y(j) layerz(layerCoeffModel(ilayer(1)),layerGridModel(ilayer(1),:),[x(i) y(j)],1)];Detector]';
            ZZ(j,i) = trivaltime(VelMod,P);
        end
    end
    figure(3)
mesh(x,y,ZZ)
[row,col] = find(ZZ == min(min(ZZ)));
distancefromPosition = Position(1:2,2) - [XX(row,col) YY(row,col)]'
timefromPosition = trivaltime(VelMod,Position) - ZZ(row,col)
colorbar
elseif num == 2
for i = 1:m(1)
for j = 1:n(1)
    for ii = 1:m(2)
        for jj = 1:n(2)
%ZZ(i,j) = Z(XX(i,j),YY(i,j));
P = [Source;[x(i) y(j) layerz(layerCoeffModel(ilayer(1)),layerGridModel(ilayer(1),:),[x(i) y(j)],1)];
    [x(ii) y(jj) layerz(layerCoeffModel(ilayer(2)),layerGridModel(ilayer(2),:),[x(ii) y(jj)],1)]; Detector]';
ZZ(i,j,ii,jj) = trivaltime(VelMod,P);
        end
    end
end
end
end
end
