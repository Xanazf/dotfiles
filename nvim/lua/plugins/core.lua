return {
  { "folke/lazy.nvim", version = false },
  { "LazyVim/LazyVim", version = false },
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
    enable = false,
    version = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    config = function()
      local snippets = require("mini.snippets")
      snippets.gen_loader.from_lang()
    end,
  },
  {
    "nvim-mini/mini.doc",
    version = false,
    config = function()
      local mdoc = require("mini.doc")
      mdoc.setup()
    end,
  },
  {
    "maxmx03/fluoromachine.nvim",
    lazy = false,
    priority = 1000,
    ---@type function|fluoromachine
    config = function()
      local fm = require("fluoromachine")
      --- @module "fluoromachine"
      fm.setup({
        theme = "fluoromachine",
        glow = false,
        brightness = 0.01,
        transparent = true,
        terminal_colors = true,
        plugins = {
          bufferline = true,
          cmp = false,
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
          snacks = true,
          noice = true,
          notify = true,
          lspconfig = true,
          syntax = true,
          telescope = false,
          treesitter = true,
          tree = true,
          wk = true,
        },
      })
      vim.cmd([[colorscheme fluoromachine]])
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    keymap = { preset = "default" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        expand = function(snippet)
          return LazyVim.cmp.expand(snippet)
        end,
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },
      signature = {
        enabled = true,
      },
      sources = {
        compat = {},
        -- add lazydev to your completion providers
        default = { "lsp", "path", "snippets", "buffer", "omni", "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
      cmdline = {
        enabled = false,
      },
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    },
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
  },
}
