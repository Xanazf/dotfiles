---@class LSPHelpers
local helpers = require("plugins.lsp.helpers")
local h_lsp = helpers.lsp
local h_servers = h_lsp.servers

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "folke/lazydev.nvim" },
    opts = function(_, opts)
      -- Explicitly setup lazydev before any LSP servers start
      require("lazydev").setup({
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "LazyVim", words = { "LazyVim" } },
          { path = "snacks.nvim", words = { "Snacks" } },
          { path = "lazy.nvim", words = { "Lazy" } },
        },
      })

      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        underline = true,
        update_in_insert = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        float = {
          max_width = 80,
          border = "rounded",
          source = "always",
          wrap = true,
        },
      })
      opts.inlay_hints = vim.tbl_deep_extend("force", opts.inlay_hints or {}, {
        enabled = true,
      })

      -- Merge our custom servers with LazyVim defaults
      -- We put h_servers first so that opts.servers (LazyVim defaults) can overwrite/extend them
      opts.servers = vim.tbl_deep_extend("force", h_servers, opts.servers or {})

      opts.setup = vim.tbl_deep_extend("force", opts.setup or {}, {
        clangd = function(_, server_opts)
          local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(
            vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = server_opts })
          )
          -- Return false to let LazyVim/lspconfig handle the actual server setup
          return false
        end,
      })

      return opts
    end,
  },
  { "wuelnerdotexe/vim-astro" },
}
