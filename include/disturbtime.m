function timeturb = disturbtime(time,coef,disturbway)
if nargin < 3
    disturbway = 1;
end

if disturbway == 1
    numt = length(time);
    timeturb(1) = time(1);
    timeturb(numt) = time(numt);
    ran = randn(1,numt-2);
    for it = 2:(numt-1)
        ra = ran(it-1);
        if ra < 0
            tminus = time(it) - time(it-1);
            timeturb(it) = tminus*(ra)*coef + time(it);
        elseif ra >=0
            tminus = time(it+1) - time(it);
            timeturb(it) = tminus*(ra)*coef + time(it);
        end
    end
elseif disturbway == 2
    numt = length(time);
    tminus = (time(numt) - time(1))/(numt-1);
    ran = randn(1,numt);
    timeturb = time;
    for it = 1:numt
        ra = ran(it);
        timeturb(it) = tminus*ra*coef +time(it);
    end
end