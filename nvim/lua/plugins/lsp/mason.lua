---@class LSPHelpers
local helpers = require("plugins.lsp.helpers")
local h_tools = helpers.mason.tools
local h_servers = helpers.lsp.servers
local executable = helpers.checkexec

return {
  -- Mason.nvim v2.x configuration for LazyVim 15.x
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

      -- Add custom tools to LazyVim's defaults
      vim.list_extend(opts.ensure_installed, custom_tools)

      -- Auto-detect and install based on available tools
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

      -- Check for specific project types in current directory
      if vim.fn.glob("package.json") ~= "" or vim.fn.glob("*.vue") ~= "" then
        vim.list_extend(opts.ensure_installed, h_tools.web_extended)
      end

      if vim.fn.glob("*.tex") ~= "" then
        vim.list_extend(opts.ensure_installed, h_tools.latex)
      end

      -- Remove duplicates
      local seen = {}
      local unique_tools = {}
      for _, tool in ipairs(opts.ensure_installed) do
        if not seen[tool] then
          seen[tool] = true
          table.insert(unique_tools, tool)
        end
      end
      opts.ensure_installed = unique_tools

      return opts
    end,
  },

  -- Mason-LSPConfig v2.x configuration for LazyVim 15.x
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

        -- Handler configuration for automatic setup
        handlers = {
          -- Default handler for all servers
          function(server_name)
            local server_config = h_servers[server_name]
            if server_config then
              require("lspconfig")[server_name].setup(server_config)
            else
              -- Fallback to default setup for servers not in our config
              require("lspconfig")[server_name].setup({})
            end
          end,

          -- Custom handlers for specific servers
          ["lua_ls"] = function()
            local server_config = h_servers.lua_ls or {}
            require("lspconfig").lua_ls.setup(server_config)
          end,

          ["vtsls"] = function()
            local server_config = h_servers.vtsls or {}
            require("lspconfig").vtsls.setup(server_config)
          end,

          ["clangd"] = function()
            local server_config = h_servers.clangd
            if server_config then
              require("lspconfig").clangd.setup(server_config)
            end
          end,

          ["gopls"] = function()
            local server_config = h_servers.gopls
            if server_config then
              require("lspconfig").gopls.setup(server_config)
            end
          end,

          ["jsonls"] = function()
            local server_config = h_servers.jsonls or {}
            require("lspconfig").jsonls.setup(server_config)
          end,

          ["yamlls"] = function()
            local server_config = h_servers.yamlls or {}
            require("lspconfig").yamlls.setup(server_config)
          end,

          ["bashls"] = function()
            local server_config = h_servers.bashls or {}
            require("lspconfig").bashls.setup(server_config)
          end,

          ["marksman"] = function()
            local server_config = h_servers.marksman or {}
            require("lspconfig").marksman.setup(server_config)
          end,

          ["html"] = function()
            local server_config = h_servers.html or {}
            require("lspconfig").html.setup(server_config)
          end,

          ["cssls"] = function()
            local server_config = h_servers.cssls or {}
            require("lspconfig").cssls.setup(server_config)
          end,

          ["tailwindcss"] = function()
            local server_config = h_servers.tailwindcss or {}
            require("lspconfig").tailwindcss.setup(server_config)
          end,

          ["astro"] = function()
            local server_config = h_servers.astro or {}
            require("lspconfig").astro.setup(server_config)
          end,

          ["qmlls"] = function()
            local server_config = h_servers.qmlls or {}
            require("lspconfig").qmlls.setup(server_config)
          end,

          ["texlab"] = function()
            local server_config = h_servers.texlab or {}
            require("lspconfig").texlab.setup(server_config)
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
        "prettier",
        "prettierd",
        "eslint_d",
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
