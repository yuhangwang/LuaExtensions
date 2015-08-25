---------------------------------------------------
-- MPA Toolkit module
---------------------------------------------------
-- AUTHOR: YUHANG WANG 
-- DATE: 06/26/2015 

local M = {}

function M.get_marker_symbol_dict()
  return {
    symbol_scope_separator = "===",
    symbol_inline_comment =  "--",
    symbol_section_separator =  "--------------------------------------------------",
    symbol_system_path_separtor = '/',
    symbol_intersection_gap = "\n\n\n",
  }
end

function M.split(string, separator)
  if separator == nil then separator = "%s" end
  local list_result = {}
  local pattern = string.format("([^%s]+)", separator)
  for item in string.gmatch(string, pattern) do 
    table.insert(list_result, item)
  end
  return list_result
end

function M.list_last_item(list)
  -- return the last item of a list 
  return list[#list]
end

function M.sort_dict_keys(dict_target)
  -- get sorted dictionary keys
  local list_keys = {}
  for key, value in pairs(dict_target)  do
    table.insert(list_keys, key)
  end
  table.sort(list_keys)
  return list_keys
end

function M.write_str_to_file (file_output, str, write_mode)
	-- Write a string into an output file
  local mode = write_mode or 'w'
	local OUT = io.open(file_output, mode)
	io.output(OUT)
	io.write(str)
	io.close(OUT)
end

function M.write_section_header(file_output, section_title, symbol_section_separator, write_mode)
  local mode = write_mode or 'w'
  local msg = string.format("%s\n\t\t   %s\n%s\n", symbol_section_separator, section_title, symbol_section_separator)
  M.write_str_to_file(file_output, msg, mode)
end

function M.write_intersection_gap(file_output, symbol_intersection_gap, write_mode)
  local mode = write_mode or 'w'
  M.write_str_to_file(file_output, symbol_intersection_gap, mode)
end

function M.write_dict2d_to_file(file_output, dict_target, write_mode, symbol_scope_separator, symbol_inline_comment)
  -- Write the content of a 2D dictionary to an output file 
  -- Parameters:
  --  file_output: output file name
  --  dict_target: target dictionary 
  --  write_mode: 'w' or 'a'
  local OUT = io.open(file_output, write_mode)
  io.output(OUT)
  local list_lines = {}
  local sorted_keys_level_1 = M.sort_dict_keys(dict_target)
  for i, key_level_1 in pairs(sorted_keys_level_1) do
    local section_comment = string.format("%s[%s]%s", symbol_inline_comment, key_level_1, symbol_inline_comment)
    table.insert(list_lines, section_comment)
    
    local dict_level_2 = dict_target[key_level_1]
    
    -- get sorted keys
    local sorted_keys_level_2 = M.sort_dict_keys(dict_level_2)
    for i, key_level_2 in pairs(sorted_keys_level_2) do
      local value_level_2 = dict_level_2[key_level_2]
      local line = string.format("%s:: %s", key_level_2, value_level_2)
      table.insert(list_lines, line)
    end
    
    table.insert(list_lines, symbol_scope_separator) -- add scope separator 
  end

  local text_body = table.concat(list_lines, '\n')
  io.write(text_body)
  io.close(OUT)
end

function M.safely_amend_dict(dict_target, key, value)
  -- Safely amend a target dictionary
  -- Only add new entries when key and value are not nil
  if key == nil then return end 
  if value == nil then return end
  dict_target[key] = value
end

function  M.add_parameters(dict_target, global_key, dict_specs)
  -- Add more file parameters 
  if dict_target[global_key] == nil then dict_target[global_key] = {} end 
  for key, value in pairs(dict_specs) do
    M.safely_amend_dict(dict_target[global_key], key, value)
  end
end



return M