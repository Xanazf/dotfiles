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
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        inlay_hints = {
          inline = false,
        },
        ast = {
          --These require codicons (https://github.com/microsoft/vscode-codicons)
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
        },
      })
    end,
  },

  -- Extend none-ls configuration (if LazyVim uses it)
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

      -- Merge our sources with existing ones
      local custom_sources = {
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
        nls.builtins.diagnostics.biome,
        -- clang diagnostics are provided by clangd LSP, not null-ls
        nls.builtins.diagnostics.fish,
        nls.builtins.diagnostics.dotenv_linter,
        nls.builtins.diagnostics.qmllint,
        nls.builtins.diagnostics.todo_comments,
        nls.builtins.formatting.biome,
        nls.builtins.formatting.clang_format,
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
      }

      opts.sources = vim.list_extend(opts.sources or {}, custom_sources)
      return opts
    end,
  },

  -- Extend LazyVim's lazydev configuration
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "LazyVim", words = { "LazyVim" } },
          { path = "snacks.nvim", words = { "Snacks" } },
          { path = "lazy.nvim", words = { "Lazy" } },
        },
      })
    end,
  },
}

