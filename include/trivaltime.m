function [time,steptime] = trivaltime(VelMod,Position)
%% �������������Position����ʱ��
%  VelMod �ٶ�ģ��m+1������Position����m���ٶ�����[ 5000 4000].
%  Position ���𲨴���������·����ÿ��·����Ӧһ���ٶ�VelMod

num = size(VelMod,2);
steptime = zeros(1,num);
for i = 1:num
    steptime(i) = norm(Position(1:3,i) - Position(1:3,i+1))/VelMod(i);
end
time = sum(steptime);
