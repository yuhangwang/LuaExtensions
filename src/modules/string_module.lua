---------------------------------------------------
-- Additional String Manipulation Tools
-- AUTHOR: YUHANG WANG
-- DATE: 08/07/2015
---------------------------------------------------
local M = {}

function M.split(input_string, delimiter)
	-- Split a string by "delimiter"
	local delimiter = delimiter or "%s"
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

function M.convert_dict_to_string(dict_Input, str_KeyValueSeparator)
	-- Convert a dictionary to a big string
	-- All the entries are separated by '\n'
	-- Each entry is converted to a string with key and value 
	--	separated by str_KeyValueSeparator
	local list_Lines = {}
	for key, value in pairs(dict_Input) do
		local line = string.format("%s%s%s", key, str_KeyValueSeparator, value)
		table.insert(list_Lines, line)
	end
	local str_Output = table.concat(list_Lines, '\n')
	return str_Output
end

return M