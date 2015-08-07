---------------------------------------------------
-- Additional String Manipulation Tools
-- AUTHOR: YUHANG WANG
-- DATE: 08/07/2015
---------------------------------------------------

local M = {}

function M.split(input_string, delimiter)
	-- Split a string by "delimiter"
	local delimiter = delimiter or "%S+"
	local list_output = {}
	local regex_delimiter = string.format("([^%s]+)", delimiter)
	print(input_string, regex_delimiter)
	for item in string.gmatch(input_string, regex_delimiter) do
		table.insert(list_output, item)
	end
	return list_output
end


return M