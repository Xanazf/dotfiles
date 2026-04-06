---@class LSPHelpers
local helpers = require("plugins.lsp.helpers")
local h_tools = helpers.mason.tools
local h_servers = helpers.lsp.servers
local executable = helpers.checkexec

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Start with LazyVim's default ensure_installed
      opts.ensure_installed = opts.ensure_installed or {}

      local custom_tools = {
        -- Core tools that should always be available
        "lua-language-server",
        "stylua",

        -- TypeScript/JavaScript
        "vtsls",
        "biome",

        -- Web
        "html-lsp",
        "css-lsp",

        -- Shell
        "bash-language-server",
        "shellcheck",
        "shfmt",

        -- Markdown
        "marksman",
        "markdownlint-cli2",

        -- JSON
        "json-lsp",

        -- YAML
        "yaml-language-server",
      }

      -- custom tools
      vim.list_extend(opts.ensure_installed, custom_tools)

      -- auto-detect and install
      if executable("go") then
        vim.list_extend(opts.ensure_installed, h_tools.go)
      end

      if executable("python") or executable("python3") then
        vim.list_extend(opts.ensure_installed, h_tools.python)
      end

      if executable("cargo") then
        vim.list_extend(opts.ensure_installed, h_tools.rust)
      end

      if executable("gcc") or executable("clang") then
        vim.list_extend(opts.ensure_installed, h_tools.cpp)
      end

      -- check for specific project types in cwd
      if vim.fn.glob("package.json") ~= "" or vim.fn.glob("*.vue") ~= "" then
        vim.list_extend(opts.ensure_installed, h_tools.web_extended)
      end

      if vim.fn.glob("*.tex") ~= "" then
        vim.list_extend(opts.ensure_installed, h_tools.latex)
      end

      return opts
    end,
  },

  -- Mason-LSPConfig v2.x configuration for LazyVim 15.x
  ---@module "mason-lspconfig"
  ---@type MasonLspconfigSettings
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for server_name, config in pairs(h_servers) do
        -- Only include enabled servers
        if config ~= nil and (config.enabled == nil or config.enabled ~= false) then
          if not vim.tbl_contains(opts.ensure_installed, server_name) then
            table.insert(opts.ensure_installed, server_name)
          end
        end
      end

      -- Exclude servers that shouldn't be auto-installed
      opts.automatic_installation = opts.automatic_installation or {}
      if type(opts.automatic_installation) == "table" then
        opts.automatic_installation.exclude = vim.list_extend(
          opts.automatic_installation.exclude or {},
          { "tsserver", "ts_ls" }
        )
      end

      return opts
    end,
  },

  -- Mason-Tool-Installer for additional tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = function(_, opts)
      local tools_to_install = {
        -- Core
        "stylua",
        "shfmt",
        "shellcheck",
        -- Web
        "prettier",
        "biome",
        -- Python
        "black",
        "isort",
        -- Markdown
        "markdownlint-cli2",
        -- Debuggers
        "codelldb",
      }

      -- Add tools from helpers
      for _, tools in pairs(h_tools) do
        if type(tools) == "table" then
          vim.list_extend(tools_to_install, tools)
        end
      end

      return vim.tbl_deep_extend("force", opts or {}, {
        ensure_installed = tools_to_install,
        auto_update = true,
        run_on_start = true,
      })
    end,
  },
}
