function [ax] = plotresult(result,sensorPositions,sourcePosition)
figure; hold on;

ax = plot3(result{1}(:,1),result{1}(:,2),result{1}(:,3),'o','MarkerSize',3,'Color','r','DisplayName','result');hold on;
if size(result,2) > 1
    plot3(result{2}(:,1),result{2}(:,2),result{2}(:,3),'+','MarkerSize',3,'Color','g','DisplayName','resultafterturb1');hold on;
end
if size(result,2) > 2
    plot3(result{3}(:,1),result{3}(:,2),result{3}(:,3),'s','MarkerSize',3,'Color','b','DisplayName','resultafterturb2');hold on;
end
if nargin > 1
    plot3(sensorPositions(:,1),sensorPositions(:,2),sensorPositions(:,3),'o','MarkerSize',3,'Color','b','DisplayName','sensorPositions');
end
if nargin > 2
    plot3(sourcePosition(1,1),sourcePosition(1,2),sourcePosition(1,3),'*','MarkerSize',15,'Color',[1 0 1],'DisplayName','sourcePosition');
end
legend('Show')

