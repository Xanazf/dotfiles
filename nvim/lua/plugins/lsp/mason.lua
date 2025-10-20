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

        handlers = {
          -- Default handler for all servers
          function(server_name)
            local server_config = h_servers[server_name]
            if server_config then
              vim.lsp.config(server_name, server_config)
              vim.lsp.enable(server_name)
            end
          end,

          ["lua_ls"] = function()
            local server_config = h_servers.lua_ls or {}
            vim.lsp.config("lua_ls", server_config)
            vim.lsp.enable("lua_ls")
          end,

          ["vtsls"] = function()
            local server_config = h_servers.vtsls or {}
            vim.lsp.config("vtsls", server_config)
            vim.lsp.enable("vtsls")
          end,

          ["clangd"] = function()
            local server_config = h_servers.clangd
            if server_config then
              vim.lsp.config("clangd", server_config)
              vim.lsp.enable("clangd")
            end
          end,

          ["gopls"] = function()
            local server_config = h_servers.gopls
            if server_config then
              vim.lsp.config("gopls", server_config)
              vim.lsp.enable("gopls")
            end
          end,

          ["jsonls"] = function()
            local server_config = h_servers.jsonls or {}
            vim.lsp.config("jsonls", server_config)
            vim.lsp.enable("jsonls")
          end,

          ["yamlls"] = function()
            local server_config = h_servers.yamlls or {}
            vim.lsp.config("yamlls", server_config)
            vim.lsp.enable("yamlls")
          end,

          ["bashls"] = function()
            local server_config = h_servers.bashls or {}
            vim.lsp.config("bashls", server_config)
            vim.lsp.enable("bashls")
          end,

          ["marksman"] = function()
            local server_config = h_servers.marksman or {}
            vim.lsp.config("marksman", server_config)
            vim.lsp.enable("marksman")
          end,

          ["html"] = function()
            local server_config = h_servers.html or {}
            vim.lsp.config("html", server_config)
            vim.lsp.enable("html")
          end,

          ["cssls"] = function()
            local server_config = h_servers.cssls or {}
            vim.lsp.config("cssls", server_config)
            vim.lsp.enable("cssls")
          end,

          ["tailwindcss"] = function()
            local server_config = h_servers.tailwindcss or {}
            vim.lsp.config("tailwindcss", server_config)
            vim.lsp.enable("tailwindcss")
          end,

          ["astro"] = function()
            local server_config = h_servers.astro or {}
            vim.lsp.config("astro", server_config)
            vim.lsp.enable("astro")
          end,

          ["qmlls"] = function()
            local server_config = h_servers.qmlls or {}
            vim.lsp.config("qmlls", server_config)
            vim.lsp.enable("qmlls")
          end,
          ["qmljs"] = function()
            local server_config = h_servers.qmlls or {}
            vim.lsp.config("qmljs", server_config)
            vim.lsp.enable("qmljs")
          end,

          ["texlab"] = function()
            local server_config = h_servers.texlab or {}
            vim.lsp.config("texlab", server_config)
            vim.lsp.enable("taxlab")
          end,

          -- Explicitly disable servers we don't want
          ["tsserver"] = function() end, -- Disabled - we use vtsls
          ["ts_ls"] = function() end, -- Disabled - we use vtsls
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
        -- "prettier",
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
