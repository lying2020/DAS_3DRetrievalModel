function addpath_recursive(folder)
    % ��ӵ�ǰ�ļ��е�·��
    addpath(genpath(folder));

    % ��ȡ�ļ����е��������ļ���
    subfolders = dir(fullfile(folder, '*'));

    % ѭ������ÿ�����ļ���
    for i = 1:length(subfolders)
        if subfolders(i).isdir && ~strcmp(subfolders(i).name, '.') && ~strcmp(subfolders(i).name, '..')
            % �����һ�����ļ��У��ݹ�����������
            addpath_recursive(fullfile(folder, subfolders(i).name));
        end
    end
end