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
      -- Extract LSP server names from our custom server configurations
      local function get_lsp_servers()
        local servers = {}
        for server_name, config in pairs(h_servers) do
          -- Only include enabled servers
          if config ~= nil and (config.enabled == nil or config.enabled ~= false) then
            table.insert(servers, server_name)
          end
        end
        return servers
      end

      -- Mason-LSPConfig v2.x configuration
      local mason_lspconfig_opts = {
        -- Automatically install LSP servers configured in our helpers
        ensure_installed = get_lsp_servers(),

        -- Automatically install servers when they're set up via lspconfig
        automatic_installation = {
          exclude = {
            -- Exclude servers that shouldn't be auto-installed
            "tsserver", -- We use vtsls instead
            "ts_ls", -- We use vtsls instead
          },
        },
      }

      -- Merge with LazyVim's defaults
      return vim.tbl_deep_extend("force", opts or {}, mason_lspconfig_opts)
    end,
  },

  -- Mason-Tool-Installer for additional tools (optional but recommended)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = function(_, opts)
      local tools_to_install = {}

      -- Add all tools from our helpers configuration
      for category, tools in pairs(h_tools) do
        if type(tools) == "table" then
          vim.list_extend(tools_to_install, tools)
        end
      end

      -- Add formatters and linters
      local additional_tools = {
        -- Formatters
        "prettier",
        -- "prettierd",
        -- "eslint_d",
        "stylua",
        "shfmt",
        "black",
        "isort",
        "rustfmt",
        "gofumpt",
        "goimports",

        -- Linters
        "shellcheck",
        "markdownlint",
        "yamllint",
        "jsonlint",

        -- Debuggers
        "codelldb",
        "delve",
        "debugpy",
      }

      vim.list_extend(tools_to_install, additional_tools)

      -- Remove duplicates
      local seen = {}
      local unique_tools = {}
      for _, tool in ipairs(tools_to_install) do
        if not seen[tool] then
          seen[tool] = true
          table.insert(unique_tools, tool)
        end
      end

      local mason_tool_installer_opts = {
        ensure_installed = unique_tools,
        auto_update = false,
        run_on_start = true,
        start_delay = 3000, -- 3 second delay
        debounce_hours = 5, -- at least 5 hours between attempts
      }

      return vim.tbl_deep_extend("force", opts or {}, mason_tool_installer_opts)
    end,
  },
}
