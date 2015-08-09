-----------------------------------
-- Test string_module::to_number
-- AUTHOR: YUHANG WANG
-- DATE: 08/07/2015
-----------------------------------


local StringM = require("string_module")

local list_strings = {'1', "1 2 3"}
for i, item in pairs(list_strings) do
	local result = StringM.to_number(item)
	if type(result) == "number" then 
		print(result)
	else
		for j, new_item in pairs(result) do
			print(new_item)
		end
	end
	print()
end