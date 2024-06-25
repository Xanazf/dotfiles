return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
    },
  },
  -- your lsp config or other stuff
  opts = {
    diagnostics = {
      virtual_text = {
        spacing = 2,
      },
    },
    servers = {
      eslint = {
        rules = {
          customizations = {
            trailingCommas = "ignore",
          },
          trailingCommas = "ignore",
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
            format = { enable = true },
            validate = {
              enable = true,
              trailingCommas = "ignore",
            },
          },
        },
        filetypes = { "json", "jsonc" },
        init_options = {
          provideFormatter = true,
        },
      },
    },
  },
}
