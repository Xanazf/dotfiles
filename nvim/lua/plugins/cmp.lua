---@type LazySpec
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

  -- Enhanced blink.cmp configuration with all sources
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  {
    "saghen/blink.cmp",
    version = "1.*",
    build = "cargo build --release",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- Optional: for better LSP integration
      {
        "saghen/blink.compat",
        optional = true,
        opts = {},
      },
      { "bydlw98/blink-cmp-env", lazy = true },
      { "moyiz/blink-emoji.nvim", lazy = true, optional = true },
      "MahanRahmati/blink-nerdfont.nvim",
      { "alexandre-abrioux/blink-cmp-npm.nvim", lazy = true },
      { "phanen/blink-cmp-register", lazy = true },
      { "Kaiser-Yang/blink-cmp-git", lazy = true },
      { "disrupted/blink-cmp-conventional-commits", lazy = true, optional = true },
      -- Dictionary completion for writing
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        lazy = true,
        optional = true,
        ft = { "markdown", "text", "tex", "rst", "org" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
          dictionaries = {
            ["en"] = "/usr/share/dict/words",
          },
        },
      },
      { "ribru17/blink-cmp-spell", lazy = true, optional = true },
      {
        "mgalliou/blink-cmp-tmux",
        lazy = true,
        cond = function()
          return vim.env.TMUX ~= nil
        end,
      },
      {
        "junkblocker/blink-cmp-wezterm",
        lazy = true,
        cond = function()
          return vim.env.WEZTERM_EXECUTABLE ~= nil
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
      ---@type blink.cmp.CompletionMenuConfigPartial
      menu = {
        enabled = true,
        min_width = 15,
        max_height = 10,
        border = "rounded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        scrollbar = true,
        direction_priority = { "s", "n" },
        auto_show = true,

        draw = {
          align_to_component = "label", -- or "none" to disable
          padding = 1,
          gap = 1,
          treesitter = { "lsp" },
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            label = {
              width = { fill = true, max = 60 },
              text = function(ctx)
                return ctx.label .. ctx.label_detail
              end,
              highlight = function(ctx)
                -- Label highlighting based on item kind
                local highlights = {
                  BlinkCmpLabelMatch = { 1, #ctx.label },
                }
                return highlights
              end,
            },
            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_description
              end,
              highlight = "BlinkCmpLabelDescription",
            },
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
        auto_show_delay_ms = 200,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = {
          min_width = 10,
          max_width = 60,
          max_height = 20,
          border = "rounded",
          winblend = 0,
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:Visual,Search:None",
          scrollbar = true,
          direction_priority = { "e", "w", "n", "s" },
        },
      },

      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
      list = {
        max_items = 200,
        selection = "preselect",
        cycle = {
          from_bottom = true,
          from_top = true,
        },
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
    fuzzy = {
      prefer_rust = true,
      use_typo_resistance = true,
      use_frecency = true,
      use_proximity = true,
      max_items = 200,
      sorts = { "label", "kind", "score" },
      prebuilt_binaries = {
        download = true,
        force_version = nil,
      },
    },

    ---@type blink.cmp.SourceList
    sources = {
      default = function(ctx)
        local success, node = pcall(vim.treesitter.get_node)
        if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
          return { "buffer", "snippets" }
        elseif vim.bo.filetype == "lua" then
          return { "lazydev", "lsp", "path", "snippets", "buffer" }
        elseif vim.bo.filetype == "gitcommit" then
          return { "buffer" }
        else
          return { "lsp", "path", "snippets", "buffer" }
        end
      end,
      per_filetype = {
        lua = { "lazydev", "lsp", "path", "snippets", "buffer" },
        gitcommit = { "buffer" },
        markdown = { "buffer", "snippets" },
      },

      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          enabled = true,
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                item.score_offset = item.score_offset and item.score_offset - 3 or -3
              end
            end
            return items
          end,
          should_show_items = true,
          max_items = nil,
          min_keyword_length = 0,
          fallbacks = { "buffer" },
          score_offset = 0,
          deduplicate = {
            enabled = true,
            priority = 500,
          },
          override = nil,
        },

        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 3,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = false,
          },
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = -3,
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
          fallbacks = { "lsp" },
          score_offset = -3,
          opts = {
            get_bufnrs = function()
              return vim.tbl_filter(function(buf)
                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                return byte_size and byte_size < 1024 * 1024 -- 1MB limit
              end, vim.api.nvim_list_bufs())
            end,
          },
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
          transform_items = function(_, items)
            -- Enhanced cmdline item transformation
            return items
          end,
          should_show_items = true,
          max_items = nil,
          min_keyword_length = 2,
          fallbacks = {},
          score_offset = 0,
          deduplicate = {
            enabled = true,
            priority = 500,
          },
        },
      },
    },

    ---@type blink.cmp.CmdlineConfigPartial
    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      completion = {
        list = { selection = { preselect = false } },
        menu = {
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ":"
          end,
        },
        ghost_text = { enabled = true },
        keymap = {
          preset = "enter",
          ["<C-y>"] = { "select_and_accept" },
        },
      },
      transform_items = function(_, items)
        -- Enhanced cmdline transformation
        return items
      end,
      should_show_items = true,
      max_items = nil,
      min_keyword_length = 2,
      fallbacks = {},
      score_offset = 0,
      deduplicate = {
        enabled = true,
        priority = 500,
      },
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        elseif type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
    },
    ---@type blink.cmp.SnippetsConfigPartial
    snippets = {
      expand = function(snippet)
        return LazyVim.cmp.expand(snippet)
      end,
      active = function(filter)
        return LazyVim.cmp.active(filter)
      end,
      jump = function(direction)
        return LazyVim.cmp.jump(direction)
      end,
    },

    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },

    opts = function(_, opts) ---@type blink.cmp.Config|function
      local enhanced_sources = {
        default = function(ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "buffer", "snippets", "spell", "dictionary" }
          elseif vim.bo.filetype == "lua" then
            return { "lazydev", "lsp", "path", "snippets", "buffer" }
          elseif vim.bo.filetype == "gitcommit" then
            return { "git", "conventional_commits", "buffer", "spell", "emoji" }
          elseif vim.tbl_contains({ "markdown", "text", "tex", "rst", "org" }, vim.bo.filetype) then
            return { "lsp", "path", "snippets", "buffer", "spell", "dictionary", "latex", "emoji" }
          elseif vim.tbl_contains({ "javascript", "typescript", "json" }, vim.bo.filetype) then
            return { "lsp", "path", "snippets", "buffer", "npm" }
          elseif vim.tbl_contains({ "css", "scss", "sass", "less", "vue", "svelte", "html" }, vim.bo.filetype) then
            return { "lsp", "path", "snippets", "buffer", "css_vars" }
          elseif vim.tbl_contains({ "sql", "mysql", "plsql" }, vim.bo.filetype) then
            return { "lsp", "dadbod", "buffer" }
          else
            return { "lsp", "path", "snippets", "buffer", "env" }
          end
        end,

        per_filetype = {
          lua = { "lazydev", "lsp", "path", "snippets", "buffer" },
          gitcommit = { "git", "conventional_commits", "buffer", "spell", "emoji" },
          gitrebase = { "git", "buffer" },
          gitconfig = { "git", "buffer" },
          markdown = { "lsp", "path", "snippets", "buffer", "spell", "dictionary", "latex", "emoji" },
          text = { "buffer", "spell", "dictionary", "emoji" },
          tex = { "lsp", "path", "snippets", "buffer", "latex", "spell", "dictionary" },
          rst = { "lsp", "path", "snippets", "buffer", "spell", "dictionary" },
          org = { "lsp", "path", "snippets", "buffer", "spell", "dictionary" },
          javascript = { "lsp", "path", "snippets", "buffer", "npm" },
          typescript = { "lsp", "path", "snippets", "buffer", "npm" },
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
        },

        providers = vim.tbl_deep_extend("force", opts.sources.providers or {}, {
          -- Git-related sources
          git = {
            name = "Git",
            module = "blink-cmp-git",
            score_offset = 5,
          },

          conventional_commits = {
            name = "Conventional Commits",
            module = "blink-cmp-conventional-commits",
            score_offset = 10,
          },

          -- Environment and system sources
          env = {
            name = "Environment",
            module = "blink-cmp-env",
            score_offset = -2,
          },

          -- Text enhancement sources
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
            score_offset = -3,
          },

          dictionary = {
            name = "Dictionary",
            module = "blink-cmp-dictionary",
            score_offset = -8,
            opts = {
              dictionaries = {
                ["en"] = "/usr/share/dict/words",
              },
            },
          },

          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            score_offset = -6,
          },

          -- Development sources
          npm = {
            name = "NPM",
            module = "blink-cmp-npm",
            score_offset = 3,
          },

          css_vars = {
            name = "CSS Variables",
            module = "css-vars",
            score_offset = 2,
          },

          latex = {
            name = "LaTeX",
            module = "blink-cmp-latex",
            score_offset = 1,
          },

          -- Database sources
          dadbod = {
            name = "Database",
            module = "vim_dadbod_completion.blink",
            score_offset = 8,
          },

          -- Search and navigation sources
          ripgrep = {
            name = "Ripgrep",
            module = "blink-ripgrep",
            score_offset = -4,
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

          wezterm = {
            name = "WezTerm",
            module = "blink-cmp-wezterm",
            score_offset = -1,
            enabled = function()
              return vim.env.WEZTERM_EXECUTABLE ~= nil
            end,
          },

          -- SSH configuration
          sshconfig = {
            name = "SSH Config",
            module = "blink-cmp-sshconfig",
            score_offset = 4,
          },

          -- Vim registers
          register = {
            name = "Register",
            module = "blink-cmp-register",
            score_offset = -7,
          },
        }),
      }

      -- Merge enhanced sources with existing configuration
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, enhanced_sources)
      opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, LazyVim.config.icons.kinds)

      return opts
    end,
  },
}
