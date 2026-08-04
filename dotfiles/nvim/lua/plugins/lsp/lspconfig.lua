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
            { -- QML lsp
               name = "qmlls",
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
            { -- pascal lsp
               name = "pasls",
               args = {
                  capabilities = capabilities,
                  cmd = { "/nix/store/sks1v724wv0vn7n9way2axc0qkcwrr2r-pascal-language-server-01-02-2026/bin/pasls" },
                  filetypes = { "pascal" },
                  root_dir = function( bufnr, on_dir )
                     local fname = vim.api.nvim_buf_get_name( bufnr );
                     on_dir( require( "lspconfig" ).util.root_pattern( "*.lpi", "*.lpk", ".git", "Makefile.fpc" )( fname ) );
                  end,

                  init_options = {
                     -- Path to the main program file for resolving references (if not available the path of the current document will be used)
                     -- program = "/run/media/username/F88ECC0B8ECBC07C/pascal/fpc/bin/x86_64-linux/fpc",

                     -- Compiler flags to specify paths, macros, etc.
                     -- Example: {"-Fu/path/to/units", "-Fi/path/to/includes", "-dMY_MACRO"}
                     fpcOptions = {
                        "-Fu$(root)/units",
                        "-Fi$(root)/src",
                        -- "-n @/run/media/username/F88ECC0B8ECBC07C/pascal/fpc/bin/x86_64-linux/fpc.cfg",
                     },

                     -- Maximum number of completions returned per query
                     maximumCompletions = 100,

                     -- Path to symbols database file for faster symbol queries
                     -- Example: "$(tmpdir)/pasls-symbols.db" or "/path/to/symbols.db"
                     symbolDatabase = "$(tmpdir)/symbols.db",

                     -- Preferred method to handle overloaded functions in document symbol requests
                     -- 1: Duplicate function names appear in the list
                     -- 2: After the original definition ignore others
                     -- 3: Add a suffix which denotes the overload count
                     overloadPolicy = 3,

                     -- Insert procedure completions with parameters as snippets
                     insertCompletionsAsSnippets = true,

                     -- Insert empty brackets for procedure completions
                     insertCompletionProcedureBrackets = true,

                     -- Add workspace folders to unit paths (-Fu)
                     includeWorkspaceFolderAsUnitPaths = true,

                     -- Add workspace folders to include paths (-Fi)
                     includeWorkspaceFolderAsIncludePaths = true,

                     -- Workspace folder paths to exclude from workspace path collection
                     -- Example: {"/path/to/workspace/node_modules", "/path/to/workspace/vendor"}
                     excludeWorkspaceFolders = {},

                     -- Check syntax when file opens or saves
                     checkSyntax = true,

                     -- Mark inactive regions based on conditional compilation directives
                     checkInactiveRegions = true,

                     -- Publish syntax errors as diagnostics
                     publishDiagnostics = true,

                     -- Enable workspace symbols
                     workspaceSymbols = true,

                     -- Enable document symbols
                     documentSymbols = true,

                     -- Completions contain minimal extra information
                     minimalisticCompletions = true,

                     -- Show syntax errors in UI with window/showMessage
                     showSyntaxErrors = true,

                     -- Config file or directory to read settings from
                     config = "$(root)/jcfsettings.cfg",
                  },
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
