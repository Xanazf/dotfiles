return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      log_level = vim.log.levels.DEBUG,
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        js = { "biome" },
        jsx = { "biome" },
        ts = { "biome" },
        tsx = { "biome" },
        astro = { "biome" },
        css = { "biome" },
        qml = { "qmlformat" },
        cpp = { "clang-format", lsp_format = "last", timeout_ms = 500 },
        hpp = { "clang-format", lsp_format = "last", timeout_ms = 500 },
        markdown = { "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "markdownlint-cli2", "markdown-toc" },
        caddyfile = { "caddyfile" },
        go = { "gofmt" },
        rust = { "rustfmt", lsp_format = "fallback" },
        -- ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        injected = {
          options = { ignore_errors = true },
        },
        fish_indent = {},
        biome = {
          enable = true,
          command = "biome",
          stdin = false,
          args = { "format", "$FILENAME" },
          cwd = require("conform.util").root_file({ "biome.json" }),
          require_cwd = true,
        },
        prettier = {
          enable = false,
        },
        qmlformat = {
          enable = true,
          command = "qmlformat",
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
            tab_spaces = 2,
          },
        },
        mdformat = {
          enable = false,
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
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
        ["clang-format"] = {
          enable = true,
          command = "clang-format",
          stdin = true,
          -- tmpfile_format = ".conform.$RANDOM.$FILENAME",
          -- "$FILENAME"
          args = { "--style", "Google", "--fail-on-incomplete-format" },
          inherit = true,
        },
      },
      lang_to_ft = {
        bash = "sh",
        lua = "lua",
        markdown = "md",
      },
      lang_to_ext = {
        fish = "fish",
        lua = "lua",
        bash = "sh",
        c_sharp = "cs",
        elixir = "exs",
        javascript = "js",
        julia = "jl",
        latex = "tex",
        markdown = "md",
        python = "py",
        ruby = "rb",
        rust = "rs",
        teal = "tl",
        typescript = "ts",
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
        css = { "biome" },
        qml = { "qmlformat" },
        rs = { "rustfmt" },
        -- markdown = { "remark" },
        cpp = { "clang-format" },
      },
    },
  },
}
