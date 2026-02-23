return {
  ---@module "mini.hipatterns"
  {
    "nvim-mini/mini.hipatterns",
    event = "VeryLazy",
    cmd = { "MiniHipatterns" },
    opts = function(_, opts)
      local mhipatterns = require("mini.hipatterns")
      opts.tailwind = {
        enabled = true,
        ft = {
          "astro",
          "css",
          "heex",
          "html",
          "html-eex",
          "javascript",
          "javascriptreact",
          "rust",
          "svelte",
          "typescript",
          "typescriptreact",
          "vue",
        },
        style = "full",
      }
      opts.highlighters = {
        -- bug = { pattern = "%f[%w]BUG:.*", group = "MiniHipatternsBug" },
        -- fixme = { pattern = "%f[%w]FIXME:.*", group = "MiniHipatternsFixme" },
        -- hack = { pattern = "%f[%w]HACK:.*", group = "MiniHipatternsHack" },
        -- todo = { pattern = "%f[%w]TODO:.*", group = "MiniHipatternsTodo" },
        -- note = { pattern = "%f[%w]NOTE:.*", group = "MiniHipatternsNote" },
        hex_color = mhipatterns.gen_highlighter.hex_color(),
        trailspace = { pattern = "%f[%s]%s*$", group = "Error" },
      }
      return opts
    end,
  },
  ---@module "mini.animate"
  {
    "nvim-mini/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      -- NOTE: kept for convenience
      local manimate = require("mini.animate")
      return opts
    end,
  },
  ---@module "mini.notify"
  {
    "nvim-mini/mini.notify",
    enabled = false,
    opts = function(_, opts)
      -- NOTE: kept for convenience
      local mnotify = require("mini.notify")
      opts.lsp_progress = {
        enable = true,
        level = "INFO",
        duration_last = 1000,
      }
      return opts
    end,
  },
}
