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

      opts.inlay_hints = vim.tbl_deep_extend("force", opts.inlay_hints or {}, {
        enabled = true,
        exclude = { "vue" }, -- exclude vue due to performance issues
      })

      opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
        workspace = {
          checkThirdParty = false,
          didChangeWatchedFiles = { dynamicRegistration = true },
          library = {
            vim.env.VIMRUNTIME,
            vim.fn.stdpath("data") .. "/lazy/fluoromachine.nvim",
          },
        },
        inlay_hints = {
          enabled = true,
        },
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
          completion = {
            callSnippet = "Replace",
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

      return opts
    end,
  },
}
