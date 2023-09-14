%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2019-09-24: Complete
% 2020-05-24: Modify the description and comments
% 2020-07-06: add das format read function(binary storage)
% 2020-11-04: do some bug fixes
% This code is  used to sort the cell string name 
%% -----------------------------------------------------------------------------------------------------
function [cs, index] = sortfilename(stringList, mode)
% -----------------------------------------------------------------------------------------------------
% sortfilename: Natural order sort of cell array of strings.
% INPUT:
% stringList: n*1 cell, each cell contains a string. 
% mode: {'ascend','descend'}
% 
% OUTPUT: 
% cs: n*1 cell, a 'mode' order string. 
% index: a order index.  
% usage:  [cs, index] = sortfilename(stringList)
%
% where,
%    stringList is a cell array (vector) of strings to be sorted.
%    cs is stringList, sorted in natural order.
%    index is the sort order such that cs = stringList(index);
%    
% Natural order sorting sorts strings containing digits in a way such that
% the numerical value of the digits is taken into account.  It is
% especially useful for sorting file names containing index numbers with
% different numbers of digits.  Often, people will use leading zeros to get
% the right sort order, but with this function you don't have to do that.
% For example, if C = {'file1.txt','file2.txt','file10.txt'}, a normal sort
% will give you
%
%       {'file1.txt'  'file10.txt'  'file2.txt'}
%
% whereas, sortfilename will give you
%
%       {'file1.txt'  'file2.txt'  'file10.txt'}
%
% See also: sort
%% -----------------------------------------------------------------------------------------------------
% set default value for mode if necessary.
if nargin < 2,   mode = 'ascend';    end

% Make sure mode is either 'ascend' or 'descend'.
modes = strcmpi(mode, {'ascend','descend'});
isDescend = modes(2);
if ~any(modes)
    error('sortfilename:sortDirection',...
        'sorting direction must be ''ascend'' or ''descend''.')
end
%% -----------------------------------------------------------------------------------------------------
[cs, index] = sortfilename_nat(stringList, mode);
%
%% -----------------------------------------------------------------------------------------------------
csLen = length(cs);
nameArray = cell(csLen, 1);
for ifile = 1: csLen
[~, name] = fileparts(cs{ifile});
nameArray{ifile} = name;
end
% Cellular arrays support only one input parameter, 'ascend' order. 
[~, idxArray] = sort(nameArray);  % 
%
% if mode == 'descend', reverse the following order
if isDescend,    idxArray = flip(idxArray);     end
cs = cs(idxArray);
end
% 
% 
% 
function [cs, index] = sortfilename_nat(stringList, mode)
%% -----------------------------------------------------------------------------------------------------
% set default value for mode if necessary.
if nargin < 2,   mode = 'ascend';    end

% Make sure mode is either 'ascend' or 'descend'.
modes = strcmpi(mode, {'ascend','descend'});
isDescend = modes(2);
if ~any(modes)
    error('sortfilename:sortDirection',...
        'sorting direction must be ''ascend'' or ''descend''.')
end
%% -----------------------------------------------------------------------------------------------------
% Replace runs of digits with '0'.
c2 = regexprep(stringList, '\d+','0');

% Compute char version of c2 and locations of zeros.
s1 = char(c2);
z = s1 == '0';

% Extract the runs of digits and their start and end indices.
[digruns, first, last] = regexp(stringList, '\d+', 'match', 'start','end');

% Create matrix of numerical values of runs of digits and a matrix of the
% number of digits in each run.
numString = length(stringList);
maxLen = size(s1, 2);
numValue = NaN(numString, maxLen);
numDig = NaN(numString, maxLen);
for i = 1:numString
    numValue(i, z(i, :)) = sscanf(sprintf('%s ', digruns{i}{:}), '%f');
    numDig(i, z(i, :)) = last{i} - first{i} + 1;
end

% Find columns that have at least one non-NaN.  Make sure activecols is a
% 1-by-n vector even if n = 0.
activecols = reshape(find(~all(isnan(numValue))), 1, []);
n = length(activecols);

% Compute which columns in the composite matrix get the numbers.
numcols = activecols + (1: 2: 2*n);

% Compute which columns in the composite matrix get the number of digits.
ndigcols = numcols + 1;

% Compute which columns in the composite matrix get chars.
charcols = true(1, maxLen + 2*n);
charcols(numcols) = false;
charcols(ndigcols) = false;

% Create and fill composite matrix, comp.
comp = zeros(numString, maxLen + 2*n);
comp(:, charcols) = double(s1);
comp(:, numcols) = numValue(:, activecols);
comp(:, ndigcols) = numDig(:, activecols);

%% -----------------------------------------------------------------------------------------------------
% Sort rows of composite matrix and use index to sort c in ascending or
% descending order, depending on mode.
[~, index] = sortrows(comp);
if isDescend
    index = index(end:-1:1);
end
% 
index = reshape(index, size(stringList));
cs =stringList(index);
    
end

