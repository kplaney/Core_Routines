
function [abs_filelist, relative_filelist] = get_recursive_filelist(varargin)

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
	relative_filelist = build_relative_filelist(source_dir, [], depth);
	abs_filelist = strcat(source_dir, filesep, relative_filelist);
end
	

function list = build_relative_filelist(path_str, dirname, depth)

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
  	if ~strcmp(dir_struct(n).name, '.') && ~strcmp(dir_struct(n).name, '..')
			if dir_struct(n).isdir
    		new_list = build_relative_filelist(dir_path, dir_struct(n).name, depth-1);

		   	for p=1:length(new_list)
					if ~isempty(new_list{p})
		    		list{list_idx,1} = fullfile(dir_struct(n).name, new_list{p});
						list_idx = list_idx + 1;
					end
		    end
			else
				list{list_idx,1} = dir_struct(n).name;
				list_idx = list_idx + 1;				
			end
  	end
	end
end
