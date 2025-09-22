---@type LazySpec
return {
  ---@module "mini.hipatterns"
  {
    "nvim-mini/mini.hipatterns",
    version = false,
    ---@return table
    opts = function()
      local mhipatterns = require("mini.hipatterns")
      mhipatterns.setup()
    end,
  },
  ---@module "mini.animate"
  {
    "nvim-mini/mini.animate",
    version = false,
    ---@return table
    opts = function()
      local manimate = require("mini.animate")
      manimate.setup()
    end,
  },
  ---@module "mini.notify"
  {
    "nvim-mini/mini.notify",
    version = false,
    enabled = false,
    opts = function()
      local mnotify = require("mini.notify")
      mnotify.setup({
        -- Content management
        content = {
          -- Function which formats the notification message
          -- By default prepends message with notification time
          format = nil,

          -- Function which orders notification array from most to least important
          -- By default orders first by level and then by update timestamp
          sort = nil,
        },

        -- Notifications about LSP progress
        lsp_progress = {
          -- Whether to enable showing
          enable = true,

          -- Notification level
          level = "INFO",

          -- Duration (in ms) of how long last message should be shown
          duration_last = 1000,
        },

        -- Window options
        window = {
          -- Floating window config
          config = {},

          -- Maximum window width as share (between 0 and 1) of available columns
          max_width_share = 0.382,

          -- Value of 'winblend' option
          winblend = 25,
        },
      })
    end,
  },
  ---@module "noice"
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    ---@type NoiceConfig
    opts = {
      views = {
        mini = {},
        cmdline_popup = {
          position = {
            row = 3,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
      lsp = {
        hover = {
          enabled = true,
          silent = false, -- set to true to not show a message if hover is not available
          ---@type NoiceView
          view = nil,
          ---@type NoiceViewOptions
          opts = {
            border = "rounded",
            win_options = {
              breakindent = false,
              linebreak = false,
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
          }, -- merged with defaults from documentation
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        message = {
          -- Messages shown by lsp servers
          enabled = false,
          view = "notify",
          opts = {},
        },
        documentation = {
          view = "hover",
          ---@type NoiceViewOptions
          opts = {
            win_options = {
              linebreak = true,
              wrap = true,
              breakindent = false,
              conceallevel = 0,
              winblend = 0,
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
          },
        },
      },
      presets = {
        command_palette = true,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "hasansujon786/nvim-navbuddy",
    version = false,
    lazy = true,
  },
  {
    "SmiteshP/nvim-navic",
    version = false,
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      LazyVim.lsp.on_attach(function(client, buffer)
        if client:supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = LazyVim.config.icons.kinds,
        lazy_update_context = true,
      }
    end,
  },
  ---@module "which-key"
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    ---@class wk.Opts
    opts = {
      preset = "modern",
      keys = {},
      delay = 500,
      ---@type wk.Win.opts
      win = {
        wo = {
          -- Use transparent float background by linking to Normal (no fill)
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
  },
  ---@module "bufferline"
  {
    ---@type bufferline.UserConfig
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
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
    ---@type bufferline.Options
    opts = {
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
      ---@type bufferline.Highlights
      highlights = {
        fill = {
          fg = "NONE",
          bg = "NONE",
          hl_group = "Normal",
        },
        background = {
          fg = "NONE",
          bg = "NONE",
          hl_group = "Normal",
        },
      },
      offsets = {
        {
          filetype = "snacks_explorer",
          text = "Explorer",
          highlight = "NormalFloat",
          text_align = "left",
        },
        {
          filetype = "snacks_picker",
          text = "Picker",
          highlight = "NormalFloat",
          text_align = "left",
        },
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "NormalFloat",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },
      get_element_icon = function(opts)
        return LazyVim.config.icons.ft[opts.filetype]
      end,
      -- Transparency-friendly settings
      separator_style = "thin",
      indicator = {
        icon = "▎", -- this should be omitted if indicator style is not 'icon'
        style = "icon",
      },
      buffer_close_icon = "󰅖",
      modified_icon = LazyVim.config.icons.git.added,
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      show_buffer_icons = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      enforce_regular_tabs = false,
      always_show_bufferline = false,
      sort_by = "directory",
    },
  },
  ---@module "lualine"
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, opts)
      local icons = LazyVim.config.icons
      opts = {
        options = {
          theme = "fluoromachine",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = {
            statusline = {
              "dashboard",
              "snacks_dashboard",
              "alpha",
              "ministarter",
              "diffview",
              "fugitive",
              "gitsigns",
              "quickfix",
              "loclist",
              "Trouble",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            LazyVim.lualine.root_dir(),
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = " ",
              padding = { left = 1, right = 0 },
            },
            {
              LazyVim.lualine.pretty_path(),
              padding = { left = 0, right = 0 },
            },
          },
          lualine_x = {
            Snacks.profiler.status(),
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return require("noice").api.status.command.has() end,
              color = { fg = Snacks.util.color("Statement") },
            } or nil,
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            } or nil,
            -- stylua: ignore
            {
              function() return " " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            -- stylua: ignore
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local summary = vim.b.minidiff_summary
                return summary
                  and {
                    added = summary.add,
                    modified = summary.change,
                    removed = summary.delete,
                  }
              end,
            },
          },
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = { left = 1, right = 0 },
            },
            {
              "location",
              padding = { left = 0, right = 1 },
            },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
      }
      return opts
    end,
  },
  ---@module "snacks"
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = {
        enabled = true,
      },
      indent = {
        enabled = true,
        scope = {
          enabled = true,
        },
      },
      explorer = {
        enabled = true,
        picker = {},
      },
      input = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      toggle = {
        map = LazyVim.safe_keymap_set,
      },
      words = { enabled = true },
      bigfile = { enabled = true },
      debug = { enabled = true },
      picker = {
        enabled = true,
        icons = MiniIcons,
        ui_select = true,
        explorer = {
          supports_live = true,
          tree = true,
          watch = true,
          diagnostics = true,
        },
      },
      scratch = { enabled = true },
      terminal = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
ᓚᘏᗢ
██╗  ██╗███╗   ██╗███████╗███████╗
╚██╗██╔╝████╗  ██║╚══███╔╝██╔════╝
 ╚███╔╝ ██╔██╗ ██║  ███╔╝ █████╗  
 ██╔██╗ ██║╚██╗██║ ███╔╝  ██╔══╝  
██╔╝ ██╗██║ ╚████║███████╗██║     
╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝     
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣄⠀⠀⠸⡄⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢤⡀⠀⢤⣀⠀⠀⠘⢶⣄⠀⢹⡆⠀⢸⠰⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠀⢢⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠙⢶⣄⡈⢉⣻⡶⣴⠿⢷⠶⠿⢦⣼⣀⠹⣆⠀⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡌⠒⢦⣄⠀⠀⣇⠀⠘⣇⠀⡇⠀⠀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣀⣀⣤⣤⣤⣶⣶⡒⣿⠛⢻⡀⠀⢧⡀⢸⡀⠀⡾⠉⣙⡷⢿⣆⠀⢷⠀⢸⠀⢰⠀⠸⡇⠘⣆⠀⠀⠙⢦⣄⣈⣷⣤⣷⣴⣤⣿⣀⡇⢀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠉⠉⠉⠉⠉⠉⣉⣩⡽⣻⣷⣴⠟⠒⣻⡿⢏⣻⣒⣿⣦⣿⡀⡶⠛⠻⣾⣄⣸⠀⢸⡀⠀⢻⡄⠘⢷⡀⣠⣴⣟⠉⢻⡀⢼⣏⠀⡿⢉⣿⣾⣇⠀⠀⣤⠞⠀⠀⠀⠀⠀⠀⠀
⠀⣀⣠⣤⣴⡾⠿⠚⠋⢁⡼⠏⠈⠉⠁⠀⠀⠀⠀⠁⠀⠈⠛⣧⣄⣼⠃⠈⣿⠷⣾⣥⣄⣸⡧⢶⠞⠛⣏⠀⠹⣦⣨⣿⠞⠛⣛⣷⢾⣧⡶⢛⣷⠞⠁⠀⣀⡤⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠐⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠚⠋⠉⠈⢛⣷⣾⣇⠀⢸⠁⠀⣏⠀⠘⣧⣀⣸⣷⣾⠿⠛⠁⠛⠛⠿⠥⣤⠿⢶⠋⣉⣳⣶⠟⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠉⠉⠙⠲⠭⠿⠿⠳⠶⢻⠓⠚⣻⠉⠁⣸⠁⠀⠀⠀⠀⠀⠀⠀⢀⣠⠞⢳⣿⠉⢻⣧⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠏⠀⣰⠏⠀⢠⠏⠀⠀⠀⠀⠀⠀⠀⠐⠋⠁⠀⠈⠻⣿⠋⠋⠉⠉⠉⠉⠉⠉⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠃⠀⠰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
ฅ^•ﻌ•^ฅ
]],
        },
        sections = {
          { section = "header" },
          -- { hl = "header", pane = 2, section = "terminal", cmd = "cbonsai -l -m 'no diff' -s 369", height = 25, padding = 1 },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = vim.fn.isdirectory(".git") == 1,
            cmd = "hub status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
      lazygit = { enabled = true },
      notifier = { enabled = true },
      notify = { enabled = false },
      quickfile = { enabled = true },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = false, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      styles = {
        notification = {
          wo = { wrap = true, winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
        },
      },
    },
  },
}
