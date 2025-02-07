return {
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

    --- LSP Server Settings
    ---@type lspconfig.options
    servers = {
      biome = {
        settings = {},
      },
      astro = {
        settings = {},
      },
      marksman = {},
      qmlls = {
        settings = {},
        init_options = {
          documentFormatting = false,
        },
        capabilities = {
          textDocumentSync = {
            change = 1,
            openClose = true,
            save = { includeText = true },
          },
        },
      },
    },
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
      qmlls = function(_, opts)
        require("lspconfig").qmlls.setup({
          on_attach = function(client, bufnr)
            -- Ensure we keep formatting but handle document sync carefully
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          capabilities = opts.capabilities,
          settings = opts.settings,
          init_options = opts.init_options,
        })
        return true
      end,
    },
  },
}
