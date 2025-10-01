---@type LazySpec
return {
  { "folke/lazy.nvim", version = false },
  {
    "nvim-tree/nvim-web-devicons",
    version = false,
    lazy = true,
  },
  {
    "onsails/lspkind.nvim",
    lazy = true,
    version = false,
  },
  ---@module "mini.icons"
  {
    "nvim-mini/mini.icons",
    lazy = false,
    priority = 1000,
    version = false,
    ---@class MiniIcons.ConfigPartial
    ---@return table
    config = function()
      local micons = require("mini.icons")
      micons.setup({
        style = "glyph",
        extension = {
          ["ts"] = { glyph = "󰛦", hl = "MiniIconsAzure" },
        },
        file = {
          ["tsconfig.json"] = { glyph = "󰛦", hl = "MiniIconsAzure" },
          ["package.json"] = { glyph = "󰌞", hl = "MiniIconsYellow" },
        },
        use_file_extension = function(ext, file)
          local ignore = {
            [".json"] = ".json",
            [".toml"] = ".toml",
            [".yml"] = ".yml",
            [".yaml"] = ".yaml",
          }
          return ignore[ext] == nil
        end,
      })
      micons.mock_nvim_web_devicons()
      micons.tweak_lsp_kind()
      _G.MiniIcons = micons
    end,
  },
  ---@module "lazyvim"
  {
    "LazyVim/LazyVim",
    version = false,
    ---@type LazyVimOptions
    opts = {},
  },
  {
    "rafamadriz/friendly-snippets",
    version = false,
    -- add blink.compat to dependencies
    dependencies = {
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
    },
  },
  {
    "nvim-mini/mini.snippets",
    enabled = false,
    version = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    config = function()
      local snippets = require("mini.snippets")
      snippets.gen_loader.from_lang()
    end,
  },
  ---@module "mini.doc"
  {
    "nvim-mini/mini.doc",
    version = false,
    lazy = false,
    config = function()
      local mdoc = require("mini.doc")
      mdoc.setup()
    end,
  },
  ---@module "fluoromachine"
  {
    "maxmx03/fluoromachine.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local fm = require("fluoromachine")
      fm.setup({
        theme = "fluoromachine",
        glow = false,
        brightness = 0.01,
        transparent = true,
        terminal_colors = true,
        colors = function(c, color)
          local darken = color.darken
          local lighten = color.lighten
          local blend = color.blend
          local shade = color.shade
          local tint = color.tint
          return {
            bg = nil,
          }
        end,
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
          -- snacks = true,
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
      vim.cmd.colorscheme("fluoromachine")
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
