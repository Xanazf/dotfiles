return {
  ---@module "lualine"
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ---@type PluginOpts
    opts = function(_, opts)
      local icons = LazyVim.config.icons
      opts = {
        options = {
          transparent = true,
          theme = "fluoromachine",
          component_separators = { left = "", right = "" },
          section_separators = { left = ":", right = ":" },
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = {
            statusline = {
              "dashboard",
              "snacks_dashboard",
              "alpha",
              "ministarter",
              "diffview",
              "fugitive",
              "gitsigns",
              "quickfix",
              "loclist",
              "Trouble",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            LazyVim.lualine.root_dir(),
            {
              "Diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              color = { bg_statusline = nil, hl_group = "Normal" },
            },
            {
              "filetype",
              icon_only = true,
              separator = " ",
              padding = { left = 1, right = 0 },
            },
            {
              LazyVim.lualine.pretty_path(),
              padding = { left = 0, right = 0 },
            },
          },
          lualine_x = {
            Snacks.profiler.status(),
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return require("noice").api.status.command.has() end,
              color = { fg = Snacks.util.color("Statement") },
            } or nil,
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            } or nil,
            -- stylua: ignore
            {
              function() return " " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            -- stylua: ignore
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local summary = vim.b.minidiff_summary
                return summary
                  and {
                    added = summary.add,
                    modified = summary.change,
                    removed = summary.delete,
                  }
              end,
            },
          },
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = { left = 1, right = 0 },
            },
            {
              "location",
              padding = { left = 0, right = 1 },
            },
          },
          lualine_z = {
            function()
              return " " .. os.date("%a|%R")
            end,
          },
        },
      }
      return opts
    end,
  },
}
