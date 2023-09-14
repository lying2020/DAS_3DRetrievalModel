function  filenameList = getfilenamelistfromfolder(folderPath, fileExtension)
% Get a list of all files in the specified folder with the specified file extension
% fileExtension£º '*.das'
files = dir(fullfile(folderPath, fileExtension));

% Initialize an empty cell array to store the file names and paths
filenameList = cell(1, numel(files));

% Iterate over each file and store its name and path in the cell array
for i = 1:numel(files)
    filenameList{i} = fullfile(files(i).folder, files(i).name);
end

% if isequal(fileName, 0)
%     disp('User selected Cancel');
%     return;
% else
%     disp(['User selected: ', fullfile(pathName, fileName)]);
% end
% 
if isa(filenameList, 'char')
    tmpFilename{1, 1} = filenameList;
    filenameList = tmpFilename;
end
%
if size(filenameList, 1) == 1, filenameList = filenameList';   end
% default ascending order.  
filenameList = sortfilename(filenameList);
% 
% 
end