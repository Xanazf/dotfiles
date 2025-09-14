return {
  { "nvim-tree/nvim-web-devicons", version = false, lazy = true },
  {
    "nvim-mini/mini.hipatterns",
    version = false,
    opts = function()
      local mhipatterns = require("mini.hipatterns")
      mhipatterns.setup()
    end,
  },
  {
    "nvim-mini/mini.icons",
    version = false,
    opts = function()
      local micons = require("mini.icons")
      micons.setup()
    end,
  },
  {
    "nvim-mini/mini.animate",
    version = false,
    opts = function()
      local manimate = require("mini.animate")
      manimate.setup()
    end,
  },
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
          enable = false,

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
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        hover = {
          enabled = true,
          silent = false, -- set to true to not show a message if hover is not available
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
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
      },
      presets = {
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      ---@type NoiceConfigViews
      views = {
        mini = {},
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
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    enabled = false,
    version = false,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      attach_navic = false,
      show_dirname = false,
      show_basename = false,
      ---@type barbecue.Config.theme
      theme = {
        -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
        normal = { fg = "#8BA7A7" },

        -- these highlights correspond to symbols table from config
        ellipsis = { fg = "#FFCC00" },
        separator = { fg = "#FC199A" },
        modified = { fg = "#CCA300" },

        -- these highlights represent the _text_ of three main parts of barbecue
        -- dirname = { fg = "#737aa2" },
        -- basename = { bold = true },
        context = { bold = true },

        -- these highlights are used for context/navic icons
        context_file = { fg = "#FFCC00" },
        context_module = { fg = "#FFCC00" },
        context_namespace = { fg = "#FC199A" },
        context_package = { fg = "#FE6973" },
        context_class = { fg = "#CA147B" },
        context_method = { fg = "#FFCC00" },
        context_property = { fg = "#61E2FF" },
        context_field = { fg = "#61E2FF" },
        context_constructor = { fg = "#FE4450" },
        context_enum = { fg = "#FE4450" },
        context_interface = { fg = "#FC199A" },
        context_function = { fg = "#FFCC00" },
        context_variable = { fg = "#81E8FF" },
        context_constant = { fg = "#81E8FF" },
        context_string = { fg = "#AF6DF9" },
        context_number = { fg = "#AF6DF9" },
        context_boolean = { fg = "#AF6DF9" },
        context_array = { fg = "#CA147B" },
        context_object = { fg = "#FFCC00" },
        context_key = { fg = "#81E8FF" },
        context_null = { fg = "#AF6DF9" },
        context_enum_member = { fg = "#81E8FF" },
        context_struct = { fg = "#AF6DF9" },
        context_event = { fg = "#5BC193" },
        context_operator = { fg = "#72F1B8" },
        context_type_parameter = { fg = "#61E2FF" },
      },
      kinds = LazyVim.config.icons.kinds,
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    ---@class wk.Opts
    opts = {
      preset = "modern",
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = function()
      -- local Offset = require("bufferline.offset")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local icons = LazyVim.config.icons
      local opts = {
        options = {
          theme = "fluoromachine",
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
            -- stylua: ignore
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = {
                fg = Snacks.util.color("Statement"),
              },
            },
            -- stylua: ignore
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = {
                fg = Snacks.util.color("Constant"),
              },
            },
            -- stylua: ignore
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = {
                fg = Snacks.util.color("Debug"),
              },
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = {
                fg = Snacks.util.color("Special"),
              },
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

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@class snacks.Config
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
      explorer = { enabled = true },
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
          {
            hl = "header",
            pane = 2,
            section = "terminal",
            cmd = "shuffle ~/.config/fish/bongocat.txt -s 30 -c yellow",
            -- cmd = "cbonsai -l -m 'no diff' -s 369",
            height = 25,
            padding = 1,
          },
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
        enabled = false,
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
          wo = { wrap = true }, -- Wrap notifications
        },
      },
    },
  },
}
