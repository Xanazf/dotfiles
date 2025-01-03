return {
  "maxmx03/fluoromachine.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local fm = require("fluoromachine")
    fm.setup({
      theme = "fluoromachine",
      glow = false,
      transparent = true,
      terminal_colors = true,
      plugins = {
        bufferline = true,
        cmp = true,
        dashboard = true,
        editor = true,
        gitsign = true,
        hop = true,
        ibl = true,
        illuminate = true,
        lazy = true,
        minicursor = true,
        ministarter = true,
        minitabline = true,
        ministatusline = true,
        navic = true,
        neogit = true,
        neotree = true,
        noice = true,
        notify = true,
        lspconfig = true,
        syntax = true,
        telescope = true,
        treesitter = true,
        tree = true,
        wk = true,
      },
    })
  end,
}
