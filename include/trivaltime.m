function [time,steptime] = trivaltime(VelMod,Position)
%% 计算地震波沿折线Position运行时间
%  VelMod 速度模型m+1个交点Position间有m个速度例如[ 5000 4000].
%  Position 地震波传播的折线路经，每段路径对应一个速度VelMod

num = size(VelMod,2);
steptime = zeros(1,num);
for i = 1:num
    steptime(i) = norm(Position(1:3,i) - Position(1:3,i+1))/VelMod(i);
end
time = sum(steptime);
