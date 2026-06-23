return {
   {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",

      init = function()
         -- TODO: notification with figlet when no parser for filetype
         local ensure_installed = {
            "c",
            "bash",

            "cpp",
            "python",
            "java",
            "lua",
            "pascal",

            "scala",
            "nix",

            "html",
            "css",
            "javascript",

            "cmake",
            "yaml",
            "typst",
            "markdown",
            "markdown_inline",
            "gitcommit",
            "editorconfig",
            "query",
            "qmljs",
         };
         require( "nvim-treesitter" ).install( ensure_installed );

         vim.api.nvim_create_autocmd( "FileType", {
            pattern = ensure_installed,
            callback = function()
               vim.treesitter.start();
               vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()";
            end,
         } );
      end,

      opts = {
         install_dir = vim.fn.stdpath( "data" ) .. "/treesitter",
      },
   },
};
