---@class LSPHelpers
local helpers = require("plugins.lsp.helpers")
local h_lsp = helpers.lsp
local h_servers = h_lsp.servers

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      },
      inlay_hints = {
        enabled = true,
      },
      -- Merge servers with LazyVim defaults
      opts_extend = { "servers" },
      servers = h_servers,
    },
  },
  { "wuelnerdotexe/vim-astro" },
}
