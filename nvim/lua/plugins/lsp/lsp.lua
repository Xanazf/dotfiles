---@class LSPHelpers
local helpers = require("plugins.lsp.helpers")
local h_lsp = helpers.lsp
local h_servers = h_lsp.servers

return {
  ---@module "lspconfig"
  {
    "neovim/nvim-lspconfig",
    version = false,
    ---@param opts PluginLspOpts
    opts = function(_, opts)
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        underline = true,
        update_in_insert = true,
        virtual_text = {
          spacing = 2,
          prefix = "●",
          source = "if_many",
        },
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      })

      -- Merge inlay hints with LazyVim defaults (Neovim 11.0+ enhanced)
      opts.inlay_hints = vim.tbl_deep_extend("force", opts.inlay_hints or {}, {
        enabled = true,
        exclude = { "vue" }, -- exclude vue due to performance issues
      })

      -- Enhanced capabilities for Neovim 11.0+
      opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
          completion = {
            completionItem = {
              documentationFormat = { "markdown", "plaintext" },
              snippetSupport = true,
              preselectSupport = true,
              insertReplaceSupport = true,
              labelDetailsSupport = true,
              deprecatedSupport = true,
              commitCharactersSupport = true,
              tagSupport = { valueSet = { 1 } },
              resolveSupport = {
                properties = {
                  "documentation",
                  "detail",
                  "additionalTextEdits",
                },
              },
            },
          },
        },
      })

      -- Merge servers with LazyVim defaults
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, h_servers)

      -- Enhanced setup functions for Neovim 11.0+
      local custom_setup = {
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable ts_ls
          return true
        end,
        vtsls = function(_, server_opts)
          -- Enhanced vtsls setup for Neovim 11.0+
          server_opts.settings = server_opts.settings or {}

          -- Copy typescript settings to javascript
          server_opts.settings.javascript = vim.tbl_deep_extend(
            "force",
            {},
            server_opts.settings.typescript or {},
            server_opts.settings.javascript or {}
          )

          -- Enhanced capabilities for Neovim 11.0+
          server_opts.capabilities = vim.tbl_deep_extend("force", server_opts.capabilities or {}, {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                },
              },
            },
          })
        end,
        qmlls = function(_, server_opts)
          server_opts.on_attach = function(client, bufnr)
            -- Disable formatting to avoid conflicts with conform.nvim
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            if client.server_capabilities.semanticTokensProvider then
              vim.lsp.semantic_tokens.enable(true, {
                bufnr = bufnr,
                client_id = client.id,
              })
            end
          end
        end,
        clangd = function(_, server_opts)
          -- Enhanced clangd setup for Neovim 11.0+
          server_opts.capabilities = vim.tbl_deep_extend("force", server_opts.capabilities or {}, {
            offsetEncoding = { "utf-16" },
            textDocument = {
              completion = {
                editsNearCursor = true,
              },
            },
          })

          local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, {
            server = server_opts,
            extensions = {
              -- Enhanced for Neovim 11.0+
              autoSetHints = true,
              inlay_hints = {
                inline = vim.fn.has("nvim-0.10") == 1,
                only_current_line = false,
                only_current_line_autocmd = "CursorHold",
                show_parameter_hints = true,
                parameter_hints_prefix = "<- ",
                other_hints_prefix = "=> ",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
                priority = 100,
              },
            },
          }))
          return false
        end,
        gopls = function(_, server_opts)
          -- Enhanced gopls setup for Neovim 11.0+
          server_opts.on_attach = function(client, bufnr)
            -- Enhanced semantic tokens support for Neovim 11.0+
            if not client.server_capabilities.semanticTokensProvider then
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

            -- Enable semantic tokens for Neovim 11.0+
            -- if client.server_capabilities.semanticTokensProvider then
            -- end
          end

          -- Enhanced capabilities
          server_opts.capabilities = vim.tbl_deep_extend("force", server_opts.capabilities or {}, {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                },
              },
            },
          })
        end,
        lua_ls = function(_, server_opts) end,
        tailwindcss = function(_, server_opts)
          server_opts.filetypes = server_opts.filetypes or {}
          server_opts.filetypes_exclude = server_opts.filetypes_exclude or {}
          server_opts.filetypes_include = server_opts.filetypes_include or {}

          -- Add default filetypes (safe fallback)
          local default_filetypes = {
            "css",
            "scss",
            "sass",
            "postcss",
            "html",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "astro",
          }
          vim.list_extend(server_opts.filetypes, default_filetypes)

          -- Remove excluded filetypes
          server_opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(server_opts.filetypes_exclude or {}, ft)
          end, server_opts.filetypes)

          -- Enhanced settings for Neovim 11.0+
          server_opts.settings = server_opts.settings or {}
          server_opts.settings.tailwindCSS = vim.tbl_deep_extend("force", server_opts.settings.tailwindCSS or {}, {
            includeLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
              astro = "html",
              vue = "html",
              svelte = "html",
            },
            experimental = {
              classRegex = {
                "tw`([^`]*)",
                'tw="([^"]*)',
                'tw={"([^"}]*)',
                "tw\\.\\w+`([^`]*)",
                "tw\\(.*?\\)`([^`]*)",
              },
            },
          })

          -- Add additional filetypes
          vim.list_extend(server_opts.filetypes, server_opts.filetypes_include or {})

          -- Enhanced capabilities for Neovim 11.0+
          server_opts.capabilities = vim.tbl_deep_extend("force", server_opts.capabilities or {}, {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                },
              },
              colorProvider = true,
            },
          })
        end,
        jsonls = function(_, server_opts)
          server_opts.on_attach = function(client, bufnr)
            if client.server_capabilities.semanticTokensProvider then
              vim.lsp.semantic_tokens.enable(true, {
                bufnr = bufnr,
                client_id = client.id,
              })
            end
          end
        end,
        yamlls = function(_, server_opts)
          -- Enhanced YAML-LS setup for Neovim 11.0+
          server_opts.capabilities = vim.tbl_deep_extend("force", server_opts.capabilities or {}, {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          })
        end,
      }

      -- Merge custom setup with LazyVim's existing setup
      opts.setup = vim.tbl_deep_extend("force", opts.setup or {}, custom_setup)

      return opts
    end,
  },
}
