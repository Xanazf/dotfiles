return {
  ---@module "nvim-navic"
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = function(_, opts)
      vim.g.navic_silence = true
      LazyVim.lsp.on_attach(function(client, buffer)
        if client:supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
      local micons = MiniIcons.list("lsp")
      opts = vim.tbl_deep_extend("force", opts, {
        separator = ": ",
        highlight = true,
        depth_limit = 6,
        icons = micons,
        lazy_update_context = true,
      })
      return opts
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
}
