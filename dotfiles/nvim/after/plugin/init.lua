-- this file is run after everything
-- vim.diagnostic.config( {
--    signs = false,
-- } );

-- filetypes
local extensionless_file = "[ ---/-Ͽ]*";
vim.filetype.add( {
   filename = {
      ["Makefile"] = "make",
   },
   pattern = {
      [extensionless_file] = "bash",
   },
} );
