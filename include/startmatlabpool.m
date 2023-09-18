function [pool] = startmatlabpool(size, time, clusterfile)
pool=[];
isstart = 0;
nCores = feature('numcores');
size = min(nCores, size);
if isempty(gcp('nocreate'))==1
    isstart = 1;
end
if isstart==1
    if nargin==0
        pool=parpool('local');
    elseif nargin == 1
        try
            pool=parpool('local',size);%matlabpool('open','local',size);
        catch ce
            pool=parpool('local');%matlabpool('open','local');
            size = pool.NumWorkers;
            display(ce.message);
            display(strcat('restart. wrong  size=',num2str(size)));
        end
    elseif nargin == 2
        try
            pool=parpool('local',size,'IdleTimeout',time);%matlabpool('open','local',size);
        catch ce
            pool=parpool('local');%matlabpool('open','local');
            size = pool.NumWorkers;
            time = pool.IdleTimeout;
            display(ce.message);
            display(strcat('restart. wrong  size=',num2str(size)));
            display(strcat('wrong  time=',num2str(time)));
        end
    elseif nargin == 3
        try
            pool=parpool(clusterfile,size,'IdleTimeout',time);%matlabpool('open','local',size);
        catch ce
            pool=parpool(clusterfile);%matlabpool('open','local');
            size = pool.NumWorkers;
            time = pool.IdleTimeout;
            display(ce.message);
            display(strcat('restart. wrong  size=',num2str(size)));
            display(strcat('wrong  time=',num2str(time)));
            display(clusterfile);
        end
    end
else
    displaytimelog('matlabpool has started');
    closematlabpool;
    if nargin ==1 
        startmatlabpool(size);
    elseif nargin == 2
        startmatlabpool(size,time);
    elseif nargin == 3
        startmatlabpool(size,time,clusterfile);
    else
        startmatlabpool();
    end
end