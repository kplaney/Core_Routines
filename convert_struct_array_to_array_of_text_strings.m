
function text_lines = convert_struct_array_to_array_of_text_strings(Struct_Array, varargin)

if length(varargin)
  column_headings = varargin{1};
else
  column_headings = fieldnames(Struct_Array);
end

num_records = length(Struct_Array);
text_lines = cell(1,num_records+1);

struct_fields = fieldnames(Struct_Array);
num_fields = length(struct_fields);
field_width = zeros(1,num_fields);

for f=1:num_fields
  values = [column_headings{f} {Struct_Array.(struct_fields{f})}];
  widths = cellfun(@(x) length(x), values);
  field_width(f) = max(widths);
end

for f=1:num_fields
  text_lines{1} = sprintf('%s%-*s  ', text_lines{1}, field_width(f), column_headings{f});
end

for n=1:num_records
  for f=1:num_fields
    text_lines{n+1} = sprintf('%s%-*s  ', text_lines{n+1}, field_width(f), Struct_Array(n).(struct_fields{f}));
  end
end
