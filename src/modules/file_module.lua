--------------------------------------------
-- Group files by their extension 
--------------------------------------------
-- Author: Yuhang Wang ---------------------
-- Date: 06/12/2015 ------------------------
-- Require: "Lua File System | lfs"
--------------------------------------------
local M = {}

local Sys_M_ = require("lfs")

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


function M.get_file_ext(file_name)
	-- Get file extension name --
	return string.match(file_name, ".-%.?([^%.\\/]*)$")
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

function M.concat(list_file_names, output_file_name)
	-- Concatenate files
	local OUT = io.open(output_file_name, "w")
	io.output(OUT)
	for i, file_name in pairs(list_file_names) do
		local IN = io.open(file_name, 'r')
		io.input(IN)
		local txt_body = io.read("*a")
		io.write(txt_body)
		io.close(IN)
	end
	io.close(OUT)
end

function M.insert_id_column_before(file_input, file_output, scaling_factor)
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

return M
