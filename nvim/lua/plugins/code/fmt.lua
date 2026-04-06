return {
  ---@module "conform"
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    ---@type conform.setupOpts
    opts = {
      log_level = vim.log.levels.DEBUG,
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        javascript = { "biome" },
        javascriptreact = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        astro = { "biome", lsp_format = "fallback" },
        css = { "biome" },
        html = { "biome" },
        qml = { "qmlformat" },
        cpp = { "clang-format" },
        hpp = { "clang-format" },
        markdown = { "remark" },
        ["markdown.mdx"] = { "remark" },
        caddyfile = { "caddyfile" },
        Caddyfile = { "caddyfile" },
        go = { "gofmt" },
        rust = { "rustfmt" },
        python = { "black" },
      },
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        injected = {
          options = {
            ignore_errors = true,
            lang_to_ft = {
              bash = "sh",
              fish = "fish",
              lua = "lua",
              markdown = { "md", "mdx" },
              python = "py",
            },
            lang_to_ext = {
              fish = "fish",
              lua = "lua",
              bash = "sh",
              c_sharp = "cs",
              elixir = "exs",
              javascript = { "js", "jsx", "mjs" },
              julia = "jl",
              latex = "tex",
              markdown = { "md", "mdx" },
              python = "py",
              ruby = "rb",
              rust = "rs",
              teal = "tl",
              typescript = { "ts", "tsx" },
              qml = "qml",
              caddyfile = "Caddyfile",
            },
            lang_to_formatters = {
              fish = { "fish_indent" },
              lua = { "stylua" },
              js = { "biome" },
              jsx = { "biome" },
              ts = { "biome" },
              tsx = { "biome" },
              json = { "biome" },
              jsonc = { "biome" },
              astro = { "prettier" },
              css = { "csslsp" },
              html = { "biome" },
              qml = { "qmlformat" },
              rs = { "rustfmt" },
              cpp = { "clang-format" },
              markdown = { "remark" },
              py = { "black" },
            },
          },
        },
        fish_indent = {},
        biome = {
          command = "biome",
          stdin = true,
          args = function(self, ctx)
            local args = { "format", "--stdin-file-path", ctx.filename }
            local util = require("conform.util")
            local has_local_config = util.root_file({ "biome.json", "biome.jsonc" })(self, ctx)
            if not has_local_config then
              local default_config = vim.fn.stdpath("config") .. "/lua/plugins/code/biome.jsonc"
              vim.list_extend(args, { "--config-path", default_config })
            end
            return args
          end,
          require_cwd = false,
        },
        prettier = {
          args = function(self, ctx)
            local args = { "--stdin-filepath", ctx.filename }
            local util = require("conform.util")
            local has_local_config = util.root_file({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            })(self, ctx)

            if not has_local_config then
              local default_config = vim.fn.stdpath("config") .. "/lua/plugins/code/.prettierrc"
              vim.list_extend(args, { "--config", default_config })
            end

            if ctx.filename:match("%.astro$") then
              vim.list_extend(
                args,
                { "--plugin", "/home/xnzf/nvm/v25.6.1/lib/node_modules/prettier-plugin-astro/dist/index.js" }
              )
            end
            return args
          end,
          condition = function(_, ctx)
            return true
          end,
        },
        qmlformat = {
          command = "/usr/lib/qt6/bin/qmlformat",
          stdin = false,
          args = { "$FILENAME", "-w", "2", "-i" },
          cwd = require("conform.util").root_file({ ".qmlformat.ini" }),
          require_cwd = true,
          inherit = true,
        },
        caddyfile = {
          command = "caddy",
          args = { "fmt", "-" },
          stdin = true,
        },
        rustfmt = {
          options = {
            default_edition = "2024",
            config = { tab_spaces = 2 },
          },
        },
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
              -- stylua: ignore
            end
          end,
        },
        remark = {
          command = "bash",
          args = function(self, ctx)
            local remark_args = { "remark", "--file-path", ctx.filename, "--silent" }
            local util = require("conform.util")
            local has_local_config = util.root_file({
              ".remarkrc",
              ".remarkrc.json",
              ".remarkrc.yaml",
              ".remarkrc.yml",
              ".remarkrc.js",
              ".remarkrc.mjs",
              ".remarkrc.cjs",
            })(self, ctx)

            if not has_local_config then
              local default_config = vim.fn.stdpath("config") .. "/lua/plugins/code/remarkrc.json"
              table.insert(remark_args, "--rc-path")
              table.insert(remark_args, default_config)
            end

            -- Build the shell command string
            local cmd = "npx " .. table.concat(remark_args, " ") .. " | sed 's/\\\\\\[!/[!/g'"
            return { "-c", cmd }
          end,
          stdin = true,
        },
        markdownfmt = {},
        ["clang-format"] = {
          command = "clang-format",
          stdin = true,
          -- tmpfile_format = ".conform.$RANDOM.$FILENAME",
          -- "$FILENAME"
          args = { "--style=Google", "--fail-on-incomplete-format" },
          inherit = true,
        },
        black = {
          command = "black",
          stdin = true,
          args = {
            "-l",
            "80",
            "-t",
            "py314",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          cwd = require("conform.util").root_file({ "pyproject.toml" }),
          require_cwd = false,
        },
      },
    },
  },
}
