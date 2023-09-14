%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-05-24: Modify the description and comments
% 2020-07-06: modify the staltaloop recursion function
%
% this code is a clustering algorithm for eliminating bad data
%% -----------------------------------------------------------------------------------------------------
% this code is a clustering algorithm for eliminating bad data
%% -----------------------------------------------------------------------------------------------------
function [len0, cmeans0, idxArray] = clusteringfunc(meas)
% �������������ʱ�䴰�е��쳣���ݽ������ֺʹ���
% meas: num* m matrix.
% num must more than 3.
n = 3;
[cidx2,cmeans2] = kmeans(meas, n, 'dist','sqeuclidean');
%%
[lenT, intervalT, meanT, stdT] = deal(zeros(n, 1));
% ÿһ��������ݡ�
for i = 1: n
    tmp = meas(cidx2 == i);    lenT(i, 1) = length(tmp);
    intervalT(i, 1) = (max(tmp) - min(tmp));
    meanT(i, 1) = mean(tmp);  stdT(i, 1) = std(tmp);
end

%% ÿһ���������֮���ƽ�������
intervalT = intervalT./lenT; 
%% ȡ���ݳ���������1/6�ļ����࣬��Ϊ�������ࡣ
idx0 = find(lenT > (sum(lenT)/4));
%% �������ݵļ�Ȩƽ�����
len0 = sum(intervalT(idx0).*lenT(idx0))*sum(lenT)/sum(lenT(idx0));
%% �������ݵ�ƽ������
cmeans0 = sum(cmeans2(idx0).*lenT(idx0))/sum(lenT(idx0));

idxA = 1: length(cidx2);
idxArray = [];
for i = 1:length(idx0)
    idxArray = [idxArray, idxA(cidx2 == idx0(i))];
end
idxArray = sort(idxArray);

end


%
% figure;
% ptsymb = {'bs','r^','md','go','c+'};
% for i = 1:2
%     clust = find(cidx2==i);
%     plot3(meas(clust,1),meas(clust,2),meas(clust,3),ptsymb{i});
%     hold on
% end
% plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'ko');
% plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'kx');
% hold off
% xlabel('Sepal Length');
% ylabel('Sepal Width');
% zlabel('Petal Length');
% view(-137,10);
% grid on
%

% [cidx3,cmeans3,sumd3] = kmeans(meas,3,'replicates',5,'display','final');
%
% [cidx3,cmeans3] = kmeans(meas,3,'Display','iter');








