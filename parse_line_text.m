
function text_fields = parse_line_text(text_line, delimiter)

start_idx = [1 regexp(text_line, delimiter)+1];
end_idx = [regexp(text_line, delimiter)-1 length(text_line)];

text_fields = [];

for j=1:length(start_idx)
  if start_idx(j) <= end_idx(j)
    text_fields{j} = text_line(start_idx(j):end_idx(j));
  end
end
