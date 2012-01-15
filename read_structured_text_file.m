
function [Text_Struct, column_headings] = read_structured_text_file(text_filepath, num_header_lines_to_skip, delimiter, ...
																																		use_column_headings_as_field_names, field_name_prefix)

Text_Struct = []; column_headings = [];

default_num_header_lines_to_skip = 0;
default_delimiter = '\t';

switch nargin
	case 0
		disp(sprintf('Usage: %s(text_filepath, num_header_lines_to_skip, delimiter, use_column_headings_as_field_names, field_name_prefix)', mfilename));
		return;
	case 1
		num_header_lines_to_skip = default_num_header_lines_to_skip;
  	delimiter = default_delimiter;
  	use_column_headings_as_field_names = true;
  	field_name_prefix = '';
	case 2
		delimiter = default_delimiter;
		use_column_headings_as_field_names = true;
		field_name_prefix = '';
	case 3
		use_column_headings_as_field_names = true;
		field_name_prefix = '';	
	case 4
		field_name_prefix = '';	
end

if isempty(num_header_lines_to_skip)
	num_header_lines_to_skip = default_num_header_lines_to_skip;
end

if isempty(delimiter)
	delimiter = default_delimiter;
end


% If num of header lines to skip is < 0 then we assume the
% first line contains data rather than column headings
if num_header_lines_to_skip < 0
	use_column_headings_as_field_names = false;
end

% Open pointer to file
disp(sprintf('Reading in text file: %s', text_filepath));
fid = fopen(text_filepath, 'r');

% Skip over some header lines if required
if num_header_lines_to_skip > 0
  disp(sprintf('Skipping first %d lines of file', num_header_lines_to_skip));
  
  for n=1:num_header_lines_to_skip
    tline = fgetl(fid);
  end
end

% Get the column_headings
tline = fgetl(fid);
column_headings = parse_line_text(tline, delimiter);
num_fields = length(column_headings);
disp(sprintf('%d columns', num_fields));

% Create the struct field names
if use_column_headings_as_field_names
	% Convert column headings (which may contain invalid characters for
	% Matlab struct field names) into valid struct field names
	for f=1:num_fields
  	field_name = column_headings{f};

		tokens_to_convert_to_underscores = {' ', '-', '+', '=', '/', '\', '''', ':', '__'};
		tokens_to_strip_out = {'`', '~', '!', '@','£', '#', '$', '%', '^', '&', '*', ',', '.', ...
													 ';', ':', '\', '?', '/', '(', ')', '[', ']', '{', '}', '"'};

		for s=1:length(tokens_to_convert_to_underscores)
			if ~isempty(field_name)
				field_name = strrep(field_name, tokens_to_convert_to_underscores{s}, '_');
			end
		end

		for s=1:length(tokens_to_strip_out)
			if ~isempty(field_name)
				field_name = strrep(field_name, tokens_to_strip_out{s}, '');
			end
		end

		if ~isempty(field_name)
			% Remove an underscore at the start or end of the field_name
  		if field_name(1) == '_'
    		field_name = field_name(2:end);
  		end

  		if field_name(end) == '_'
    		field_name = field_name(1:end-1);
  		end

			% Strip out any multiple sequences of underscores (i.e. __, ___ etc )
			while (1)
				field_name = strrep(field_name, '__', '_');			
				if isempty(regexp(field_name, '__+'))
					break;
				end
			end
		end
		
		% Add optional fieldname prefix
  	field_names{f} = strcat(field_name_prefix, field_name);

		% Now see if this is a valid struct field name
		try
			Text_Struct.(field_names{f}) = [];
		catch
			disp(sprintf('%s: unable to use column headings as struct field names. Re-run with this option set to false', mfilename));
			return;
		end
	end
else
	field_names = strcat('Col_', cellfun(@(x) num2str(x), num2cell([1:num_fields]), 'UniformOutput', false));
	
	% If there 
	if num_header_lines_to_skip < 0
		% Rewind to the beginning of the file so that we can read the first line in again and store the data in the struct
		fseek(fid, 0, -1);
	end
end

% Now read in the complete text file and store lines in struct array
struct_idx = 1;

disp('Parsing all lines of text file...');

while 1
  tline = fgetl(fid);
	
  if tline == -1, break; end
	  
  field_values = parse_line_text(tline, delimiter);
	
	if length(field_values) > num_fields
		disp(sprintf('Line %d: found %d fields but was expecting %d fields - maybe this is a header line to be skipped? (set optional argument)', ...
									struct_idx, length(field_values), num_fields));
		return;
	end
	
  for f=1:length(field_values)
    Text_Struct(struct_idx).(field_names{f}) = deblank(field_values{f});
  end
  
  struct_idx = struct_idx + 1;
end

% Close file pointer
fclose(fid);
