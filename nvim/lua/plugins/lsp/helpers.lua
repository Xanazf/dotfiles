-- helper functions for LSP, Mason, and Treesitter
---@class LSPHelpers
---@field checkexec function<boolean>
local M = {}

---@alias LSPHelpers.treesitter table
M.treesitter = {}

---@alias LSPHelpers.treesitter.opts table
M.treesitter.opts = {}

---@alias LSPHelpers.lsp PluginLspOpts
M.lsp = {}

-- Setup functions for servers
M.lsp.setup = {}

---@alias LSPHelpers.mason table
M.mason = {}

-- check if executable exists
---@param name string
---@return boolean
M.checkexec = function(name)
  return vim.fn.executable(name) == 1
end

-- NOTE: The old treesitter.add function is no longer needed with the new API
-- Parsers are now installed directly with require('nvim-treesitter').install()

-- Conditional server setup for lsp
M.lsp.servers = {
  bashls = {
    enabled = true,
  },
  -- Explicitly disable tsserver and ts_ls
  tsserver = {
    enabled = false,
  },
  ts_ls = {
    enabled = false,
  },
  -- TypeScript/JavaScript
  vtsls = {
    -- explicitly add default filetypes, so that we can extend
    -- them in related extras
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    keys = {
      {
        "gD",
        function()
          local params = vim.lsp.util.make_position_params(nil, "utf-8")
          LazyVim.lsp.execute({
            command = "typescript.goToSourceDefinition",
            arguments = { params.textDocument.uri, params.position },
            open = true,
          })
        end,
        desc = "Goto Source Definition",
      },
      {
        "gR",
        function()
          LazyVim.lsp.execute({
            command = "typescript.findAllFileReferences",
            arguments = { vim.uri_from_bufnr(0) },
            open = true,
          })
        end,
        desc = "File References",
      },
      { "<leader>co", LazyVim.lsp.action["source.organizeImports"], desc = "Organize Imports" },
      { "<leader>cM", LazyVim.lsp.action["source.addMissingImports.ts"], desc = "Add missing imports" },
      { "<leader>cu", LazyVim.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
      { "<leader>cD", LazyVim.lsp.action["source.fixAll.ts"], desc = "Fix all diagnostics" },
      {
        "<leader>cV",
        function()
          LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
        end,
        desc = "Select TS workspace version",
      },
    },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
  },

  -- C/C++
  clangd = M.checkexec("clangd")
      and {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        capabilities = { offsetEncoding = { "utf-16" } },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        keys = {
          {
            "<leader>ch",
            "<cmd>ClangdSwitchSourceHeader<cr>",
            desc = "Switch Source/Header (C/C++)",
          },
        },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
          )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
            fname
          ) or vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
        end,
      }
    or nil,

  -- Go (only if gopls is available)
  gopls = M.checkexec("gopls") and {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  } or nil,
  qmlls = {
    settings = {
      hint = {
        enabled = false,
      },
    },
    init_options = {
      documentFormatting = false,
      documentLinting = false,
    },
    capabilities = {
      textDocumentSync = {
        change = 1,
        openClose = true,
        save = { includeText = true },
      },
    },
  },

  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        codeLens = {
          enabled = true,
        },
        completion = {
          callSnippet = "Replace",
        },
        doc = {
          privateName = { "^_" },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
      },
    },
  },

  -- json
  jsonls = {
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = {
          enabled = false,
        },
        validate = { enable = true },
      },
    },
  },

  -- Web servers
  html = { settings = {} },
  cssls = { settings = {} },
  
  -- YAML
  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false,
        format = {
          enable = true,
        },
        validate = true,
        schemaStore = {
          enable = false,
          url = "",
        },
      },
    },
  },

  -- web_extra
  astro = { settings = {} },
  tailwindcss = {
    filetypes_exclude = { "markdown" },
    filetypes_include = {},
  },

  -- markdown
  marksman = { settings = {} },
  texlab = {
    keys = {
      { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
    },
  },

  -- rust
  bacon_ls = { enabled = false },
  rust_analyzer = { enabled = false },
}

-- Parser groups for conditional installation
---@alias LSPHelpers.treesitter.parsers table
M.treesitter.parsers = {
  web = { "html", "css", "javascript", "jsdoc", "typescript", "tsx" },
  web_extra = { "astro", "vue", "svelte" },
  systems = { "c", "cpp", "rust", "ron", "go", "gomod", "gowork", "gosum" },
  shell = { "fish", "hyprlang" },
  markup = { "xml", "yaml", "toml" },
}

-- Text object configuration (for manual setup with new treesitter)
---@alias LSPHelpers.treesitter.textobjects table
M.treesitter.opts.textobjects = {
  select = {
    enable = true,
    lookahead = true,
    keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
    },
  },
  move = {
    enable = true,
    set_jumps = true,
    goto_next_start = {
      ["]f"] = "@function.outer",
      ["]c"] = "@class.outer",
      ["]a"] = "@parameter.inner",
    },
    goto_next_end = {
      ["]F"] = "@function.outer",
      ["]C"] = "@class.outer",
      ["]A"] = "@parameter.inner",
    },
    goto_previous_start = {
      ["[f"] = "@function.outer",
      ["[c"] = "@class.outer",
      ["[a"] = "@parameter.inner",
    },
    goto_previous_end = {
      ["[F"] = "@function.outer",
      ["[C"] = "@class.outer",
      ["[A"] = "@parameter.inner",
    },
  },
}

-- Conditional mason tools
M.mason.tools = {
  -- C/C++
  cpp = {
    "clangd",
    "clang-format",
    "codelldb", -- debugger
  },

  -- Go
  go = {
    "gopls",
    "goimports",
    "gofumpt",
    "gomodifytags",
    "impl",
    "delve", -- debugger
  },

  -- Python
  python = {
    "pyright",
    "black", -- formatter
    "isort", -- import sorter
  },

  -- Rust
  rust = {
    "rust-analyzer",
    "rustfmt",
  },

  -- Web tools
  web_extended = {
    "vue-language-server",
    "astro-language-server",
    "cssmodules-language-server",
    "css-variables-language-server",
    "unocss-language-server",
    "stylelint",
  },

  -- System administration
  sysadmin = {
    "hyprls",
    "systemd-language-server",
    "systemdlint",
  },

  -- LaTeX
  latex = {
    "texlab",
    "tectonic",
  },
}

-- Custom filetype associations
vim.filetype.add({
  extension = {
    rasi = "rasi",
    rofi = "rasi",
    wofi = "rasi",
    qml = "qml",
    qmljs = "qml",
  },
  filename = { ["vifmrc"] = "vim" },
  pattern = {
    [".*/mako/config"] = "dosini",
    [".*/kitty/.+%.conf"] = "kitty",
    [".*/hypr/.+%.conf"] = "hyprlang",
    ["%.env%.[%w_.-]+"] = "sh",
  },
})

-- Register language mappings
vim.treesitter.language.register("bash", "kitty")

return M