

function val = load_mat_data(mat_name)

% INPUT: mat_name, a string
% OUTPUT: mat var

% ���� mat ����
% val_struct = load('tmp.mat');  % ���� mat ���ݣ�������һ���ṹ�壬������Ҫ�ı����ǡ��ṹ��.��������
val_struct = load(mat_name);
val_names = fieldnames(val_struct);  % ��ȡ�ṹ����Ǹ�δ֪�ı�����
val = getfield(val_struct, val_names{1});  % ��ȡ�ñ������µ����ݣ�����������������val

end
