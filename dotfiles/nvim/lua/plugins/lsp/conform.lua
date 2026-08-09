return {
   "stevearc/conform.nvim",
   opts = {
      formatters_by_ft = {
         sh = { "shfmt" },       -- bash, look in .editorconfig
         bash = { "shfmt" },     -- ^
         zsh = { "shfmt" },      -- ^
         pascal = { "pasfmt" },  -- pascal FIX: add tab_width=3 not working
         css = { "prettierd" },  -- angular, css, flow, graphql, html, json, jsx, javascript, less, markdown, scss, typescript, vue, yaml
         typst = { "typstyle" }, -- typst
         nix = { "nixfmt" },     -- nix
         make = { "bake" },      -- makefiles
      },

      formatters = {
         shfmt = {
            inherit = true,
            prepend_args = {
               "-i=0",     -- indent_style = tab
               "-ln=bash", -- shell_variant = bash
               "-s",       -- simplify = true
               "-bn",      -- binary_next_line = true
               "-ci",      -- switch_case_indent = true
               "-sr",      -- space_redirects = true
               "-kp",      -- keep_padding = true
            },
         },
         typstyle = {
            inherit = true,
            prepend_args = {
               "--wrap-text",    -- wrap text, not everything on the same line
               "--indent-width", -- set indent-width
               "3",              -- of 3
            },
         },
      },

      notify_on_error = true,
      notify_no_formatters = true,
      -- log_level = vim.log.levels.TRACE,
   },
};
