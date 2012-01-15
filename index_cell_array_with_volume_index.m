
function [data_vec, voxel_subscripts] = index_cell_array_with_volume_index(cell_array, vol_linear_idx, vol_size)

data_vec = []; voxel_subscripts = [];

num_slices = length(cell_array);
[num_rows, num_cols] = size(cell_array{1});

[rows, cols, slices] = ind2sub(vol_size, vol_linear_idx);
unique_slices = unique(slices);

if max(rows) > num_rows || max(cols) > num_cols || max(slices) > num_slices
	disp(sprintf('%s: volume index is not compatible with the dimension of the cell array elements', mfilename));
	return;
end

for k=1:length(unique_slices)
	this_slice = unique_slices(k);
	slice_idx = find(slices==this_slice);
	
	within_slice_linear_idx = sub2ind(vol_size(1:2), rows(slice_idx), cols(slice_idx));
	slice_data_vec = cell_array{this_slice}(within_slice_linear_idx);
	
	if ~isempty(find(slice_data_vec))
		data_vec = [data_vec; full(slice_data_vec)];
	else
		data_vec = [data_vec; nan(length(slice_idx),1)];
	end
	
	voxel_subscripts = [voxel_subscripts; [rows(slice_idx) cols(slice_idx) slices(slice_idx)]];
end
