---@type LazySpec
return {
  {
    "nvim-mini/mini.move",
    enabled = false,
    version = false,
    opts = function()
      local mmove = require("mini.move")
      -- mmove.setup()
    end,
  },
  {
    "Wansmer/treesj",
    keys = { { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
    config = function()
      local treesj = require("treesj")
      treesj.setup({
        use_default_keymaps = false,
        max_join_length = 150,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
  {
    "nvim-mini/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = LazyVim.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    -- config = function(_, opts)
    --   require("mini.ai").setup(opts)
    --   LazyVim.on_load("which-key.nvim", function()
    --     vim.schedule(function()
    --       LazyVim.mini.ai_whichkey(opts)
    --     end)
    --   end)
    -- end,
  },
  {
    "nvim-mini/mini.comment",
    version = false,
    enabled = false,
    config = function()
      local mcomment = require("mini.comment")
      mcomment.setup()
    end,
  },
  {
    "nvim-mini/mini.pairs",
    version = false,
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      LazyVim.mini.pairs(opts)
    end,
  },
  {
    "nvim-mini/mini-git",
    version = false,
    name = "mini.git",
    config = function()
      local mgit = require("mini.git")
      mgit.setup()
    end,
  },
  {
    "nvim-mini/mini.diff",
    version = false,
    event = "VeryLazy",
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
    opts = {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "",
        },
      },
    },
    config = function()
      local mdiff = require("mini.diff")
      mdiff.setup()
    end,
  },
  {
    "nvim-mini/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local opts = LazyVim.opts("mini.surround")
      local mappings = {
        { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete Surrounding" },
        { opts.mappings.find, desc = "Find Right Surrounding" },
        { opts.mappings.find_left, desc = "Find Left Surrounding" },
        { opts.mappings.highlight, desc = "Highlight Surrounding" },
        { opts.mappings.replace, desc = "Replace Surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enable = false,
    optional = true,
    event = "LazyFile",
    opts = {
      scope = { enabled = false },
    },
  },
  { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
  -- {
  --   "azratul/live-share.nvim",
  --   dependencies = {
  --     "jbyuki/instant.nvim",
  --   },
  --   config = function()
  --     vim.g.instant_username = "xnzf"
  --     require("live-share").setup({
  --       port_internal = 9876,
  --       max_attempts = 20,
  --       service_url = "/tmp/service.url", -- Path to the file where the URL from serveo.net will be stored
  --       service = "nokey@localhost.run", -- Service to use, options are serveo.net or localhost.run
  --     })
  --   end,
  -- },
  {
    "folke/todo-comments.nvim",
    enabled = true,
    opts = {
      multiline = true,
      multiline_pattern = "^.", -- Default pattern matches any character at start of line
      multiline_context = 10,
      highlight = {
        before = "",
        keyword = "wide", -- Highlights keyword and colon
        after = "fg", -- Highlights rest of the line
        pattern = [[.*<(KEYWORDS)\s*:]], -- Pattern to match
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#fe4450" },
        warning = { "DiagnosticWarn", "WarningMsg", "#ff8b39" },
        info = { "DiagnosticInfo", "#61e2ff" },
        hint = { "DiagnosticHint", "#61afef" },
        default = { "Identifier", "#61e2ff" },
        test = { "Identifier", "#61e2ff" },
      },
    },
  },
  {
    "nomad/nomad",
    version = "*",
    build = function()
      ---@type nomad.neovim.build
      local build = require("nomad.neovim.build")

      build.builders.download_prebuilt():build(build.contexts.lazy())
    end,
    opts = {},
  },
}
