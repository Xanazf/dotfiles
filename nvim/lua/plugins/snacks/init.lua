return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@class snacks.Config
  opts = {
    bigfile = { enabled = true },
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
          pane = 2,
          section = "terminal",
          -- cmd = "shuffle ~/.config/fish/cats.txt -s 30 -c yellow",
          cmd = "cbonsai -l -m 'no diff' -s 369",
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
    notifier = {
      enabled = true,
      timeout = 3000,
    },
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
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
}
