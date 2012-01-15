
function dirpaths_string = genpath2(source_dirs, dir_omit_keywords)

% Process input args
if nargin == 0 || isempty(source_dirs)
	source_dirs = pwd;
end

if nargin < 2
	dir_omit_keywords = [];
else
	if ~iscellstr(dir_omit_keywords)
		dir_omit_keywords = {dir_omit_keywords};
	end
end

if ~iscellstr(source_dirs)
	source_dirs = {source_dirs};
end

% Use genpath to get one big character string containing all the subdir paths under each source dir
% NB: genpath will separate each dir with a ':'
all_dirpaths_string = [];

for d=1:length(source_dirs)
	all_dirpaths_string = strcat(all_dirpaths_string, genpath(source_dirs{d}));
end

if ~isempty(dir_omit_keywords)
	% Convert the single string of dirpaths to a cell array of dirpath strings
	% This is equivalent to building a cell array as: C = {'hello' 'yes' 'no' 'goodbye'};
	dirpath_strings = strcat('''', all_dirpaths_string); % First put a quote at the start of the string
	dirpath_strings = strrep(dirpath_strings, ':/', ''' ''/'); % Then convert each :/ to ' '/  - so that each dirpath is wrapped in quotes
	dirpath_strings(end) = '''';	% Replace the colon at the end of the string with a quote character
	eval(sprintf('dirpaths_cell = {%s};', dirpath_strings)); % Convert to cell array of strings
	
	% Now loop over keywords signalling dirs we want to omit
	for v=1:length(dir_omit_keywords)
		% Get an index vector of dirpaths in the cell array that DON'T contain the given keyword
		dirpaths_to_keep_idx = find(cellfun(@(dirpath) isempty(strfind(dirpath, dir_omit_keywords{v})), dirpaths_cell));
		
		% Keep only these dirpaths
		dirpaths_cell = dirpaths_cell(dirpaths_to_keep_idx);
	end
	
	% Convert the cell array of strings back to a single string with dirpaths separated by colons
	dirpaths_string = '';
	
	for d=1:length(dirpaths_cell)
		dirpaths_string = strcat(dirpaths_string, dirpaths_cell{d}, ':');
	end
else
	dirpaths_string = all_dirpaths_string;
end
