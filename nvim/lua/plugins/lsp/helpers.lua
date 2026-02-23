local function get_typescript_server_path(root_dir)
  local project_root = root_dir or vim.fn.getcwd()
  local yarn_sdk = vim.fs.joinpath(project_root, ".yarn/sdks/typescript/lib")
  if vim.uv.fs_stat(yarn_sdk) then
    return yarn_sdk
  end

  -- Fallback to mason installed version if available
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages/vtsls/node_modules/typescript/lib"
  if vim.uv.fs_stat(mason_path) then
    return mason_path
  end
  return nil
end

-- helper functions for LSP, Mason, and Treesitter
---@class LSPHelpers
---@field checkexec function<boolean>
---@field tbl_toString function<string>
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
---@type table <string, vim.lsp.Config>
M.lsp.servers = {
  bashls = {
    enabled = true,
    filetypes = { "sh", "bash" },
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
        tsserver = {
          globalPlugins = {
            {
              name = "@astrojs/ts-plugin",
              location = vim.fn.stdpath("data")
                .. "/mason/packages/astro-language-server/node_modules/@astrojs/ts-plugin",
              enableForWorkspaceTypeScriptVersions = true,
            },
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
          parameterNames = { enabled = "all" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = true },
        },
        -- yarn sdk
        tsdk = get_typescript_server_path(),
      },
    },
  },
  astro = {
    filetypes = { "astro" },
    root_markers = { "astro.config.mjs", "astro.config.js", "package.json", ".git" },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    init_options = {
      typescript = {}, -- Will be populated on_new_config
      configuration = {
        astro = {
          typescript = {
            plugin = {
              enabled = true,
            },
          },
        },
      },
    },
    on_new_config = function(new_config, new_root_dir)
      if new_config.init_options and new_config.init_options.typescript then
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
      end
    end,
    settings = {
      astro = {
        cssls = { enabled = true },
        html = { enabled = true },
        diagnostics = { enabled = true },
        format = { enabled = true },
      },
    },
    on_attach = function(client, buffer)
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
      end
    end,
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
        capabilities = {
          offsetEncoding = { "utf-16" },
          textDocument = {
            completion = {
              editsNearCursor = true,
            },
          },
        },
        extensions = {
          autoSetHints = false,
        },
        on_attach = function(client, buffer)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end,
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
  gopls = M.checkexec("gopls")
      and {
        settings = {
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
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
              },
            },
          },
        },
        ---@param client vim.lsp.Client
        ---@param buffer number
        on_attach = function(client, buffer)
          if client.server_capabilities.semanticTokensProvider then
            vim.lsp.semantic_tokens.start(buffer, client.id)
          else
            local semantic = client.config.capabilities.textDocument.semanticTokens
            if semantic then
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end
        end,
      }
    or nil,

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
    ---@param client vim.lsp.Client
    ---@param buffer number
    on_attach = function(client, buffer)
      -- Disable formatting to avoid conflicts with conform.nvim
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      if client.server_capabilities.semanticTokensProvider then
        vim.lsp.semantic_tokens.start(buffer, client.id)
      end
    end,
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
        hover = {
          expandAlias = true,
          previewSnippet = true,
          viewString = true,
          viewStringMax = 50,
          viewNumber = true,
        },
        hint = {
          enable = true,
          setType = true,
          paramType = true,
          paramName = "All",
          semicolon = "Disable",
          arrayIndex = "Enable",
        },
      },
    },
  },

  -- JSON
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
    ---@param client vim.lsp.Client
    ---@param buffer number
    on_attach = function(client, buffer)
      if client.server_capabilities.semanticTokensProvider then
        vim.lsp.semantic_tokens.start(buffer, client.id)
      end
    end,
  },

  -- Biome
  biome = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
      "css",
    },
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern("biome.json", "biome.jsonc")(fname)
    end,
    -- Explicitly exclude astro if it somehow gets included
    on_attach = function(client, buffer)
      if vim.bo[buffer].filetype == "astro" then
        client.stop()
      end
    end,
  },

  -- Web servers
  html = { settings = {} },
  cssls = { settings = {} },
  css_variables = {
    settings = {
      cssVariables = {
        lookupInFiles = {
          "**/*.css",
          "**/*.scss",
          "**/*.sass",
          "**/*.less",
          "**/*.js",
          "**/*.ts",
          "**/*.jsx",
          "**/*.tsx",
        },
      },
    },
  },
  cssmodules_ls = { settings = {} },

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
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
  },

  -- web_extra
  tailwindcss = {
    filetypes_exclude = { "markdown" },
    filetypes_include = {
      "css",
      "scss",
      "sass",
      "postcss",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "astro",
    },
    includeLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex",
      astro = "html",
      vue = "html",
      svelte = "html",
    },
    experimental = {
      classRegex = {
        "tw`([^`]*)",
        'tw="([^"]*)',
        'tw={"([^"}]*)',
        "tw\\.\\w+`([^`]*)",
        "tw\\(.*?\\)`([^`]*)",
      },
    },
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
        --colorProvider = {
        --  dynamicRegistration = true,
        --},
      },
    },
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

M.treesitter.functions = {}

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

-- Convert a lua table into a lua syntactically correct string
---@param tbl table
M.tbl_toString = function(tbl)
  local result = "{"
  for k, v in pairs(tbl) do
    -- Check the key type (ignore any numerical keys - assume its an array)
    if type(k) == "string" then
      result = result .. '["' .. k .. '"]' .. "="
    end

    -- Check the value type
    if type(v) == "table" then
      result = result .. M.tbl_toString(v)
    elseif type(v) == "boolean" then
      result = result .. tostring(v)
    else
      result = result .. '"' .. v .. '"'
    end
    result = result .. ","
  end
  -- Remove leading commas from the result
  if result ~= "" then
    result = result:sub(1, result:len() - 1)
  end
  return result .. "}"
end

-- Register language mappings
vim.treesitter.language.register("bash", "kitty")

return M
