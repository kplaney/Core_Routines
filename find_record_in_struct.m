
function idx = find_record_in_struct(data_struct, search_field, search_val, varargin)

idx = [];

if length(varargin)
  search_mode = varargin{1};
else
  search_mode = 'exact';
end

field_names = fieldnames(data_struct);
field_idx = strmatch(search_field, field_names);

if isempty(field_idx)
  disp(sprintf('Field name: %s not present in structure', search_field));
  return;
end

if ischar(search_val)
  eval(sprintf('field_values = {data_struct.%s};', search_field));
  
  switch search_mode
   case 'exact'
    idx = strmatch(search_val, field_values, 'exact');
   case 'approx'
    idx = find(cellfun(@(x) ~isempty(strfind(x, search_val)), field_values));
   otherwise
    disp(sprintf('Unknown search mode: %s', search_mode));
  end
else
  eval(sprintf('field_values = [data_struct.%s];', search_field));
  idx = find(search_val == field_values);
end
