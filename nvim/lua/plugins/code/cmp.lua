return {
  { "nvim-lua/plenary.nvim" },

  { "saghen/blink.lib" },
  ---@module 'blink.cmp'
  {
    "saghen/blink.cmp",

    dependencies = {
      "saghen/blink.lib",
      "rafamadriz/friendly-snippets",
      { "garyhurtz/blink_cmp_kitty", lazy = true },
      { "bydlw98/blink-cmp-env", lazy = true },
      { "moyiz/blink-emoji.nvim", lazy = true },
      "MahanRahmati/blink-nerdfont.nvim",
      -- { "alexandre-abrioux/blink-cmp-npm.nvim", lazy = true },
      -- { "phanen/blink-cmp-register", lazy = true },
      { "Kaiser-Yang/blink-cmp-git", lazy = true },
      -- { "disrupted/blink-cmp-conventional-commits", lazy = true },
      -- Dictionary completion for writing
      -- {
      --   "Kaiser-Yang/blink-cmp-dictionary",
      --   lazy = true,
      --   ft = { "markdown", "text", "tex", "rst", "org" },
      --   dependencies = { "nvim-lua/plenary.nvim" },
      --   config = function()
      --     local blink_dict = require("blink-cmp-dictionary")
      --     local dictionaries = {
      --       ["en"] = "/usr/share/dict/words",
      --     }
      --     blink_dict.new(dictionaries, {
      --       module = "blink-cmp-dictionary",
      --     })
      --   end,
      -- },
      -- { "ribru17/blink-cmp-spell", lazy = true },
      -- {
      --   "mgalliou/blink-cmp-tmux",
      --   lazy = true,
      --   cond = function()
      --     return vim.env.TMUX ~= nil
      --   end,
      -- },
      {
        "jdrupal-dev/css-vars.nvim",
        lazy = true,
        ft = { "css", "scss", "sass", "less", "stylus", "vue", "svelte", "html" },
      },
      { "erooke/blink-cmp-latex", lazy = true, ft = { "tex", "latex", "markdown" } },
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
      -- {
      --   "bydlw98/blink-cmp-sshconfig",
      --   lazy = true,
      --   ft = { "sshconfig", "ssh_config" },
      -- },
      -- Database completion (if using vim-dadbod)
      -- {
      --   "kristijanhusak/vim-dadbod-completion",
      --   lazy = true,
      --   ft = { "sql", "mysql", "plsql" },
      --   dependencies = {
      --     "tpope/vim-dadbod",
      --   },
      -- },
    },
    version = "1.*",
    -- branch = "v2",
    -- build = "cargo build --release",
    -- build = function()
    --   -- build the fuzzy matcher, wait up to 60 seconds
    --   -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
    --   require("blink.cmp").build():wait(60000)
    -- end,
    opts_extend = {
      "sources.default",
      "sources.per_filetype",
      "sources.compat",
    },
    ---@module "blink-cmp"
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
          Constructor = "󰒓",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "󰠱",
          Module = "󰅩",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "󰦨",
          Keyword = "󰌋",
          Snippet = "󱄽",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "󰦨",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "󱐋",
          Operator = "󰆕",
          TypeParameter = "󰬛",
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
          ---@type blink.cmp.Draw
          draw = {
            align_to = "label", -- or "none" to disable
            padding = 1,
            gap = 1,
            treesitter = { "lsp" },
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
                  local icon_gap = ctx.icon_gap or " "
                  if ctx.source_name == "Path" then
                    local is_unknown_type =
                      vim.tbl_contains({ "link", "socket", "fifo", "char", "block", "unknown" }, ctx.item.data.type)
                    local mini_icon, _ = require("mini.icons").get(
                      is_unknown_type and "os" or ctx.item.data.type,
                      is_unknown_type and "" or ctx.label
                    )
                    return (mini_icon or ctx.kind_icon or "") .. icon_gap
                  end

                  local micon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  if micon then
                    return micon .. icon_gap
                  end

                  local icon = require("lspkind").symbolic(ctx.kind)
                  return (icon or ctx.kind_icon or "") .. icon_gap
                end,
                highlight = function(ctx)
                  local _, mhl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return { { group = mhl or ctx.kind_hl, priority = 20000 } }
                end,
              },
              ---@type blink.cmp.DrawComponent
              kind = {
                ellipsis = false,
                width = { fill = true },
                text = function(ctx)
                  return ctx.kind or ""
                end,
                highlight = function(ctx)
                  local _, mhl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return { { group = mhl or ctx.kind_hl, priority = 20000 } }
                end,
              },
              ---@type blink.cmp.DrawComponent
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  return ctx.label .. (ctx.label_detail or "")
                end,
                highlight = function(ctx)
                  local highlights = {
                    { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                  }
                  if ctx.label_detail then
                    table.insert(
                      highlights,
                      { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                    )
                  end

                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end

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
            max_width = 80,
            max_height = 21,
            border = "rounded",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:Visual,Search:None",
            scrollbar = true,
            direction_priority = {
              menu_south = { "e", "w", "s", "n" },
              menu_north = { "w", "e", "n", "s" },
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
          max_width = 80,
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
        implementation = "prefer_rust_with_warning",
        use_proximity = true,
        -- frecency = true,
        sorts = { "exact", "score", "sort_text" },
        prebuilt_binaries = {
          download = true,
          force_version = nil,
        },
      },

      ---@type blink.cmp.SourceConfigPartial
      sources = {
        default = { "lsp", "path", "buffer", "snippets", "kitty", "ripgrep" },
        min_keyword_length = 0,
        per_filetype = {
          lua = { "lazydev", inherit_defaults = true },
          -- gitcommit = { "git", "conventional_commits", "spell", "emoji", inherit_defaults = true },
          gitrebase = { "git", inherit_defaults = true },
          gitconfig = { "git", inherit_defaults = true },
          markdown = { "lsp", "latex", "emoji", inherit_defaults = true },
          text = { "spell", "emoji", inherit_defaults = true },
          tex = { "latex", inherit_defaults = true },
          rst = { "spell", inherit_defaults = true },
          org = { "spell", inherit_defaults = true },
          javascript = { "lsp", inherit_defaults = true },
          typescript = { "lsp", inherit_defaults = true },
          json = { "lsp", inherit_defaults = true },
          css = { "lsp", "css_vars", inherit_defaults = true },
          scss = { "css_vars", inherit_defaults = true },
          sass = { "css_vars", inherit_defaults = true },
          less = { "css_vars", inherit_defaults = true },
          vue = { "css_vars", inherit_defaults = true },
          svelte = { "lsp", "css_vars", inherit_defaults = true },
          html = { "lsp", "css_vars", inherit_defaults = true },
          sql = { "lsp", "dadbod", inherit_defaults = true },
          mysql = { "lsp", "dadbod", inherit_defaults = true },
          plsql = { "lsp", "dadbod", inherit_defaults = true },
          sshconfig = { "lsp", "sshconfig", inherit_defaults = true },
          ssh_config = { "lsp", "sshconfig", inherit_defaults = true },
          -- cmdline = { "cmdline", "register", "env", inherit_defaults = true },
          sh = { "lsp", "cmdline", "register", "env", inherit_defaults = true },
          fish = { "lsp", "cmdline", "register", "env", inherit_defaults = true },
        },

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
            score_offset = 100,
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
              show_hidden_files_by_default = true,
            },
            score_offset = 3,
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            deduplicate = {},
            score_offset = 80,
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character"
            end,
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath("config") .. "/snippets" },
              global_snippets = { "all" },
              extended_filetypes = {
                typescript = { "typescriptreact", "javascriptreact" },
                javascript = { "javascriptreact" },
                typescriptreact = { "react", "html" },
                javascriptreact = { "react", "html" },
              },
              ignored_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            },
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            deduplicate = {},
            fallbacks = {},
            max_items = 8,
            min_keyword_length = 3,
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
          kitty = {
            name = "kitty",
            module = "blink_cmp_kitty",
            score_offset = 100,
          },
          cmdline = {
            name = "Cmdline",
            module = "blink.cmp.sources.cmdline",
            enabled = true,
            should_show_items = true,
            max_items = nil,
            min_keyword_length = 0,
            fallbacks = { "buffer", "env", "register" },
          },
          -- git = {
          --   name = "Git",
          --   module = "blink-cmp-git",
          --   score_offset = 2,
          -- },
          -- conventional_commits = {
          --   name = "Conventional Commits",
          --   module = "blink-cmp-conventional-commits",
          --   score_offset = 0,
          -- },
          -- env = {
          --   name = "Environment",
          --   module = "blink-cmp-env",
          --   score_offset = -2,
          -- },
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
          ripgrep = {
            name = "Ripgrep",
            module = "blink-ripgrep",
            score_offset = 0,
            max_items = 5,
            min_keyword_length = 4,
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
          -- spell = {
          --   name = "Spell",
          --   module = "blink-cmp-spell",
          --   score_offset = -6,
          -- },
          -- dictionary = {
          --   name = "Dictionary",
          --   module = "blink-cmp-dictionary",
          --   score_offset = -10,
          -- },
          -- npm = {
          --   name = "NPM",
          --   module = "blink-cmp-npm",
          --   score_offset = 3,
          --   min_keyword_length = 5,
          -- },
          -- dadbod = {
          --   name = "Database",
          --   module = "vim_dadbod_completion.blink",
          --   score_offset = 6,
          -- },
          -- Terminal and system sources
          -- tmux = {
          --   name = "Tmux",
          --   module = "blink-cmp-tmux",
          --   score_offset = -1,
          --   enabled = function()
          --     return vim.env.TMUX ~= nil
          --   end,
          -- },
          -- SSH configuration
          -- sshconfig = {
          --   name = "SSH Config",
          --   module = "blink-cmp-sshconfig",
          --   score_offset = -1,
          -- },
          -- Vim registers
          -- register = {
          --   name = "Register",
          --   module = "blink-cmp-register",
          --   score_offset = 3,
          -- },
        },
      },

      ---@type blink.cmp.CmdlineConfigPartial
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Tab>"] = { "show", "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline", "buffer" }
          end
          return {}
        end,
        completion = {
          list = { selection = { preselect = false } },
          menu = { auto_show = true },
          ghost_text = { enabled = true },
        },
      },
    },
  },
}
