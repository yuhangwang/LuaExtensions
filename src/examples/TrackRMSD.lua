#!/Scr/scr-test-steven/local/bin/lua
----------------------------------------------------------
-- Calculate the RMSD for multiple trajectories from MD
----------------------------------------------------------
-- Author: Yuhang Wang -----------------------------------
-- Date: 06/12/2015 --------------------------------------
----------------------------------------------------------
local Switch_M_ = require("switch_module")
local Path_M_ = require("path_module")
local Sys_M_ = require("lfs")

proj_code_name = "dojf2"
protein_code = "4doj"

step = tonumber(arg[1])
cwd = Sys_M_.currentdir()
vmde = "vmd -dispdev text -e"

dir_dcd_root  = Path_M_.join({"..", "..", "dcds"})
dir_data_root = Path_M_.join({"..", "..", "data"})

function write_str_to_file (str, output_file_name)
	-- Write a string into an output file
	local OUT = io.open(output_file_name, 'w')
	io.output(OUT)
	io.write(str)
	io.close(OUT)
end

a = Switch_M_.switch {
	[1] = function () 
		-- Split a pdb file by segment
		stage_one = 26
		stage_end = 30

		local dir_input_root = Path_M_.join({dir_dcd_root, "no_water"})
		local prefix = table.concat({"noWater_full", protein_code})
		local file_psf = table.concat({prefix, ".psf"})
		local file_pdb = table.concat({prefix, ".pdb"})
		local prefix_dcd = table.concat({prefix, "_md"})
		in_pdb = Path_M_.join({dir_input_root, file_pdb})
		in_psf = Path_M_.join({dir_input_root, file_psf})
		in_dcd_prefix = Path_M_.join({dir_input_root, prefix_dcd})
		
		dir_output = Path_M_.join({dir_data_root, "rmsd_all"})
		name_file_prefix_rmsd = table.concat({proj_code_name, "_rmsd-all_md"})
		out_name_file_prefix_rmsd = Path_M_.join({dir_output, name_file_prefix_rmsd})
		str_for_align = "(protein and resid 61 to 547) and not (resname BET CHOL)"
		str_for_rmsd = "(protein) and (not (resname BET CHOL))"
		---------------------------------------------------------------------------
		-- write selection string to a file
		-- so that the tcl scripts can use it
		-- note: I could have passed a string (with spaces), but Tcl is not smart
		-- enough to parse it correctly. I got an error "argv: Subscript out of range."	
		---------------------------------------------------------------------------
		file_str_for_align = Path_M_.join({cwd, "str_selection_for_align.txt"})
		write_str_to_file(str_for_align, file_str_for_align)

		file_str_for_rmsd = Path_M_.join({cwd, "str_selection_for_rmsd.txt"})
		write_str_to_file(str_for_rmsd, file_str_for_rmsd)

		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		-- make a new directory for the output data files --
		---------------------------------------------------------------------------
		cmd = table.concat({"mkdir -p ", dir_output})
		os.execute(cmd)
		---------------------------------------------------------------------------
		
		in_script = Path_M_.join({cwd, "get_rmsd.tcl"})
		cmd = table.concat({vmde, in_script, "-args", in_psf, in_pdb, in_dcd_prefix,
			stage_one, stage_end, out_name_file_prefix_rmsd, file_str_for_align, file_str_for_rmsd}, " ")

		print(cmd)
		os.execute(cmd)
  	end,
	default = function (x) print("Please make a choice, i.e. 1, 2, ...") end,
}

---------------------------------------------------------
--   MAIN --
---------------------------------------------------------
a:case(step)  -- ie. call case 2 

