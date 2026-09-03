return {
   "hrsh7th/nvim-cmp",
   dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",

      "hrsh7th/cmp-cmdline",
      "petertriho/cmp-git",

      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
   },
   event = { "InsertEnter", "CmdlineEnter" },

   config = function()
      local cmp = require( "cmp" );
      local cmp_autopairs = require( "nvim-autopairs.completion.cmp" );
      local lspkind = require( "lspkind" );

      cmp.setup( {
         expand = function( args )
            vim.snippet.expand( args.body ); -- we set this to luasnip in snippets
         end,
         window = {
            completion = cmp.config.window.bordered( { max_height = 8 } ),
            documentation = cmp.config.window.bordered( { max_height = 8 } ),
         },
         mapping = cmp.mapping.preset.insert( {
            ["<C-u>"] = cmp.mapping.scroll_docs( -4 ),
            ["<C-d>"] = cmp.mapping.scroll_docs( 4 ),
            ["<C-n>"] = cmp.mapping.select_next_item( { behavior = cmp.SelectBehavior.Insert } ),
            ["<C-p>"] = cmp.mapping.select_prev_item( { behavior = cmp.SelectBehavior.Insert } ),
            ["<C-y>"] = cmp.mapping(
               cmp.mapping.confirm( {
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = true,
               } ),
               { "i", "c" }
            ),
         } ),
         sources = cmp.config.sources( {
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
         } ),
         formatting = {
            fields = { "abbr", "icon", "kind", "menu" },
            format = lspkind.cmp_format( {
               with_text = false,
               menu = {
                  nvim_lsp = "[lsp]",
                  buffer = "[buf]",
                  path = "[path]",
                  luasnip = "[snip]",
                  git = "[git]",
               },
            } ),
         },
      } );

      cmp.setup.filetype( "gitcommit", {
         sources = cmp.config.sources( {
            { name = "luasnip", priority = 100 },
            { name = "git" },
            { name = "buffer" },
         } ),
      } );

      cmp.setup.cmdline( { "/", "?" }, {
         mapping = cmp.mapping.preset.cmdline(),
         sources = {
            { name = "buffer" },
         },
      } );

      cmp.setup.cmdline( ":", {
         mapping = cmp.mapping.preset.cmdline(),
         sources = cmp.config.sources( {
            { name = "path" },
            { name = "cmdline" },
         } ),
         --- disable the prompt for some cmds
         enabled = function()
            local disabled_commands = {
               q = true,
               w = true,
               wq = true,
            };
            -- first word of the cmdline
            local cmd = vim.fn.getcmdline():match( "%S+" );

            -- true if cmd not disabled
            -- else call and return cmp.close() which return false
            return not disabled_commands[cmd] or cmp.close();
         end,
         -- matching = { disallow_symbol_nonprefix_matching = false },
      } );

      -- add parentheses after selecting function
      cmp.event:on( "confirm_done", cmp_autopairs.on_confirm_done() );
   end,
};
