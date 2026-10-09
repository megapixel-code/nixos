-- filetypes
local extensionless_file = "[ ---/-Ͽ]*";
vim.filetype.add( {
   filename = {
      ["Makefile"] = "make",
      [".env"] = "dosini",
   },
   pattern = {
      [extensionless_file] = "bash",
      [".env.*"] = "dosini",
      ["*.conf"] = "dosini",
   },
} );
