--------------------------------------------
-- Switch construct for Lua
--------------------------------------------
-- Author: Yuhang Wang ---------------------
-- Date: 06/12/2015 ------------------------
-- Reference: 
-- http://lua-users.org/wiki/SwitchStatement
--------------------------------------------
local M = {}

function M.switch(table_of_functions)
  table_of_functions.case = function (self,x)
    local f=self[x] or self.default
    if f then
      if type(f)=="function" then
        f(x,self)
      else
        error("case "..tostring(x).." is not a function")
      end
    end
  end
  return table_of_functions
end

return M
