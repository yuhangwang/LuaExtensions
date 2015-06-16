#!/Scr/scr-test-steven/local/bin/lua
-----------------------------------------
----  Tidy Up the NAMD run directory ----
-----------------------------------------
---- Author: Yuhang Wang ----------------
----
---- Date: 06/12/2015 -------------------
----
---- Update: 
----   06/16/2015 ~ clean up & redesign 
----
---- Usage: Tidy.lua STAGE --------------
---- Example: "Tidy.lua 1" --------------
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
-- Routines
-----------------------------------------
function mkdir_and_amend_dict(dir_target, list_file_extensions, dict_ext_and_directory, Sys_M_) 
	-- GOAL:
	-- 	1. make a new directory
	-- 	2. add a new entry to the dictionary for each item in the 'list_file_extensions'
	--
	-- INPUT:
	-- 	dir_target: target directory
	-- 	list_file_extensions: list of file extensions
	--	dict_ext_and_directory: the target dictionary to be modified
	--	Sys_M_: a proxy for the module that has method ".mkdir()"
	--
	-- USAGE:	
	-- 	mkdir_and_amend_dict(dir_target, list_file_extensions, dict_ext_and_directory, Sys_M_)
	--
	Sys_M_.mkdir(dir_target)
	for i, file_extension in pairs(list_file_extensions) do
		dict_ext_and_directory[file_extension] = dir_target
	end

end


-----------------------------------------
-- Make a global list of lists
-----------------------------------------
local list_all_dir_target = {}
local list_all_file_extensions = {}


-----------------------------------------
-- 1. Restart files
-----------------------------------------
table.insert(list_all_dir_target, Path_M_.join({"..", "restart", "md" .. stage}))
table.insert(list_all_file_extensions, {"coor", "vel", "xsc", "xst"})
-----------------------------------------


-----------------------------------------
-- 2. DCD files
-----------------------------------------
table.insert(list_all_dir_target, Path_M_.join({"..", "dcds", "all"}))
table.insert(list_all_file_extensions, {"dcd"})

-----------------------------------------
-- 3. Log files
-----------------------------------------
table.insert(list_all_dir_target, Path_M_.join({"..", "logs", "md" .. stage}))
table.insert(list_all_file_extensions, {"log"})

-----------------------------------------
-- 4. Submission files
-----------------------------------------
table.insert(list_all_dir_target, Path_M_.join({"..", "submit"}))
table.insert(list_all_file_extensions, {"submit"})

-----------------------------------------
-- 5. NAMD configuration files
-----------------------------------------
table.insert(list_all_dir_target, Path_M_.join({"..", "config"}))
table.insert(list_all_file_extensions, {"conf"})


-----------------------------------------------------
-- Make directories and amend the global dict
-----------------------------------------------------
for i = 1, #list_all_dir_target do
	local dir_target = list_all_dir_target[i]
	local list_file_extensions = list_all_file_extensions[i]
	mkdir_and_amend_dict(dir_target, list_file_extensions, dict_ext_and_directory, Sys_M_)
end

-----------------------------------------------------
-----------------------  Main -----------------------
-----------------------------------------------------
print("-----------------------------------------------")
for key,value in pairs(dict_ext_and_directory) do
	print(key, value)
end
print("-----------------------------------------------")


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