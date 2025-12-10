return {
  ---@module "snacks"
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
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
      ---@type snacks.explorer.Config
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      input = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      toggle = {
        map = LazyVim.safe_keymap_set,
      },
      words = { enabled = true },
      ---@type snacks.bigfile.Config
      bigfile = {
        enabled = false,
        size = 1572864,
      },
      debug = { enabled = true },
      picker = {
        enabled = true,
        prompt = " ",
        ui_select = true,
        layout = {
          cycle = true,
          --- Use the default layout or vertical if the window is too narrow
          preset = function()
            return vim.o.columns >= 120 and "default" or "vertical"
          end,
        },
        ---@type snacks.picker.matcher.Config
        matcher = {
          fuzzy = true, -- use fuzzy matching
          smartcase = true, -- use smartcase
          ignorecase = true, -- use ignorecase
          sort_empty = false, -- sort results when the search string is empty
          filename_bonus = true, -- give bonus for matching file names (last part of the path)
          file_pos = true, -- support patterns like `file:line:col` and `file:line`
          -- the bonusses below, possibly require string concatenation and path normalization,
          -- so this can have a performance impact for large lists and increase memory usage
          cwd_bonus = false, -- give bonus for matching files in the cwd
          frecency = false, -- frecency bonus
          history_bonus = false, -- give more weight to chronological order
        },
        -- finder = "explorer",
        formatters = {
          file = {
            icon_width = 2,
          },
        },
        ---@type snacks.picker.sources.Config
        sources = {
          system_cliphist = {
            finder = "system_cliphist",
            format = "text",
            preview = "preview",
            confirm = { "copy", "close" },
          },
          ---@type snacks.picker.explorer.Config
          explorer = {
            finder = "explorer",
            sort = { fields = { "sort" } },
            -- cmd = "rg",
            tree = true,
            supports_live = true,
            watch = true,
            follow_file = false,
            focus = "list",
            auto_close = false,
            jump = { close = false },
            layout = {
              preset = "sidebar",
              preview = false,
              layout = {
                width = 27,
                min_width = 27,
              },
            },
            formatters = {
              file = { filename_only = true },
              severity = { pos = "right" },
            },
            matcher = { sort_empty = false, fuzzy = true },
          },
          ---@type snacks.picker.history.Config
          command_history = {
            finder = "vim_history",
            name = "cmd",
            format = "text",
            preview = "none",
            layout = {
              preset = "vscode",
            },
            confirm = "cmd",
            formatters = { text = { ft = "vim" } },
          },
          commands = {
            finder = "vim_commands",
            format = "command",
            preview = "preview",
            confirm = "cmd",
          },
          help = {
            finder = "help",
            format = "text",
            previewers = {
              file = { ft = "help" },
            },
            win = { preview = { minimal = true } },
            confirm = "help",
          },
          highlights = {
            finder = "vim_highlights",
            format = "hl",
            preview = "preview",
            confirm = "close",
          },
          icons = {
            icon_sources = { "nerd_fonts", "emoji" },
            finder = "icons",
            format = "icon",
            layout = { preset = "vscode" },
            confirm = "put",
          },
          lazy = {
            finder = "lazy_spec",
            pattern = "'",
          },
          lsp_config = {
            finder = "lsp.config#find",
            format = "lsp.config#format",
            preview = "lsp.config#preview",
            confirm = "close",
            sort = { fields = { "score:desc", "attached_buf", "attached", "enabled", "installed", "name" } },
            matcher = { sort_empty = true },
          },
          lsp_declarations = {
            finder = "lsp_declarations",
            format = "file",
            include_current = false,
            auto_confirm = true,
            jump = { tagstack = true, reuse_win = true },
          },
          lsp_definitions = {
            finder = "lsp_definitions",
            format = "file",
            include_current = false,
            auto_confirm = true,
            jump = { tagstack = true, reuse_win = true },
          },
          lsp_implementations = {
            finder = "lsp_implementations",
            format = "file",
            include_current = false,
            auto_confirm = true,
            jump = { tagstack = true, reuse_win = true },
          },
          lsp_references = {
            finder = "lsp_references",
            format = "file",
            include_declaration = true,
            include_current = false,
            auto_confirm = true,
            jump = { tagstack = true, reuse_win = true },
          },
          lsp_symbols = {
            finder = "lsp_symbols",
            format = "lsp_symbol",
            tree = true,
            filter = {
              default = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Package",
                "Property",
                "Struct",
                "Trait",
              },
              -- set to `true` to include all symbols
              markdown = true,
              help = true,
              -- you can specify a different filter for each filetype
              lua = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                -- "Package", -- remove package since luals uses it for control flow structures
                "Property",
                "Struct",
                "Trait",
              },
            },
          },
          lsp_type_definitions = {
            finder = "lsp_type_definitions",
            format = "file",
            include_current = false,
            auto_confirm = true,
            jump = { tagstack = true, reuse_win = true },
          },
          notifications = {
            finder = "snacks_notifier",
            format = "notification",
            preview = "preview",
            formatters = { severity = { level = true } },
            confirm = "close",
          },
          recent = {
            finder = "recent_files",
            format = "file",
            filter = {
              paths = {
                [vim.fn.stdpath("data")] = false,
                [vim.fn.stdpath("cache")] = false,
                [vim.fn.stdpath("state")] = false,
              },
            },
          },
          registers = {
            finder = "vim_registers",
            format = "register",
            preview = "preview",
            confirm = { "copy", "close" },
          },
          select = {
            items = {}, -- these are set dynamically
            main = { current = true },
            layout = { preset = "select" },
          },
          treesitter = {
            finder = "treesitter_symbols",
            format = "lsp_symbol",
            tree = true,
            filter = {
              default = {
                "Class",
                "Enum",
                "Field",
                "Function",
                "Method",
                "Module",
                "Namespace",
                "Struct",
                "Trait",
              },
              -- set to `true` to include all symbols
              markdown = true,
              help = true,
            },
          },
        },
        ---@type snacks.picker.db.Config
        db = {
          sqlite3_path = "/usr/bin/sqlite3",
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
      keys = {
        {
          "<leader><space>",
          function()
            Snacks.picker.smart()
          end,
          desc = "Smart Find Files",
        },
      },
    },
  },
}
