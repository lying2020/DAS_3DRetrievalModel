function  plotFigure(U,X,Y,Z,ma)
num=size(U,2);
figure(1)
for i=1:num-1
    plot3(U(1,i),U(2,i),U(3,i),'r.','MarkerSize',10);
    hold on
    line([U(1,i) U(1,i+1)],[U(2,i) U(2,i+1)],[U(3,i) U(3,i+1)])
    hold on
end
plot3(U(1,end),U(2,end),U(3,end),'r.','MarkerSize',10);
hold on
if ma == 1
numz = size(Z,1);
for i  = 1:numz
surf(X{i},Y{i},Z{i},'EdgeColor', 'none')
hold on
end
alpha(0.3)
grid on
end

