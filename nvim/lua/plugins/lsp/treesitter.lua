---@class LSPHelpers
local helpers = require("plugins.lsp.helpers")
local h_ts = helpers.treesitter
local h_parsers = h_ts.parsers

return {
  ---@module "nvim-treesitter"
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    ---@param opts lazyvim.TSConfig
    opts = function(_, opts)
      opts.indent = { enable = true }
      opts.highlight = { enable = true }
      opts.folds = { enable = true }
      -- opts.auto_install = true
      opts.ensure_installed = opts.ensure_installed or {}

      local common_parsers = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "latex",
        "norg",
        "scss",
        "typst",
        "bash",
        "regex",
        "json",
        -- "jsonc",
        "gotmpl",
        "yaml",
        "toml",
        "helm",
        "diff",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
      }
      vim.list_extend(opts.ensure_installed, common_parsers)

      -- conditional parsers based on cwd
      if
        vim.fn.glob("*.js") ~= ""
        or vim.fn.glob("*.ts") ~= ""
        or vim.fn.glob("package.json") ~= ""
        or vim.fn.glob("tsconfig.json") ~= ""
      then
        vim.list_extend(opts.ensure_installed, h_parsers.web)
      end

      if
        vim.fn.glob("*.c") ~= ""
        or vim.fn.glob("*.cpp") ~= ""
        or vim.fn.glob("*.rs") ~= ""
        or vim.fn.glob("*.go") ~= ""
        or vim.fn.glob("Makefile") ~= ""
        or vim.fn.glob("CMakeLists.txt") ~= ""
      then
        vim.list_extend(opts.ensure_installed, h_parsers.systems)
      end

      if vim.fn.glob("*.astro") ~= "" or vim.fn.glob("*.vue") ~= "" or vim.fn.glob("astro.config.mjs") ~= "" then
        vim.list_extend(opts.ensure_installed, h_parsers.web_extra)
      end

      if vim.fn.glob("*.fish") ~= "" or vim.fn.glob("hypr*.conf") ~= "" then
        vim.list_extend(opts.ensure_installed, h_parsers.shell)
      end

      if
        vim.fn.glob("*.xml") ~= ""
        or vim.fn.glob("*.toml") ~= ""
        or vim.fn.glob("*.yaml") ~= ""
        or vim.fn.glob("*.yml") ~= ""
      then
        vim.list_extend(opts.ensure_installed, h_parsers.markup)
      end

      return opts
    end,
  },

  ---@module "nvim-treesitter-textobjects"
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    enabled = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- Manual textobjects setup since the old config system is gone
      local textobjects = require("plugins.lsp.helpers").treesitter.opts.textobjects

      -- Set up textobjects manually
      if textobjects and textobjects.select then
        for key, query in pairs(textobjects.select.keymaps or {}) do
          vim.keymap.set({ "o", "x" }, key, function()
            require("nvim-treesitter.textobjects.select").select_textobject(query, "textobjects")
          end, { desc = "Select " .. query })
        end
      end

      if textobjects and textobjects.move then
        for key, query in pairs(textobjects.move.goto_next_start or {}) do
          vim.keymap.set("n", key, function()
            require("nvim-treesitter.textobjects.move").goto_next_start(query)
          end, { desc = "Next " .. query })
        end

        for key, query in pairs(textobjects.move.goto_previous_start or {}) do
          vim.keymap.set("n", key, function()
            require("nvim-treesitter.textobjects.move").goto_previous_start(query)
          end, { desc = "Previous " .. query })
        end

        for key, query in pairs(textobjects.move.goto_next_end or {}) do
          vim.keymap.set("n", key, function()
            require("nvim-treesitter.textobjects.move").goto_next_end(query)
          end, { desc = "Next end " .. query })
        end

        for key, query in pairs(textobjects.move.goto_previous_end or {}) do
          vim.keymap.set("n", key, function()
            require("nvim-treesitter.textobjects.move").goto_previous_end(query)
          end, { desc = "Previous end " .. query })
        end
      end
    end,
  },

  -- Flash.nvim for enhanced navigation (updated configuration)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@param opts Flash.Config
    opts = function(_, opts)
      opts.modes = {
        -- Treesitter-based incremental selection
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz",
          jump = { pos = "range" },
          search = { incremental = true },
          label = { after = true, before = false, style = "inline" },
          highlight = {
            backdrop = false,
            matches = false,
          },
        },
        -- Enhanced search mode
        search = {
          enabled = true,
          highlight = { backdrop = true },
          jump = { history = true, register = true, nohlsearch = true },
          search = {
            multi_window = true,
            forward = true,
            wrap = true,
            incremental = true,
          },
        },
        -- Character mode for quick navigation
        char = {
          enabled = true,
          config = function(charopts)
            charopts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"
          end,
          keys = { "f", "F", "t", "T", ";", "," },
          ---@return Flash.CharActions
          char_actions = function(motion)
            return {
              [";"] = "next", -- set to `right` to always go right
              [","] = "prev", -- set to `left` to always go left
              [motion:lower()] = "next",
              [motion:upper()] = "prev",
            }
          end,
        },
      }
      return opts
    end,
    keys = {
      -- Incremental selection keymaps (replacing nvim-treesitter incremental selection)
      -- Using <leader>v for "visual selection" to avoid conflicts
      {
        "<leader>vt",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter (Incremental Selection)",
      },
      {
        "<leader>vs",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search (Scope Selection)",
      },
      -- Enhanced search and jump - keep 's' as it's commonly used for flash
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash Jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      -- Use <C-/> for command mode flash toggle (doesn't conflict with save)
      {
        "<C-/>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
}
