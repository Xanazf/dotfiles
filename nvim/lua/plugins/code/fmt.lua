return {
  ---@module "conform"
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    ---@type conform.setupOpts
    opts = {
      log_level = vim.log.levels.ERROR,
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        js = { "biome" },
        mjs = { "biome" },
        jsx = { "biome" },
        ts = { "biome" },
        tsx = { "biome" },
        astro = { "prettier", lsp_format = "prefer" },
        css = { "biome", lsp_format = "prefer" },
        html = { "biome", lsp_format = "prefer" },
        qml = { "qmlformat" },
        cpp = { "clang-format", lsp_format = "last", timeout_ms = 500 },
        hpp = { "clang-format", lsp_format = "last", timeout_ms = 500 },
        markdown = { "markdownfmt", "markdown-toc" },
        ["markdown.mdx"] = { "markdownfmt", "markdown-toc" },
        caddyfile = { "caddyfile" },
        go = { "gofmt" },
        rust = { "rustfmt", lsp_format = "fallback" },
        py = { "black", lsp_format = "fallback" },
        -- ["*"] = { "codespell" },
        -- ["_"] = { "trim_whitespace" },
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
              astro = { "biome" },
              css = { "csslsp" },
              html = { "biome" },
              qml = { "qmlformat" },
              rs = { "rustfmt" },
              cpp = { "clang-format" },
              markdown = { "markdownfmt", "markdown-toc" },
              py = { "black" },
            },
          },
        },
        fish_indent = {},
        biome = {
          command = "/usr/bin/biome",
          stdin = true,
          args = { "format", "--stdin-file-path", "$FILENAME" },
          cwd = require("conform.util").root_file({ "biome.jsonc" }),
          require_cwd = false,
        },
        prettier = {
          condition = function(_, ctx)
            local util = require("conform.util")
            local resolvedcwd = util.root_file({ ".prettierrc" }) or util.root_file({ "prettier.json" })
            local is_astro = string.find(ctx.filename, ".astro")
            return resolvedcwd ~= nil or is_astro ~= nil
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
          command = "/usr/bin/black",
          stdin = true,
          args = {
            "-l",
            "66",
            "-t",
            "py310,py311,py312,py313,py314",
            "--stdin-filename",
            "$FILENAME",
          },
          cwd = require("conform.util").root_file({ "pyproject.toml" }),
          require_cwd = false,
        },
      },
    },
  },
}
