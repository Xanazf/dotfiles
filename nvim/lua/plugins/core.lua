---@type LazySpec
return {
  { "folke/lazy.nvim" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "onsails/lspkind.nvim", lazy = true },

  ---@module "mini.icons"
  {
    "nvim-mini/mini.icons",
    priority = 1000,
    opts = {
      style = "glyph",
      extension = {
        ["ts"] = { glyph = "󰛦", hl = "MiniIconsAzure" },
      },
      file = {
        ["tsconfig.json"] = { glyph = "󰛦", hl = "MiniIconsAzure" },
        ["package.json"] = { glyph = "󰌞", hl = "MiniIconsYellow" },
      },
    },
  },
  ---@module "lazyvim"
  {
    "LazyVim/LazyVim",
    ---@param opts LazyVimOptions
    opts = function(_, opts)
      local miniIcons = MiniIcons or require("mini.icons")
      local micons_lsp = miniIcons.list("lsp")
      local micons_ft = miniIcons.list("filetype")
      local micons_file = miniIcons.list("file")
      local micons_extension = miniIcons.list("extension")

      if opts.icons then
        opts.icons.kinds = micons_lsp
        opts.icons.ft = micons_ft

        return opts
      end
      opts.icons = {}

      opts.icons.kinds = vim.tbl_deep_extend("force", LazyVim.config.icons.kinds, micons_lsp)
      opts.icons.ft = vim.tbl_deep_extend("force", LazyVim.config.icons.ft, micons_ft)

      return opts
    end,
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
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    opts = function(_, opts)
      local msnippets = require("mini.snippets")
      return opts
    end,
  },
  ---@module "mini.doc"
  {
    "nvim-mini/mini.doc",
    lazy = false,
    enabled = false,
    opts = function(_, opts)
      local mdoc = require("mini.doc")
      return opts
    end,
  },
  ---@module "fluoromachine"
  {
    "maxmx03/fluoromachine.nvim",
    priority = 1000,
    config = function()
      local fm = require("fluoromachine")
      fm.setup({
        theme = "fluoromachine",
        glow = false,
        brightness = 0.01,
        transparent = true,
        terminal_colors = true,
        colors = function(c, _)
          c.bg = nil
          c.bgdark = nil
          return c
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
          -- minicursor = true,
          -- ministarter = true,
          -- minitabline = true,
          -- ministatusline = true,
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
          -- lualine = true,
          -- snacks = true,
        },
      })
      vim.cmd.colorscheme([[fluoromachine]])
    end,
  },
  ---@module 'render-markdown'
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    cmd = { "RenderMarkdown" },
    ft = { "markdown", "mdx" },
    ---@type render.md.UserConfig
    opts = {
      enabled = true,
      render_modes = { "n", "c", "t" },
      file_types = { "markdown", "mdx" },
      preset = "lazy",
      restart_highlighter = false,
      anti_conceal = {
        -- This enables hiding added text on the line the cursor is on.
        enabled = true,
        -- Modes to disable anti conceal feature.
        disabled_modes = false,
        -- Number of lines above cursor to show.
        above = 0,
        -- Number of lines below cursor to show.
        below = 0,
        -- Which elements to always show, ignoring anti conceal behavior. Values can either be
        -- booleans to fix the behavior or string lists representing modes where anti conceal
        -- behavior will be ignored. Valid values are:
        --   bullet
        --   callout
        --   check_icon, check_scope
        --   code_background, code_border, code_language
        --   dash
        --   head_background, head_border, head_icon
        --   indent
        --   link
        --   quote
        --   sign
        --   table_border
        --   virtual_lines
        ignore = {
          code_background = true,
          indent = true,
          sign = true,
          virtual_lines = true,
        },
      },
      padding = {
        -- Highlight to use when adding whitespace, should match background.
        highlight = "Normal",
      },
      latex = {
        -- Turn on / off latex rendering.
        enabled = true,
        -- Additional modes to render latex.
        render_modes = false,
        -- Executable used to convert latex formula to rendered unicode.
        -- If a list is provided the first command available on the system is used.
        converter = { "utftex", "latex2text" },
        -- Highlight for latex blocks.
        highlight = "RenderMarkdownMath",
        -- Determines where latex formula is rendered relative to block.
        -- | above  | above latex block                               |
        -- | below  | below latex block                               |
        -- | center | centered with latex block (must be single line) |
        position = "center",
        -- Number of empty lines above latex blocks.
        top_pad = 0,
        -- Number of empty lines below latex blocks.
        bottom_pad = 0,
      },
      completions = {
        blink = { enabled = true },
        lsp = { enabled = true },
      },
      inline_highlight = {
        enabled = true,
        render_modes = true,
      },
      heading = {
        position = "inline",
        icons = { "󰼏 ", "󰎨 " },
      },
      callout = {
        -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
        -- | rendered   | replaces the 'raw' value when rendering                             |
        -- | highlight  | highlight for the 'rendered' text and quote markers                 |
        -- | quote_icon | optional override for quote.icon value for individual callout       |
        -- | category   | optional metadata useful for filtering                              |

        note = {
          raw = "[!NOTE]",
          rendered = "󰋽 Note",
          highlight = "RenderMarkdownInfo",
          category = "github",
        },
        tip = {
          raw = "[!TIP]",
          rendered = "󰌶 Tip",
          highlight = "RenderMarkdownSuccess",
          category = "github",
        },
        important = {
          raw = "[!IMPORTANT]",
          rendered = "󰅾 Important",
          highlight = "RenderMarkdownHint",
          category = "github",
        },
        warning = {
          raw = "[!WARNING]",
          rendered = "󰀪 Warning",
          highlight = "RenderMarkdownWarn",
          category = "github",
        },
        caution = {
          raw = "[!CAUTION]",
          rendered = "󰳦 Caution",
          highlight = "RenderMarkdownError",
          category = "github",
        },
        -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
        abstract = {
          raw = "[!ABSTRACT]",
          rendered = "󰨸 Abstract",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        summary = {
          raw = "[!SUMMARY]",
          rendered = "󰨸 Summary",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        tldr = {
          raw = "[!TLDR]",
          rendered = "󰨸 Tldr",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        info = {
          raw = "[!INFO]",
          rendered = "󰋽 Info",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        todo = {
          raw = "[!TODO]",
          rendered = "󰗡 Todo",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        hint = {
          raw = "[!HINT]",
          rendered = "󰌶 Hint",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        success = {
          raw = "[!SUCCESS]",
          rendered = "󰄬 Success",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        check = {
          raw = "[!CHECK]",
          rendered = "󰄬 Check",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        done = {
          raw = "[!DONE]",
          rendered = "󰄬 Done",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        question = {
          raw = "[!QUESTION]",
          rendered = "󰘥 Question",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        help = {
          raw = "[!HELP]",
          rendered = "󰘥 Help",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        faq = {
          raw = "[!FAQ]",
          rendered = "󰘥 Faq",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        attention = {
          raw = "[!ATTENTION]",
          rendered = "󰀪 Attention",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        failure = {
          raw = "[!FAILURE]",
          rendered = "󰅖 Failure",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        fail = {
          raw = "[!FAIL]",
          rendered = "󰅖 Fail",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        missing = {
          raw = "[!MISSING]",
          rendered = "󰅖 Missing",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        danger = {
          raw = "[!DANGER]",
          rendered = "󱐌 Danger",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        error = {
          raw = "[!ERROR]",
          rendered = "󱐌 Error",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        bug = {
          raw = "[!BUG]",
          rendered = "󰨰 Bug",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        example = {
          raw = "[!EXAMPLE]",
          rendered = "󰉹 Example",
          highlight = "RenderMarkdownHint",
          category = "obsidian",
        },
        quote = {
          raw = "[!QUOTE]",
          rendered = "󱆨 Quote",
          highlight = "RenderMarkdownQuote",
          category = "obsidian",
        },
        cite = {
          raw = "[!CITE]",
          rendered = "󱆨 Cite",
          highlight = "RenderMarkdownQuote",
          category = "obsidian",
        },
      },
    },
  },
}
