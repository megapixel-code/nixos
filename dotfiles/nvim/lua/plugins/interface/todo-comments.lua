return {
   "folke/todo-comments.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },

   init = function()
      local todo_keywords = {
         "FIX",
         "FIXME",
         "BUG",
         "FIXIT",
         "ISSUE",
         "WARN",
         "WARNING",
         "XXX",
         "OPTIMIZE",
         "TODO",
      };
      vim.keymap.set( "n", "<leader>st",
                      "<cmd>TodoTelescope keywords=" .. table.concat( todo_keywords, "," ) .. "<CR>",
                      {
                         desc = "Search TODOS",
                      } );
   end,
   opts = {
      -- FIX : test
      -- FIXME: test
      -- BUG: test
      -- FIXIT: test
      -- ISSUE: test
      -- HACK : test
      -- WARN : test
      -- WARNING: test
      -- XXX: test
      -- PERF : test
      -- OPTIM: test
      -- PERFORMANCE: test
      -- OPTIMIZE: test
      -- TEST : test
      -- TESTING: test
      -- PASSED: test
      -- FAILED: test
      -- NOTE : test
      -- INFO: test
      -- TODO : test
      signs = true,      -- show icons in the signs column
      sign_priority = 0, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
         FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
         HACK = { icon = " ", color = "warning" },
         WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
         PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
         TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
         NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
         TODO = { icon = " ", color = "info" },
      },
      gui_style = {
         fg = "NONE",        -- The gui style to use for the fg highlight group.
         bg = "BOLD",        -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
         multiline = true,                -- enable multine todo comments
         multiline_pattern = "^.",        -- lua pattern to match the next multiline from the start of the matched keyword
         multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
         before = "",                     -- "fg" or "bg" or empty
         keyword = "wide",                -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
         after = "fg",                    -- "fg" or "bg" or empty
         pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
         comments_only = true,            -- uses treesitter to match keywords in comments only
         max_line_len = 400,              -- ignore lines longer than this
         exclude = {},                    -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
         error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
         warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
         info = { "DiagnosticInfo", "#2563EB" },
         hint = { "DiagnosticHint", "#10B981" },
         default = { "Identifier", "#7C3AED" },
         test = { "Identifier", "#FF00FF" },
      },
      search = {
         command = "grep",
         args = {
            "-r",
            "--color=never",
            "--with-filename",
            "--line-number",
            "--binary-files=without-match",
            "--byte-offset",
            '--exclude-dir=".*"',
            "--extended-regexp",
         },
         -- regex that will be used to match keywords.
         -- don't replace the (KEYWORDS) placeholder
         pattern = [[\b(KEYWORDS):]], -- ripgrep regex
         -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
   },
};
