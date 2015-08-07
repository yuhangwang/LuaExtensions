--------------------------------------------
-- Concatenate strings by '/'
--------------------------------------------
-- Author: Yuhang Wang ---------------------
-- Date: 06/12/2015 ------------------------
-- Update: 07/27/2015 ----------------------
--------------------------------------------
local FileSystemM = require("lfs")
--------------------------------------------

local M = {}

function M.join(list_of_dirs)
  ------------------------------------------
  -- Concatenate dir|file-name into a Unix 
  ------------------------------------------
  return table.concat(list_of_dirs, '/')
end

function M.mkdir(new_dir)
	-- Make a new directory
	local cmd = string.format("mkdir -p %s", new_dir)
	os.execute(cmd)
end

function M.current_directory()
	-- return the current directory path
	return FileSystemM.currentdir()
end

return M
