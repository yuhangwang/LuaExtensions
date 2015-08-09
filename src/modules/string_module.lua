---------------------------------------------------
-- Additional String Manipulation Tools
-- AUTHOR: YUHANG WANG
-- DATE: 08/07/2015
---------------------------------------------------
local M = {}

function M.split(input_string, delimiter)
	-- Split a string by "delimiter"
	local delimiter = delimiter or "%s+"
	local list_output = {}
	local regex_delimiter = string.format("([^%s]+)", delimiter)
	for item in string.gmatch(input_string, regex_delimiter) do
		table.insert(list_output, item)
	end
	return list_output
end

function M.trim(input_string)
	-- remove leading & trailing spaces
	return string.gsub(input_string, "^%s*(.-)%s*$", "%1")
end

function M.to_number(input_string)
	-- Convert a string to a number or a list of numbers
	-- Return the original string if it cannot be converted to numbers
	if string.find(input_string, "%s") then
		local list_output = M.split(input_string)
		for i, item in pairs(list_output) do
			local original_string = list_output[i]
			list_output[i] = tonumber(original_string)
			if list_output[i] == nil then 
				list_output[i] =  original_string
			end
		end
		return list_output
	else
		local output = tonumber(input_string)
		if output == nil then
			return input_string
		else
			return output
		end
	end
end

return M