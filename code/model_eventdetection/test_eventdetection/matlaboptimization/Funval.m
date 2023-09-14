
% 非常感谢，估计后人会用到这段代码，你给的图片敲了半天；
function fv = Funval(f,varvec,varval)  %向量输入为列向量
var = symvar(f);
varc = symvar(varvec);
s1 = length(var);
s2 = length(varc);
m=floor((s1-1)/3+1);
varv = zeros(1,m);
if s1 ~= s2
    for i=0: ((s1-1)/3)
       k = strfind(varc,var(3*i+1));
          index = (k-1)/3;
          varv(i+1) = varval(index+1);
    end
    fv = subs(f,var,varv);
else
fv = subs(f,varvec,transpose(varval));
end
end