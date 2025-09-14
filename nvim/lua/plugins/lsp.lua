return {
  {
    "mason-org/mason.nvim",
    version = false,
    lazy = false,
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        -- typescript
        "vtsls",
        "biome",
        "js-debug-adapter",
        "vue-language-server",
        -- html-htmx
        "html-lsp",
        "astro-language-server",
        -- css
        "css-lsp",
        "cssmodules-language-server",
        "css-variables-language-server",
        "unocss-language-server",
        "stylelint",
        -- C/C++
        "codelldb",
        "clangd",
        "clang-format",
        "cpptools",
        "cpplint",
        "cmakelang",
        "cmakelint",
        "slang",
        -- Go
        "gopls",
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "delve",
        -- Lua
        "lua-language-server",
        "stylua",
        -- Shell
        "shellcheck",
        "bash-language-server",
        "hyprls",
        "shfmt",
        -- utility
        "api-linter",
        "systemd-language-server",
        "systemdlint",
        -- "snyk",
        -- "snyk-ls",
        "gitleaks",
        -- Markdown
        -- "markdown-oxide",
        "marksman",
        "markdown-toc",
        "markdownlint-cli2",
        "mdx-analyzer",
        "tectonic",
        "texlab",
        -- Python
        "pyright",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    version = false,
    lazy = false,
    build = ":TSUpdate",
    opts = function(_, opts)
      opts.highlight = { enable = true }
      opts.indent = { enable = true }
      opts.ensure_installed = {
        "bash",
        "regex",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        -- "latex",
        "fish",
        "hyprlang",
        "diff",
        "json",
        "jsonc",
        "json5",
        "html",
        "c",
        "cpp",
        "lua",
        "luadoc",
        "luap",
        "rust",
        "ron",
        "javascript",
        "jsdoc",
        "typescript",
        "tsx",
        "astro",
        "css",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "xml",
        "yaml",
        "toml",
      }
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<S-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      }
      opts.textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      }
      local function add(lang)
        if type(opts.ensure_installed) == "table" then
          table.insert(opts.ensure_installed, lang)
        end
      end
      local function have(lang)
        if lang ~= "urmom" then
          return true
        end
      end

      vim.filetype.add({
        extension = {
          rasi = "rasi",
          rofi = "rasi",
          wofi = "rasi",
          qml = "qml",
          qmljs = "qml",
          qs = "qml",
          quickshell = "qml",
        },
        filename = {
          ["vifmrc"] = "vim",
        },
        pattern = {
          [".*/mako/config"] = "dosini",
          [".*/kitty/.+%.conf"] = "kitty",
          [".*/hypr/.+%.conf"] = "hyprlang",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      })
      vim.treesitter.language.register("bash", "kitty")

      add("git_config")

      if have("hypr") then
        add("hyprlang")
      end

      if have("fish") then
        add("fish")
      end

      if have("rofi") or have("wofi") then
        add("rasi")
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    enabled = true,
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      if LazyVim.is_loaded("nvim-treesitter") then
        local opts = LazyVim.opts("nvim-treesitter")
        local nts = require("nvim-treesitter.configs")
        nts.setup({
          textobjects = opts.textobjects,
        })
      end

      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = true,
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },
      },

      inlay_hints = {
        enabled = true,
      },

      servers = {
        bashls = {},
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params(nil, "utf-8")
                LazyVim.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                LazyVim.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              LazyVim.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              LazyVim.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              LazyVim.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1])
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        bacon_ls = {
          enabled = false,
          setup = {},
        },
        rust_analyzer = {
          enabled = false,
        },
        gopls = {
          setup = {},
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
        astro = {
          setup = {},
          settings = {},
        },
        marksman = {
          setup = {},
        },
        qmlls = {
          settings = {
            hint = {
              enable = false,
            },
          },
          init_options = {
            documentFormatting = false,
            documentLinting = false,
          },
          capabilities = {
            textDocumentSync = {
              change = 1,
              openClose = true,
              save = { includeText = true },
            },
          },
        },
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        lua_ls = {
          setup = {},
        },
        texlab = {
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
      setup = {
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable tsserver
          return true
        end,
        ---@type function|vim.lsp.Client
        vtsls = function(_, opts)
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
        qmlls = function(_, opts)
          require("lspconfig").qmlls.setup({
            on_attach = function(client, _)
              -- Ensure we keep formatting but handle document sync carefully
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentLintingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
              client.server_capabilities.documentRangeLintingProvider = false
            end,
            capabilities = opts.capabilities,
            settings = opts.settings,
            init_options = opts.init_options,
          })
          return true
        end,
        clangd = function(_, opts)
          local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          LazyVim.lsp.on_attach(function(client, _)
            if not client.server_capabilities.semanticTokensProvider then
              --- @type lsp.SemanticTokensClientCapabilities
              local semantic = client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end, "gopls")
          -- end workaround
        end,
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    enabled = true,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
        nls.builtins.diagnostics.biome,
        nls.builtins.diagnostics.clangd,
        nls.builtins.diagnostics.fish,
        nls.builtins.diagnostics.qmllint,
        nls.builtins.diagnostics.todo_comments,
        nls.builtins.formatting.biome,
        nls.builtins.formatting.clang_format,
        nls.builtins.formatting.dotenv_linter,
        nls.builtins.formatting.fish_indent,
        nls.builtins.formatting.gofmt,
        nls.builtins.formatting.gofumpt,
        nls.builtins.formatting.goimports,
        nls.builtins.formatting.golines,
        nls.builtins.formatting.markdownlint,
        nls.builtins.formatting.mdformat,
        -- nls.builtins.formatting.remark,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.shellharden,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.qmlformat,
      })
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    "wuelnerdotexe/vim-astro",
    lazy = true,
  },
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },
}
