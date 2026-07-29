-- this file is run after everything

local virtual_lines_state = false;
vim.diagnostic.config( {
   signs = false,
   virtual_text = true,
} );

local function enable_diagnostics_virtual_lines()
   vim.diagnostic.config( {
      virtual_lines = {
         severity = vim.diagnostic.severity.ERROR,
      },
   } );
end;
local function disable_diagnostics_virtual_lines()
   vim.diagnostic.config( {
      virtual_lines = false,
   } );
end;

local function toggle_diagnostics_virtual_lines()
   virtual_lines_state = not virtual_lines_state;
   if (virtual_lines_state) then
      enable_diagnostics_virtual_lines();
   else
      disable_diagnostics_virtual_lines();
   end;
end;

vim.api.nvim_create_user_command( "ToggleDiagnosticsVirtualLines", toggle_diagnostics_virtual_lines, {} );
if (virtual_lines_state) then
   enable_diagnostics_virtual_lines();
else
   disable_diagnostics_virtual_lines();
end;

-- filetypes
local extensionless_file = "[ ---/-Ͽ]*";
vim.filetype.add( {
   pattern = {
      [extensionless_file] = "bash",
   },
} );
