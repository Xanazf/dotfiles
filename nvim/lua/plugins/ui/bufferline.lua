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
    opts = {
      ---@type bufferline.Options
      options = {
        numbers = "buffer_id",
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
        offsets = {
          {
            filetype = "snacks_explorer",
            text = "Explorer",
            highlight = "NormalFloat",
            text_align = "left",
          },
        },
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
        -- Transparency-friendly settings
        separator_style = "thin",
        indicator = {
          -- icon = "▎",
          style = "underline",
        },
        buffer_close_icon = "󰅖",
        modified_icon = LazyVim.config.icons.git.added,
        -- close_icon = "",
        -- left_trunc_marker = "",
        -- right_trunc_marker = "",
        show_buffer_icons = true,
        -- show_buffer_close_icons = false,
        -- show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        -- enforce_regular_tabs = false,
        always_show_bufferline = false,
        sort_by = "directory",
      },
    },
  },
}
