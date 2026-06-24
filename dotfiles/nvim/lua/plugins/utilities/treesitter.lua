return {
   {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",

      init = function()
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

            "json",
            "yaml",
            "qmljs",

            "cmake",
            "typst",
            "markdown",
            "markdown_inline",
            "gitcommit",
            "editorconfig",
            "query",
            "vimdoc",
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
