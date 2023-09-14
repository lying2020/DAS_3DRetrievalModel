function snellcoeff=testsnell(layerModel,layergriddata,U,VelMod)
num=size(U,2);
sintheta=zeros(2*(num-2),1);
costheta = zeros(2*(num-2),1);
snellcoeff=zeros(2*(num-2),1);
inter = layergriddata{1,1}(2,2) - layergriddata{1,1}(1,1);
for i=2:1:num-1
    %sintheta(i) =  norm(U(1:2,i)-U(1:2,i+1))/norm(U(:,i)-U(:,i+1));
    %norvec = getnorvec(layerModel(U(4,i)),layergriddata(U(4,i),:),U(1:2,i)',1);
    miny = layergriddata{U(4,i),2}(1,1);minx = layergriddata{U(4,i),1}(1,1);
    jd = floor((U(1,i) - minx)/inter + 1); id = floor((U(2,i) - miny)/inter+1);
    norvec = [(layergriddata{U(4,i),3}(id+1,jd+1) - layergriddata{U(4,i),3}(id,jd))/inter ...
        (layergriddata{U(4,i),3}(id+1,jd+1) - layergriddata{U(4,i),3}(id,jd))/inter  -1];
    costheta(2*i-3) = norvec*(U(1:3, i) - U(1:3,i-1))/norm(U(1:3, i) - U(1:3,i-1)) / norm(norvec);
    sintheta(2*i-3) = sqrt(1 - costheta(2*i-3)^2);
    snellcoeff(2*i-3)=sintheta(2*i-3)/VelMod(i-1);
    costheta(2*i-2) = norvec*(U(1:3, i) - U(1:3,i+1))/norm(U(1:3, i) - U(1:3,i+1)) / norm(norvec);
    sintheta(2*i-2) = sqrt(1 - costheta(2*i-2)^2);
    snellcoeff(2*i-2)=sintheta(2*i-2)/VelMod(i);
end
end