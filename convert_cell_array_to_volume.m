
function volume_data = convert_cell_array_to_volume(cell_array)

num_slices = length(cell_array);
[num_rows, num_cols] = size(cell_array{1});

volume_data = nan(num_rows, num_cols, num_slices);

for slice=1:num_slices
	[rows, cols] = size(cell_array{slice});
	
	if num_rows == rows && num_cols == cols
		x = cell_array{slice};
		slice_voxel_idx = find(x);
		
		if ~isempty(slice_voxel_idx)
			slice_image = nan(num_rows, num_cols);
			slice_image(slice_voxel_idx) = x(slice_voxel_idx);
			volume_data(:,:,slice) = slice_image;
		end
	else
		disp(sprintf('%s: all elements on the cell array should have the same size...', mfilename));
		volume_data = [];
		return;
	end
end
