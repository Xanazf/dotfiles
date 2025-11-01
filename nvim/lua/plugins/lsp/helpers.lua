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
        on_attach = function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
        ---@param bufnr number
        on_attach = function(client, bufnr)
          if client.server_capabilities.semanticTokensProvider then
            vim.lsp.semantic_tokens.start(bufnr, client.id)
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
    ---@param bufnr number
    on_attach = function(client, bufnr)
      -- Disable formatting to avoid conflicts with conform.nvim
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      if client.server_capabilities.semanticTokensProvider then
        vim.lsp.semantic_tokens.start(bufnr, client.id)
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
    ---@param client vim.lsp.Client
    ---@param bufnr number
    on_attach = function(client, bufnr)
      if client.server_capabilities.semanticTokensProvider then
        vim.lsp.semantic_tokens.start(bufnr, client.id)
      end
    end,
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
  astro = { settings = {} },
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
        colorProvider = {
          dynamicRegistration = true,
        },
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

M.treesitter.functions = {
  create_ts_group = function()
    local treesitter_group = vim.api.nvim_create_augroup("TreesitterOpts", { clear = true })
  end,
  create_buffer_excluder = function()
    return function(buf)
      if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return true
      end

      local buftype = vim.bo[buf].buftype
      local filetype = vim.bo[buf].filetype
      local bufname = vim.api.nvim_buf_get_name(buf)

      -- Exclude special buffer types
      local excluded_buftypes = {
        "nofile", -- Scratch buffers, help, etc.
        "terminal", -- Terminal buffers
        "prompt", -- Command prompt buffers
        "quickfix", -- Quickfix and location lists
        "help", -- Help buffers
      }

      if vim.tbl_contains(excluded_buftypes, buftype) then
        return true
      end

      -- Exclude UI and special filetypes
      local excluded_filetypes = {
        -- LazyVim/Snacks UI
        "snacks_dashboard",
        "snacks_notif",
        "snacks_terminal",
        "snacks_win",
        "snacks_input",
        "snacks_picker",

        -- Dashboard and startup screens
        "dashboard",
        "alpha",
        "startify",
        "startup",

        -- Plugin UIs
        "lazy",
        "mason",
        "lspinfo",
        "checkhealth",
        "TelescopePrompt",
        "TelescopeResults",
        "TelescopePreview",
        "fzf",
        "trouble",
        "qf",
        "help",
        "man",

        -- File managers and explorers
        "neo-tree",
        "NvimTree",
        "oil",
        "dirvish",
        "netrw",

        -- Git and diff UIs
        "fugitive",
        "fugitiveblame",
        "gitcommit",
        "gitrebase",
        "DiffviewFiles",
        "DiffviewFileHistory",

        -- Terminal and REPL
        "terminal",
        "toggleterm",
        "floaterm",

        -- Other special buffers
        "notify",
        "noice",
        "popup",
        "scratch",
        "undotree",
        "outline",
        "Outline",
        "spectre_panel",
        "tsplayground",
        "dap-repl",
        "dapui_console",
        "dapui_watches",
        "dapui_stacks",
        "dapui_breakpoints",
        "dapui_scopes",

        -- Empty or unnamed buffers
        "",
      }

      if vim.tbl_contains(excluded_filetypes, filetype) then
        return true
      end

      -- Exclude buffers with special names/patterns
      local excluded_patterns = {
        "^$", -- Empty buffer name
        "^%[.*%]$", -- Buffers with names like [No Name]
        "^term://", -- Terminal buffers
        "^fugitive://", -- Fugitive buffers
        "^gitsigns://", -- Gitsigns buffers
        "^oil://", -- Oil buffers
        "^neo%-tree", -- Neo-tree buffers
        "^diffview://", -- Diffview buffers
        "^Trouble$", -- Trouble buffer
        "^quickfix$", -- Quickfix buffer
        "^loclist$", -- Location list buffer
      }

      for _, pattern in ipairs(excluded_patterns) do
        if bufname:match(pattern) then
          return true
        end
      end

      -- Exclude very large files (>1MB) to prevent performance issues
      local max_filesize = 1024 * 1024 -- 1MB
      local uv = vim.uv or vim.loop
      local ok, stats = pcall(uv.fs_stat, bufname)
      if ok and stats and stats.size > max_filesize then
        return true
      end

      return false
    end
  end,
  create_indents = function(ts_group)
    local should_exclude_buffer = M.treesitter.functions.create_buffer_excluder()
    vim.api.nvim_create_autocmd("FileType", {
      group = ts_group,
      pattern = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "jsx",
        "astro",
        "html",
        "css",
        "json",
        "yaml",
        "python",
      },
      callback = function(args)
        local buf = args.buf
        if should_exclude_buffer(buf) then
          return
        end

        -- Use the correct indentexpr for the new API
        vim.bo[buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
      end,
    })
  end,
  create_folds = function(ts_group)
    local should_exclude_buffer = M.treesitter.functions.create_buffer_excluder()
    vim.api.nvim_create_autocmd("FileType", {
      group = ts_group,
      pattern = {
        "lua",
        "javascript",
        "typescript",
        "astro",
        "tsx",
        "jsx",
        "python",
        "rust",
        "go",
        "c",
        "cpp",
        "java",
        "json",
        "yaml",
        "html",
        "css",
        "vue",
        "svelte",
      },
      callback = function(args)
        local buf = args.buf
        if should_exclude_buffer(buf) then
          return
        end

        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
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
