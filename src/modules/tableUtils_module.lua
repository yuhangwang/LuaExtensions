--------------------------------------------
-- Utility functions for lua table
--------------------------------------------
-- Author: Yuhang Wang ---------------------
-- Date: 06/12/2015 ------------------------
-- Require: "Lua File System | lfs"
--------------------------------------------
local M = {}

function M.table_keys(my_table)
	local list_keys = {}
	for k,v in pairs(my_table) do
		table.insert(list_keys, k)
	end
	return list_keys
end

return M
