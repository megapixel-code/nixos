-- :h lspconfig-all

return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "L3MON4D3/LuaSnip",
      },

      config = function()
         local capabilities = require( "cmp_nvim_lsp" ).default_capabilities();

         capabilities.textDocument.foldingRange = {
            -- for folding plugin
            dynamicRegistration = false,
            lineFoldingOnly = true,
         };

         M = {
            { -- Lua lsp
               name = "lua_ls",
               args = {
                  capabilities = capabilities,
               },
            },
            { -- Python lsp
               name = "pyrefly",
               args = {
                  capabilities = capabilities,
                  settings = {
                     python = {
                        pyrefly = {
                           displayTypeErrors = "force-on",
                        },
                     },
                  },
               },
            },
            { -- C, Cpp, ... lsp
               name = "clangd",
               args = {
                  capabilities = capabilities,
               },
            },
            { -- Bash, Zsh lsp
               name = "bashls",
               args = {
                  capabilities = capabilities,
                  filetypes = { "bash", "sh", "zsh" },
               },
            },
            { -- Json, Jsonc lsp
               name = "jsonls",
               args = {
                  capabilities = capabilities,
               },
            },
            { -- yaml lsp
               name = "yamlls",
               args = {
                  capabilities = capabilities,
               },
            },
            { -- CSS lsp
               name = "cssls",
               args = {
                  capabilities = capabilities,
               },
            },
            { -- Html lsp
               name = "superhtml",
               args = {
                  capabilities = capabilities,
               },
            },
            { -- Typst lsp
               name = "tinymist",
               args = {
                  capabilities = capabilities,
                  settings = {
                     formatterMode = "typstyle",
                     exportPdf = "onType",
                     outputPath = vim.fn.stdpath( "cache" ) .. "lsp/typst_preview",
                  },
               },
            },
            { -- Nix lsp
               name = "nil_ls",
               args = {
                  capabilities = capabilities,
               },
            },
            { -- Nix lsp
               name = "nixd",
               args = {
                  capabilities = capabilities,
               },
            },
            { -- Scala lsp
               name = "metals",
               args = {
                  capabilities = capabilities,
               },
            },
            {                  -- QML lsp
               name = "qmlls", -- TODO: cant find ?
               args = {
                  capabilities = capabilities,
               },
            },
            {
               name = "neocmake",
               args = {
                  capabilities = capabilities,
               },
            },
            {
               name = "tombi",
               args = {
                  capabilities = capabilities,
               },
            },
         };

         for _, server in ipairs( M ) do
            vim.lsp.config( server.name, server.args );
            vim.lsp.enable( server.name );
         end;
      end,
   },
};
