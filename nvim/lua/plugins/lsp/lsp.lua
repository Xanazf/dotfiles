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
        update_in_insert = true,
        virtual_text = {
          spacing = 2,
        },
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      opts.inlay_hints = vim.tbl_deep_extend("force", opts.inlay_hints or {}, {
        enabled = true,
        exclude = { "vue" }, -- exclude vue due to performance issues
      })

      -- Merge servers with LazyVim defaults
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, h_servers)

      return opts
    end,
  },
  { "wuelnerdotexe/vim-astro" },
}
