
function [abs_dirlist, relative_dirlist] = get_recursive_dirlist(varargin)

abs_dirlist = []; relative_dirlist = [];

if length(varargin)
	source_dir = varargin{1};
else
	source_dir = pwd;
end

if length(varargin) > 1
	depth = varargin{2};
else
	depth = inf;
end

if isdir(source_dir)
  relative_dirlist = build_relative_dirlist(source_dir, [], depth);
	abs_dirlist = strcat(source_dir, filesep, relative_dirlist);
else
	disp(sprintf('%s: source_dir %s is not a valid directory', mfilename, source_dir));
	return;
end


function list = build_relative_dirlist(path_str, dirname, depth)

list = {[]};
list_idx = 1;

if depth > 0
	if ~isempty(dirname)
  	dir_path = fullfile(path_str, dirname);
	else
  	dir_path = path_str;
	end

	dir_struct = dir(dir_path);

	for n=1:length(dir_struct)
  	if ~strcmp(dir_struct(n).name, '.') && ~strcmp(dir_struct(n).name, '..') && dir_struct(n).isdir
    	new_list = build_relative_dirlist(dir_path, dir_struct(n).name, depth-1);

    	for p=1:length(new_list)
      	list{list_idx,1} = fullfile(dir_struct(n).name, new_list{p});
				list_idx = list_idx + 1;
    	end
  	end
	end
end
