--------------------------------------------
-- Group files by their extension 
--------------------------------------------
-- Author: Yuhang Wang ---------------------
-- Date: 06/12/2015 ------------------------
-- Require: "Lua File System | lfs"
--------------------------------------------
local M = {}

local Sys_M_ = require("lfs")


function M.read_file_to_list(file_name)
	-- read an input file and return a list of the content
	local list_output = {}
	for line in io.lines(file_name) do
		table.insert(list_output, line)
	end
	return list_output
end

function M.ls(dir) 
	-- Get a list of file names at dir --
	local list_file_names = {}
	for file_name in Sys_M_.dir(dir) do
		if (file_name ~= ".") and (file_name ~= "..") then
			table.insert(list_file_names, file_name)
		end
	end
	return list_file_names
end

function M.copy(file_source, new_dir)
	-- copy file
	local cmd = string.format("cp %s %s", file_source, new_dir)
	os.execute(cmd)
end

function M.write_str_to_file (output_file_name, str, mode)
	-- Write a string into an output file
	local mode = mode or 'w'
	local OUT = io.open(output_file_name, mode)
	io.output(OUT)
	io.write(str)
	io.close(OUT)
end


function M.get_file_ext(file_name)
	-- Get file extension name --
	return string.match(file_name, ".-%.?([^%.\\/]*)$")
end

function M.get_file_content(file_name)
	local IN = io.open(file_name, 'r')
	io.input(IN)
	local content = io.read("*all")
	io.close(IN)
	return content
end

function M.group_files_by_ext(list_file_names) 
	-- Group files by extension name --
	-- return: dict (key: extension, value: file names)
	local dict_files_grouped = {}
	for i, file_name in pairs(list_file_names) do
		local ext = M.get_file_ext(file_name)
		dict_files_grouped[ext] = file_name
	end
	return dict_files_grouped
end

function M.concat(list_file_names, output_file_name, skip_number_of_lines)
	-- Concatenate files
	local number_skip = skip_number_of_lines or 0
	local OUT = io.open(output_file_name, "w")
	io.output(OUT)
	local list_lines = {}
	for i, file_name in pairs(list_file_names) do
		local ccc = 0
		for line in io.lines(file_name) do
			ccc = ccc + 1
			if ccc > number_skip then
				table.insert(list_lines, line)
			end
		end
	end
	local text_body = table.concat(list_lines, '\n')
	io.write(text_body)
	io.close(OUT)
end

function M.insert_id_column(file_input, file_output, scaling_factor)
	local id_scaling_factor = scaling_factor or 1
	local OUT = io.open(file_output, 'w')
	io.output(OUT)
	local ccc = 0 -- counter
	for line in io.lines(file_input) do
		local id = ccc * id_scaling_factor
		io.write(string.format("%s %s\n", id, line))
		ccc = ccc + 1
	end
	io.close(OUT)
end

function M.insert_id_column_before(file_input, file_output, scaling_factor)
	M.insert_id_column(file_input, file_output, scaling_factor)
end

return M
