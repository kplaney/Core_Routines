
function updated_msgs = update_messages_array(current_msgs, new_msgs)

updated_msgs = current_msgs;

if isempty(new_msgs)
	return;
end

if ~iscellstr(new_msgs)
	if isstr(new_msgs)
		new_msgs = {new_msgs};
	else
		disp(sprintf('%s: unrecognised data type for new_msgs variable - should be string or cellstr', mfilename));
		return;
	end
end

for n=1:length(new_msgs)
	if isempty(updated_msgs)
		updated_msgs{1} = new_msgs{n};
	else
		if isstr(new_msgs{n})
			updated_msgs{length(updated_msgs)+1} = new_msgs{n};
		else
			disp(sprintf('%s: unrecognised data type in new_msgs cell array - should be cell array of strings', mfilename));
		end
	end
end
