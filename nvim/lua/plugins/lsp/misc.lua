return {
  -- Extend LazyVim's SchemaStore configuration
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- Add Astro support
  {
    "wuelnerdotexe/vim-astro",
    lazy = true,
    ft = "astro",
  },

  -- Extend LazyVim's VimTeX configuration
  {
    "lervag/vimtex",
    enabled = false,
    lazy = false, -- lazy-loading will disable inverse search
    ft = { "tex", "plaintex", "bib" },
    config = function()
      -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    end,
    keys = {
      { "<localleader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },

  -- Extend LazyVim's clangd_extensions configuration
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        inlay_hints = {
          inline = false,
        },
        ast = {
          --These require codicons (https://github.com/microsoft/vscode-codicons)
          -- role_icons = {
          --   type = "",
          --   declaration = "",
          --   expression = "",
          --   specifier = "",
          --   statement = "",
          --   ["template argument"] = "",
          -- },
          -- kind_icons = {
          --   Compound = "",
          --   Recovery = "",
          --   TranslationUnit = "",
          --   PackExpansion = "",
          --   TemplateTypeParm = "",
          --   TemplateTemplateParm = "",
          --   TemplateParamObject = "",
          -- },
        },
      })
    end,
  },
}
