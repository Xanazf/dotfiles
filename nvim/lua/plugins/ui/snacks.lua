return {
  ---@module "snacks"
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
    -- stylua: ignore start
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- gh
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    },
    -- stylua: ignore end
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        image = {
          enabled = true,
        },
        indent = {
          enabled = true,
          only_scope = true,
          scope = {
            enabled = true,
          },
        },
        animate = {
          enabled = false,
          style = "out",
          easing = "linear",
          duration = {
            step = 20, -- ms per step
            total = 500, -- maximum duration
          },
        },
        ---@type snacks.explorer.Config
        explorer = {
          enabled = true,
          replace_netrw = true,
          layout = {
            preset = "sidebar",
            preview = false,
            layout = {
              width = 27,
              min_width = 27,
            },
          },
        },
        input = { enabled = true },
        scope = { enabled = true },
        scroll = {
          enabled = false,
          animate = {
            duration = { step = 10, total = 200 },
            easing = "linear",
          },
          -- faster animation when repeating scroll after delay
          animate_repeat = {
            delay = 100, -- delay in ms before using the repeat animation
            duration = { step = 5, total = 50 },
            easing = "linear",
          },
        },
        toggle = {
          map = LazyVim.safe_keymap_set,
        },
        words = { enabled = true },
        ---@type snacks.bigfile.Config
        bigfile = {
          enabled = true,
          size = 1.5 * 1024 * 1024, -- 1.5MB
        },
        debug = { enabled = true },
        ---@type snacks.picker.Config
        picker = {
          enabled = true,
          prompt = " ",
          ui_select = true,
          sources = {
            grep = {
              finder = "grep",
              format = "grep",
              live = true,
            },
          },
          layout = {
            cycle = true,
            --- Use the default layout or vertical if the window is too narrow
            preset = function()
              return vim.o.columns >= 120 and "default" or "vertical"
            end,
          },
          -- finder = "explorer",
          formatters = {
            file = {
              icon_width = 2,
            },
          },
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
          ---@type snacks.picker.db.Config
          db = {
            sqlite3_path = "/usr/bin/sqlite3",
          },
        },
        scratch = { enabled = true },
        terminal = { enabled = true },
        hover = { enabled = true },
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
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠉⠉⠙⠲⠭⠿⠿⠳⠶⢻⠓⠚⣻⠓⠛⣻⠉⠁⣸⠁⠀⠀⠀⠀⠀⠀⠀⢀⣠⠞⢳⣿⠉⢻⣧⠀⠀⠀⠀⠀⠀⠀
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
      })
    end,
  },
}
