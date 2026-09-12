return {
   "rachartier/tiny-inline-diagnostic.nvim",

   init = function()
      vim.diagnostic.config( {
         virtual_text = false,
      } );
   end,

   opts = {
      disabled_ft = {},

      signs = {
         left = "",
         right = "",
         diag = "",
         arrow = "  󱦱 ",
         up_arrow = "    ",
         vertical = " │",
         vertical_end = " └",
      },
      blend = {
         factor = 0.22,
      },

      transparent_bg = false,        -- Make diagnostic background transparent
      transparent_cursorline = true, -- Make cursorline background transparent for diagnostics

      -- Use Neovim highlight group names or hex colors like "#RRGGBB"
      hi = {
         error = "DiagnosticError", -- Highlight for error diagnostics
         warn = "DiagnosticWarn",   -- Highlight for warning diagnostics
         info = "DiagnosticInfo",   -- Highlight for info diagnostics
         hint = "DiagnosticHint",   -- Highlight for hint diagnostics
         arrow = "NonText",         -- Highlight for the arrow pointing to diagnostic
         background = "CursorLine", -- Background highlight for diagnostics
         mixing_color = "Normal",   -- Color to blend background with (or "None")
      },

      options = {
         show_source = {
            enabled = false,
            if_many = true,
         },
         show_code = true,

         -- Use icons from vim.diagnostic.config instead of preset icons
         use_icons_from_diagnostic = false,

         -- Color the arrow to match the severity of the first diagnostic
         set_arrow_to_diag_color = false,


         -- Throttle update frequency in milliseconds to improve performance
         -- Higher values reduce CPU usage but may feel less responsive
         -- Set to 0 for immediate updates (may cause lag on slow systems)
         throttle = 20,

         -- Minimum number of characters before wrapping long messages
         softwrap = 30,

         add_messages = {
            messages = true,             -- Show full diagnostic messages
            display_count = false,       -- Show diagnostic count instead of messages when cursor not on line
            use_max_severity = false,    -- When counting, only show the most severe diagnostic
            show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
         },

         multilines = {
            enabled = true,           -- Enable support for multiline diagnostic messages
            always_show = false,      -- Always show messages on all lines of multiline diagnostics
            trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
            tabstop = 3,              -- Number of spaces per tab when expanding tabs
            severity = nil,           -- e.g. { vim.diagnostic.severity.ERROR }
         },

         -- Show all diagnostics on the current cursor line, not just those under the cursor
         show_all_diags_on_cursorline = true,

         -- Only show diagnostics when the cursor is directly over them, no fallback to line diagnostics
         show_diags_only_under_cursor = false,

         -- Display related diagnostics from LSP relatedInformation
         show_related = {
            enabled = true, -- Enable displaying related diagnostics
            max_count = 3,  -- Maximum number of related diagnostics to show per diagnostic
         },

         enable_on_insert = false,
         enable_on_select = false,

         -- Handle messages that exceed the window width
         overflow = {
            mode = "wrap", -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
            padding = 0,   -- Extra characters to trigger wrapping earlier
         },

         -- Break long messages into separate lines
         break_line = {
            enabled = false, -- Enable automatic line breaking
            after = 30,      -- Number of characters before inserting a line break
         },

         -- Custom function to format diagnostic messages
         -- Receives diagnostic object, returns formatted string
         -- Example: function(diag) return diag.message .. " [" .. diag.source .. "]" end
         format = nil,

         -- Virtual text display priority
         -- Higher values appear above other plugins (e.g., GitBlame)
         virt_texts = {
            priority = 2048,
         },

         -- Filter diagnostics by severity levels
         -- Remove severities you don't want to display
         severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
         },

         -- Events that trigger attaching diagnostics to buffers
         -- Default is {"LspAttach"}; change only if plugin doesn't work with your LSP setup
         overwrite_events = nil,

         -- Automatically disable diagnostics when opening diagnostic float windows
         override_open_float = false,
      },
   },
};
