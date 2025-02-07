return {
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
      js = { "biome" },
      jsx = { "biome" },
      ts = { "biome" },
      tsx = { "biome" },
      astro = { "biome" },
      css = { "biome" },
      qml = { "qmlformat" },
      ["markdown"] = { "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "markdownlint-cli2", "markdown-toc" },
    },
    -- You can also define any custom formatters here.
    ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
    formatters = {
      injected = { options = { ignore_errors = true } },
      biome = {
        enable = true,
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
    },
    lang_to_ext = {
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
    },
    lang_to_formatters = {
      js = { "biome" },
      jsx = { "biome" },
      ts = { "biome" },
      tsx = { "biome" },
      astro = { "biome" },
      css = { "biome" },
      qml = { "qmlformat" },
    },
  },
}
