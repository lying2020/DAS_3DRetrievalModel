pool = startmatlabpool(4);
N=1000;
M=100;
data = cell(1,N);
for kk = 1:N
   data{kk} = rand(M);
end
display(strcat('datasize:',num2str(N*M*M/1024/1024),'M doubles'));
tic;
parfor ii = 1:N
     c1(:,ii) = eig(data{ii});
end
t1 = toc; 
display(strcat('parafor:',num2str(t1),'seconds'));
 
tic;
for ii = 1:N
     c2(:,ii) = eig(data{ii});
end
t2 = toc; 
display(strcat('for:',num2str(t2),'seconds'));
 
closematlabpool;