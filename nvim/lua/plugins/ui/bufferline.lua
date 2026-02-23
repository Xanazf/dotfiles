return {
  ---@module "bufferline"
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    ---@type bufferline.UserConfig
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = function()
      local bl = require("bufferline")
      return {
        ---@type bufferline.Options
        options = {
          -- numbers = "buffer_id",
          style_preset = bl.style_preset.default, -- or bufferline.style_preset.minimal,
          themable = true,
          close_command = function(n)
          Snacks.bufdelete.delete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete.delete(n)
        end,

        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        diagnostics_update_on_event = true,
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "",
            separator = true,
          },
        },
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
        -- Transparency-friendly settings
        separator_style = "thick",
        indicator = {
          icon = " @",
          style = "icon",
        },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        buffer_close_icon = "󰅖",
        close_icon = " ",
        modified_icon = LazyVim.config.icons.git.added,
        left_trunc_marker = " ",
        right_trunc_marker = " ",
        show_buffer_close_icons = false,
        -- show_close_icon = false,
        persist_buffer_sort = true,
        -- enforce_regular_tabs = false,
        always_show_bufferline = false,
        sort_by = "insert_after_current",
        truncate_names = true,

        show_tab_indicators = true,
        show_buffer_icons = true,
        color_icons = true,
      },
    }
  end,
},
}
