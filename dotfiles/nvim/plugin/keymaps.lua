-- ~~~ [[ Basic Keymaps ]] ~~~

-- [Source file]
vim.keymap.set( "n", "<leader>o", "<cmd>update<CR><cmd>source<CR>", { desc = "Rel[O]ad file" } );


-- [Restart editor]
vim.keymap.set( "n", "<leader>rr", "<cmd>restart<CR>", { desc = "restart the editor" } );


-- [Visual mode]
vim.keymap.set( "v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected down" } );
vim.keymap.set( "v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected up" } );


-- [Toggle settings]
vim.keymap.set( "n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Toggle Spelling" } );
vim.keymap.set( "n", "<leader>tf", function()
                   local current_spelllang = vim.o.spelllang;
                   if current_spelllang == "en_us" then
                      vim.o.spelllang = "fr";
                   else
                      vim.o.spelllang = "en_us";
                   end;
                end, { desc = "Toggle French spelling" } );
vim.keymap.set( "n", "<leader>tv", "<cmd>ToggleDiagnosticsVirtualLines<CR>",
                { desc = "Toggle diagnostics virtual lines" } );


-- [Clear highlights]
vim.keymap.set( "n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clears higlighting of search" } );


-- [lsp]
vim.keymap.set( "n", "K", vim.lsp.buf.hover, { desc = "Hover Information" } );


-- [Quickfix]
vim.keymap.set( "n", "<leader>j", "<cmd>cnext<CR>", { desc = "next element in the quickfix list" } );
vim.keymap.set( "n", "<leader>k", "<cmd>cprev<CR>", { desc = "previous element in the quickfix list" } );


-- ~~~ [[ Plugins Keymaps ]] ~~~

-- [typst/markdown]
-- NOTE: more info :h expand
-- % file path relative to CWD
-- %:p full path from /
-- %:t file name alone (tail)
-- %:h file directory alone (head)
-- %:r file with one less extension
-- %:e file extension
-- %:p:h directory of the file from /
-- %:t:r the file name alone without the extension
vim.keymap.set( "n", "<leader>tc", "", {
   callback = function()
      local ft = vim.o.filetype;
      if ft == "typst" then
         local file_dir = vim.fn.expand( "%:p:h" );
         print( file_dir );
         os.execute( "mkdir -p " .. file_dir .. "/out" );
         vim.cmd( "!typst compile %:p %:p:h/out/%:t:r.pdf" );
      elseif ft == "markdown" then
         -- TODO: look pandoc
      end;
   end,
   desc = "Compile typ or md file",
} );

vim.keymap.set( "n", "<leader>tp", "", {
   callback = function()
      local ft = vim.o.filetype;
      if ft == "typst" then
         vim.cmd( "TypstPreview" );
      elseif ft == "markdown" then
         vim.cmd( "MarkdownPreview" );
      end;
   end,
   desc = "toggle preview",
} );
