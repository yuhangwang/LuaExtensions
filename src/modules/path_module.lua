--------------------------------------------
-- Concatenate strings by '/'
--------------------------------------------
-- Author: Yuhang Wang ---------------------
-- Date: 06/12/2015 ------------------------
--------------------------------------------

local M = {}

function M.join(list_of_dirs)
  ------------------------------------------
  -- Concatenate dir|file-name into a Unix 
  ------------------------------------------
  return table.concat(list_of_dirs, '/')
end

return M
