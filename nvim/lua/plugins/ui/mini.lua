return {
  ---@module "mini.hipatterns"
  {
    "nvim-mini/mini.hipatterns",
    cmd = { "MiniHipatterns" },
    opts = function(_, opts)
      local mhipatterns = require("mini.hipatterns")
      opts.highlighters = {
        bug = { pattern = " BUG", group = "MiniHipatternsBug" },
        fixme = { pattern = " FIXME", group = "MiniHipatternsFixme" },
        hack = { pattern = " HACK", group = "MiniHipatternsHack" },
        todo = { pattern = " TODO", group = "MiniHipatternsTodo" },
        note = { pattern = " NOTE", group = "MiniHipatternsNote" },
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
