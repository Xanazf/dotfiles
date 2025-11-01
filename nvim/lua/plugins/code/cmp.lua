return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  {
    "garyhurtz/blink_cmp_kitty",
    dependencies = { { "Saghen/blink.cmp" } },
    lazy = true,
    optional = true,
    opts = {
      enabled = true,

      trigger_characters = {},

      -- windows & tabs
      include_os_window = function(ctx)
        return true
      end,

      include_tab = function(ctx)
        return true
      end,

      include_window = function(ctx)
        return not ctx.is_self
      end,

      -- Timing configuration
      completion_min_update_period = 5, -- in seconds
      completion_item_lifetime = 60, -- in seconds
    },
  },
  { "nvim-lua/plenary.nvim" },

  ---@module 'blink.cmp'
  {
    "saghen/blink.cmp",
    version = "1.*",
    build = "cargo build --release",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "bydlw98/blink-cmp-env", lazy = true },
      { "moyiz/blink-emoji.nvim", lazy = true },
      "MahanRahmati/blink-nerdfont.nvim",
      { "alexandre-abrioux/blink-cmp-npm.nvim", lazy = true },
      { "phanen/blink-cmp-register", lazy = true },
      { "Kaiser-Yang/blink-cmp-git", lazy = true },
      { "disrupted/blink-cmp-conventional-commits", lazy = true },
      -- Dictionary completion for writing
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        lazy = true,
        ft = { "markdown", "text", "tex", "rst", "org" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
          dictionaries = {
            ["en"] = "/usr/share/dict/words",
          },
        },
      },
      { "ribru17/blink-cmp-spell", lazy = true },
      {
        "mgalliou/blink-cmp-tmux",
        lazy = true,
        cond = function()
          return vim.env.TMUX ~= nil
        end,
      },
      {
        "jdrupal-dev/css-vars.nvim",
        lazy = true,
        ft = { "css", "scss", "sass", "less", "stylus", "vue", "svelte", "html" },
      },
      -- LaTeX symbols completion
      { "erooke/blink-cmp-latex", lazy = true, ft = { "tex", "latex", "markdown" } },
      -- Ripgrep-based completion for project-wide search
      {
        "mikavilpas/blink-ripgrep.nvim",
        lazy = true,
        version = "*",
        opts = {
          get_command = function(_, prefix)
            return {
              "rg",
              "--no-heading",
              "--no-line-number",
              "--color=never",
              "--smart-case",
              prefix,
            }
          end,
        },
      },
      -- SSH config completion
      {
        "bydlw98/blink-cmp-sshconfig",
        lazy = true,
        ft = { "sshconfig", "ssh_config" },
      },
      -- Database completion (if using vim-dadbod)
      {
        "kristijanhusak/vim-dadbod-completion",
        lazy = true,
        ft = { "sql", "mysql", "plsql" },
        dependencies = {
          "tpope/vim-dadbod",
        },
      },
    },
    opts_extend = {
      "sources.default",
      "sources.per_filetype",
      "sources.compat",
    },
    ---@type blink.cmp.Config
    opts = {
      -- keymap = { preset = "default" },
      ---@type blink.cmp.KeymapConfig
      keymap = {
        preset = "enter",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      ---@type blink.cmp.AppearanceConfigPartial
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "",
        },
      },
      ---@type blink.cmp.CompletionConfigPartial
      completion = {
        trigger = {
          show_on_blocked_trigger_characters = {},
        },
        keyword = { range = "full" },
        accept = {
          auto_brackets = {
            enabled = true,
            default_brackets = { "(", ")" },
            override_brackets_for_filetypes = {
              lua = { "{", "}" },
              rust = { "(", ")" },
              go = { "(", ")" },
            },
            force_allow_filetypes = {},
            blocked_filetypes = {},
            kind_resolution = {
              enabled = true,
              blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
            },
            semantic_token_resolution = {
              enabled = true,
              blocked_filetypes = {},
            },
          },
        },
        list = {
          selection = { preselect = true, auto_insert = false },
        },

        ---@type blink.cmp.CompletionMenuConfigPartial
        menu = {
          enabled = true,
          min_width = 21,
          max_height = 18,
          border = "rounded",
          winhighlight = "NormalFloat:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder",
          scrollbar = true,
          scrolloff = 2,
          direction_priority = { "s", "n" },
          auto_show = true,
          ---@type blink.cmp.CompletionMenuOrderConfigPartial
          order = {},
          ---@type blink.cmp.Draw
          draw = {
            align_to = "label", -- or "none" to disable
            padding = 1,
            gap = 1,
            treesitter = {},
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              ---@type blink.cmp.DrawComponent
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local micon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  if micon then
                    return micon .. ctx.icon_gap
                  end

                  local icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local micon, mhl, _ = require("mini.icons").get("lsp", ctx.kind)
                  if micon then
                    return mhl
                  end
                  return ctx.kind_hl
                end,
              },
              ---@type blink.cmp.DrawComponent
              kind = {
                ellipsis = false,
                width = { fill = true },
                text = function(ctx)
                  return ctx.kind
                end,
                highlight = function(ctx)
                  local mini_icon, mini_hl = require("mini.icons").get("lsp", ctx.kind)
                  if mini_icon then
                    return mini_hl
                  end
                  return ctx.kind_hl
                end,
              },
              ---@type blink.cmp.DrawComponent
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  return ctx.label .. ctx.label_detail
                end,
                highlight = function(ctx)
                  local highlights = {
                    BlinkCmpLabelMatch = { 1, #ctx.kind },
                  }
                  return highlights
                end,
              },
              ---@type blink.cmp.DrawComponent
              label_description = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.label_description
                end,
                highlight = "BlinkCmpLabelDescription",
              },
              ---@type blink.cmp.DrawComponent
              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.source_name
                end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },
        ---@type blink.cmp.CompletionDocumentationConfigPartial
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = {
            min_width = 12,
            max_width = 24,
            max_height = 21,
            border = "rounded",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:Visual,Search:None",
            scrollbar = true,
            direction_priority = {
              menu_south = { "e", "w", "n", "s" },
              menu_north = { "w", "e", "s", "n" },
            },
          },
        },

        ghost_text = {
          enabled = true,
          show_without_selection = true,
        },
      },

      ---@type blink.cmp.SignatureConfigPartial
      signature = {
        enabled = true,
        trigger = {
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          show_on_insert_on_trigger_character = true,
        },
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          border = "rounded",
          winblend = 0,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          scrollbar = false,
          direction_priority = { "n", "s" },
        },
      },
      ---@type blink.cmp.FuzzyConfigPartial
      fuzzy = {
        implementation = "rust",
        use_proximity = true,
        sorts = { "exact", "score", "label", "kind" },
        prebuilt_binaries = {
          download = true,
          force_version = nil,
        },
      },

      ---@type blink.cmp.SourceList
      sources = {
        default = { "lsp", "path", "buffer", "snippets" },
        min_keyword_length = 0,
        per_filetype = {
          lua = { "lazydev", "lsp", "path", "buffer", "snippets" },
          gitcommit = { "git", "conventional_commits", "buffer", "spell", "emoji" },
          gitrebase = { "git", "buffer" },
          gitconfig = { "git", "buffer" },
          markdown = { "lsp", "path", "buffer", "spell", "latex", "emoji" },
          text = { "buffer", "spell", "emoji" },
          tex = { "lsp", "path", "snippets", "buffer", "latex" },
          rst = { "lsp", "path", "buffer", "spell", "snippets" },
          org = { "lsp", "path", "buffer", "spell" },
          javascript = { "lsp", "path", "buffer", "npm", "snippets" },
          typescript = { "lsp", "path", "buffer", "npm", "snippets" },
          json = { "lsp", "path", "buffer", "npm" },
          css = { "lsp", "path", "snippets", "buffer", "css_vars" },
          scss = { "lsp", "path", "snippets", "buffer", "css_vars" },
          sass = { "lsp", "path", "snippets", "buffer", "css_vars" },
          less = { "lsp", "path", "snippets", "buffer", "css_vars" },
          vue = { "lsp", "path", "snippets", "buffer", "css_vars" },
          svelte = { "lsp", "path", "snippets", "buffer", "css_vars" },
          html = { "lsp", "path", "snippets", "buffer", "css_vars" },
          sql = { "lsp", "dadbod", "buffer" },
          mysql = { "lsp", "dadbod", "buffer" },
          plsql = { "lsp", "dadbod", "buffer" },
          sshconfig = { "sshconfig", "buffer" },
          ssh_config = { "sshconfig", "buffer" },
          -- cmdline = { "buffer", "cmdline", "register", "env" },
          sh = { "buffer", "cmdline", "register", "env" },
          fish = { "fish_lsp", "buffer", "cmdline", "register", "env" },
        },

        transform_items = function(_, items)
          for _, item in ipairs(items) do
            if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
              item.score_offset = item.score_offset and item.score_offset - 3 or -3
            end
          end
          return items
        end,
        ---@type table<string, blink.cmp.SourceProviderConfigPartial>
        providers = {
          lsp = {
            name = "lsp",
            module = "blink.cmp.sources.lsp",
            enabled = true,
            should_show_items = true,
            deduplicate = {},
            max_items = nil,
            fallbacks = {},
            score_offset = 66,
            override = {
              get_trigger_characters = function(self)
                local trigger_characters = self:get_trigger_characters()
                vim.list_extend(trigger_characters, { "\n", "\t", " " })
                return trigger_characters
              end,
            },
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            deduplicate = {},
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = false,
            },
            score_offset = 3,
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            deduplicate = {},
            score_offset = -3,
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character"
            end,
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath("config") .. "/snippets" },
              global_snippets = { "all" },
              extended_filetypes = {},
              ignored_filetypes = {},
            },
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            deduplicate = {},
            fallbacks = {},
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                  return byte_size and byte_size < 1024 * 1024 -- 1MB limit
                end, vim.api.nvim_list_bufs())
              end,
            },
            score_offset = 12,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
          cmdline = {
            name = "Cmdline",
            module = "blink.cmp.sources.cmdline",
            enabled = true,
            should_show_items = true,
            max_items = nil,
            min_keyword_length = 2,
            fallbacks = { "buffer", "env", "register" },
          },
          git = {
            name = "Git",
            module = "blink-cmp-git",
            score_offset = 2,
          },
          conventional_commits = {
            name = "Conventional Commits",
            module = "blink-cmp-conventional-commits",
            score_offset = 0,
          },
          env = {
            name = "Environment",
            module = "blink-cmp-env",
            score_offset = -2,
          },
          emoji = {
            name = "Emoji",
            module = "blink-emoji",
            score_offset = -5,
            opts = {
              insert = true,
            },
          },
          nerdfont = {
            name = "Nerd Font",
            module = "blink-nerdfont",
            score_offset = 1,
          },
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            score_offset = -6,
          },
          npm = {
            name = "NPM",
            module = "blink-cmp-npm",
            score_offset = 3,
            min_keyword_length = 5,
          },
          css_vars = {
            name = "css-vars",
            module = "css-vars.blink",
            score_offset = 2,
            opts = {
              search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
            },
          },
          latex = {
            name = "LaTeX",
            module = "blink-cmp-latex",
            score_offset = 1,
          },
          dadbod = {
            name = "Database",
            module = "vim_dadbod_completion.blink",
            score_offset = 6,
          },
          ripgrep = {
            name = "Ripgrep",
            module = "blink-ripgrep",
            score_offset = 0,
            opts = {
              prefix_min_len = 3,
              get_command = function(_, prefix)
                return {
                  "rg",
                  "--no-heading",
                  "--no-line-number",
                  "--color=never",
                  "--smart-case",
                  prefix,
                }
              end,
            },
          },
          -- Terminal and system sources
          tmux = {
            name = "Tmux",
            module = "blink-cmp-tmux",
            score_offset = -1,
            enabled = function()
              return vim.env.TMUX ~= nil
            end,
          },
          -- SSH configuration
          sshconfig = {
            name = "SSH Config",
            module = "blink-cmp-sshconfig",
            score_offset = -1,
          },
          -- Vim registers
          register = {
            name = "Register",
            module = "blink-cmp-register",
            score_offset = 3,
          },
        },
      },

      ---@type blink.cmp.CmdlineConfigPartial
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        sources = { "buffer", "cmdline" },
        completion = {
          list = { selection = { preselect = false } },
          menu = { auto_show = true },
          ghost_text = { enabled = true },
        },
      },
    },
  },
}
