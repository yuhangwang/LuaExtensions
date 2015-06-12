#!/Scr/scr-test-steven/local/bin/lua
-----------------------------------------
----  Tidy Up the NAMD run directory ----
-----------------------------------------
---- Author: Yuhang Wang ----------------
---- Date: 06/12/2015 -------------------
---- Usage: tidy.lua [stage, e.g. 1]
-----------------------------------------


-----------------------------------------
-- Load external modules
-----------------------------------------
local Path_M_ = require("path_module")
local Posix_M_ = require("posix")
local File_M_ = require("file_module")
local Sys_M_ = require("lfs")
local TableUtils_M_ = require("tableUtils_module")
-----------------------------------------

-----------------------------------------
-- Check-point: user must specify 1 argument
-----------------------------------------
if #arg ~= 1 then
	local msg = "PLEASE SPECIFY YOUR MD STAGE\n"
	msg = msg .. "USAGE: tidy.lua stage_number\n"
	msg = msg .. "EXAMPLE: tidy.lua 1"
	print(msg)
	os.exit()
end

-----------------------------------------
-- Read command line arguments
-----------------------------------------
local stage = arg[1]
-----------------------------------------

-----------------------------------------
-- Store all file types and its destination directory
-----------------------------------------
local dict_ext_and_directory = {} -- crate a table

-----------------------------------------
-- Restart files
-----------------------------------------
local dir_target = Path_M_.join({"..", "restart", "md" .. stage})

-- make a new directory
cmd = table.concat({"mkdir -p ", dir_target})
os.execute(cmd)

-- move
local list_ext = {"coor", "vel", "xsc", "xst"}
for i, pattern in pairs(list_ext) do
	dict_ext_and_directory[pattern] = dir_target
end
-----------------------------------------


-----------------------------------------
-- Log files
-----------------------------------------
local dir_target = Path_M_.join({"..", "logs", "md" .. stage})

-- make a new directory
cmd = table.concat({"mkdir -p ", dir_target})
os.execute(cmd)

-- move
local list_ext = {"log"}
for i, pattern in pairs(list_ext) do
	dict_ext_and_directory[pattern] = dir_target
end



for k,v in pairs(dict_ext_and_directory) do
	print(k, v)
end


local list_files = File_M_.ls(".")
for i, file_name in pairs(list_files) do
	local ext = File_M_.get_file_ext(file_name)
	local dir_destination = dict_ext_and_directory[ext]
	if dir_destination ~= nil then
		local cmd = table.concat({"mv", file_name, dir_destination}, " ")
		print(cmd)
		os.execute(cmd)
	end
end