function addpath_recursive(folder)
    % 添加当前文件夹到路径
    addpath(genpath(folder));

    % 获取文件夹中的所有子文件夹
    subfolders = dir(fullfile(folder, '*'));

    % 循环遍历每个子文件夹
    for i = 1:length(subfolders)
        if subfolders(i).isdir && ~strcmp(subfolders(i).name, '.') && ~strcmp(subfolders(i).name, '..')
            % 如果是一个子文件夹，递归调用这个函数
            addpath_recursive(fullfile(folder, subfolders(i).name));
        end
    end
end