return {
   "j-hui/fidget.nvim",
   opts = {
      -- Options related to LSP progress subsystem
      progress = {
         ignore = {}, -- List of LSP servers to ignore

         -- Options related to how LSP progress messages are displayed as notifications
         display = {
            done_ttl = 3, -- How long a message should persist after completion
            done_icon = "󱢇", -- Icon shown when all LSP progress tasks are complete
            done_style = "Constant", -- Highlight group for completed LSP tasks
            progress_icon = { "star" }, -- Icon shown when LSP progress tasks are in progress
            progress_style = "WarningMsg", -- Highlight group for in-progress LSP tasks
            icon_style = "Question", -- Highlight group for group icons
         },
      },

      -- Options related to notification subsystem
      notification = {
         poll_rate = 10,               -- How frequently to update and render notifications
         filter = vim.log.levels.INFO, -- Minimum notifications level
         history_size = 128,           -- Number of removed messages to retain in history
         override_vim_notify = false,  -- Automatically override vim.notify() with Fidget

         -- Options related to how notifications are rendered as text
         view = {
            stack_upwards = true,        -- Display notification items from bottom to top
            align = "message",           -- Indent messages longer than a single line
            reflow = false,              -- Reflow (wrap) messages wider than notification window
            icon_separator = " ",        -- Separator between group name and icon
            group_separator = "~~~ ~~~", -- Separator between notification groups
            group_separator_hl =         -- Highlight group used for group separator
            "Comment",
            line_margin = 1,             -- Spaces to pad both sides of each non-empty line
            render_message =             -- How to render notification messages
               function( msg, cnt )
                  return cnt == 1 and msg or string.format( "(%dx) %s", cnt, msg );
               end,
         },

         -- Options related to the notification window and buffer
         window = {
            normal_hl = "Comment", -- Base highlight group in the notification window
            winblend = 100,        -- Background color opacity in the notification window
            border = "none",       -- Border around the notification window
            zindex = 45,           -- Stacking priority of the notification window
            max_width = 0,         -- Maximum width of the notification window
            max_height = 0,        -- Maximum height of the notification window
            x_padding = 1,         -- Padding from edge of window boundary
            y_padding = 0,         -- Padding from top/bottom edge of window boundary
            align = "bottom",      -- How to align the notification window vertically
            h_align = "right",     -- How to align the notification window horizontally
            relative = "editor",   -- What the notification window position is relative to
            tabstop = 3,           -- Width of each tab character in the notification window
            avoid = {},            -- Filetypes the notification window should avoid
         },
      },

      -- Options related to logging
      logger = {
         enable = false, -- Whether to enable file logging
      },
   },
};
