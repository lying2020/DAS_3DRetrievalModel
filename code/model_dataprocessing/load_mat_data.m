

function val = load_mat_data(mat_name)

% INPUT: mat_name, a string
% OUTPUT: mat var

% 载入 mat 数据
% val_struct = load('tmp.mat');  % 载入 mat 数据，出来是一个结构体，我们需要的变量是【结构体.变量名】
val_struct = load(mat_name);
val_names = fieldnames(val_struct);  % 获取结构体后那个未知的变量名
val = getfield(val_struct, val_names{1});  % 读取该变量名下的数据，并重新命名变量名val

end
