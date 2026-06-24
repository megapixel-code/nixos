-- ~~~ [[ Autocommands ]] ~~~

-- [[ highlight when yanking text ]]
vim.api.nvim_create_autocmd( "TextYankPost", {
   desc = "Highlight when yanking text",
   group = vim.api.nvim_create_augroup( "kickstart-highlight-yank", { clear = true } ),
   callback = function()
      vim.hl.on_yank();
   end,
} );


-- [[ Auto-format ("lint") on save ]]
vim.api.nvim_create_autocmd( "BufWritePre", {
   group = vim.api.nvim_create_augroup( "formatting", { clear = false } ),
   pattern = "*",
   callback = function( args )
      require( "conform" ).format( {
         bufnr = args.buf,
         timeout_ms = 1000,
         lsp_format = "fallback",
         formatting_options = {
            tabSize = 3,
         },
      } );
   end,
} );


-- [[ options when opening a terminal ]]
vim.api.nvim_create_autocmd( "TermOpen", {
   group = vim.api.nvim_create_augroup( "term-open", { clear = true } ),
   callback = function()
      vim.api.nvim_buf_set_keymap( 0, "t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" } );
      vim.opt.number = false;
      vim.opt.relativenumber = false;
   end,
} );


-- [[ keep folding and cursor pos on nvim quit ]]
local fold_augroup           = vim.api.nvim_create_augroup( "config.folds", { clear = true } );
vim.opt.viewoptions          = { "folds", "cursor" };
vim.g.ignored_view_filetypes = {};

vim.api.nvim_create_autocmd( "BufWinLeave", {
   group = fold_augroup,
   pattern = "?*",
   desc = "Save view",
   callback = function( args )
      local buftype = vim.api.nvim_get_option_value( "buftype", { buf = args.buf } );
      local filetype = vim.api.nvim_get_option_value( "filetype", { buf = args.buf } );
      if buftype == "" and filetype ~= ""                                        -- check if real file buffer
         and not string.match( vim.api.nvim_buf_get_name( args.buf ), "^/tmp" )  -- check if not a temp file
         and not vim.tbl_contains( vim.g.ignored_view_filetypes, filetype ) then -- check if not explicitly excluded
         vim.cmd.mkview( { mods = { emsg_silent = true } } );
      end;
   end,
} );

vim.api.nvim_create_autocmd( "BufWinEnter", {
   group = fold_augroup,
   pattern = "?*",
   desc = "Restore view",
   command = "silent! loadview",
} );


-- [[ notification when no treesitter parser for buffer ]]
local treesitter_parsers = require( "nvim-treesitter" ).get_installed();
vim.api.nvim_create_autocmd( "BufEnter", {
   desc = "notification with fidget when no parser for filetype",
   callback = function()
      local ft = vim.bo.filetype;
      if (ft == "") then
         return;
      end;

      local parser_filetypes;
      for _, parser in ipairs( treesitter_parsers ) do
         parser_filetypes = vim.treesitter.language.get_filetypes( parser );
         for _, parser_filetype in ipairs( parser_filetypes ) do
            if (parser_filetype == ft) then
               return;
            end;
         end;
      end;

      require( "fidget" ).notify( "no parser for " .. ft, nil, nil );
   end,
} );

-- [[ resize splits when window size changes ]]
vim.api.nvim_create_autocmd( "VimResized", {
   command = "wincmd =",
} );


-- [[ treesitter syntax highlighting on config files ]]
vim.api.nvim_create_autocmd( "BufRead", {
   pattern = { ".env", ".env.*", "*.conf" },
   callback = function()
      vim.bo.filetype = "dosini";
   end,
} );


-- [[ document-higligting ]]
local hover_highlight_group = vim.api.nvim_create_augroup( "hover-highlight", { clear = false } );
local no_highlight_table = { "json", "jsonc", "cmake", "yaml", "toml" };

vim.api.nvim_create_autocmd( { "CursorHold", "CursorHoldI" }, {
   group = hover_highlight_group,
   callback = function()
      for _, no_highlight_ft in pairs( no_highlight_table ) do
         if vim.bo.filetype == no_highlight_ft then
            return;
         end;
      end;
      vim.lsp.buf.document_highlight();
   end,
} );

vim.api.nvim_create_autocmd( { "CursorMoved", "CursorMovedI" }, {
   group = hover_highlight_group,
   callback = function()
      for _, no_highlight_ft in pairs( no_highlight_table ) do
         if vim.bo.filetype == no_highlight_ft then
            return;
         end;
      end;
      vim.lsp.buf.clear_references();
   end,
} );


-- [[ help menu ]]
vim.api.nvim_create_autocmd( "FileType", {
   pattern = "help",
   callback = function()
      local editor_columns = vim.api.nvim_get_option_value( "columns", {} );
      if editor_columns > 125 then
         vim.cmd( "wincmd L" );
      else
         vim.cmd( "wincmd J" );
      end;
   end,
} );
