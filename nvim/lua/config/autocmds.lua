-- Autocmds are automatically loaded on the VeryLazy event

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("transparent_fixes", { clear = true }),
  ---@param args {buf: number, event: string, file: string, group: number, id: number, match: string}
  callback = function(args)
    -- Link NormalFloat to Normal and FloatBorder to DiagnosticInfo (visible border)
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal", default = false })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "DiagnosticInfo", default = false })

    -- Fix lualine transparency issues
    -- Get colors for proper contrast
    ---@type table<string, string>
    local colors = {
      bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg"),
      fg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "fg"),
      tsblue = "#3178C6",
      blue = "#61afef",
      green = "#98c379",
      purple = "#c678dd",
      cyan = "#56b6c2",
      red = "#e06c75",
      yellow = "#ffcc00",
      orange = "#d19a66",
      gray = "#5c6370",
      light = "#8ba7a7",
    }
    -- lualine_a_insert xxx cterm=bold gui=bold,nocombine guifg=#ffcc00 guibg=#262335
    vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = colors.yellow, bg = colors.bg })
    vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = colors.tsblue, bg = colors.bg })

    -- statusline
    vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg or colors.light, bg = nil })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_normal", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_diagnostics_normal", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_diagnostics_insert", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_diagnostics_visual", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_diagnostics_replace", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_diagnostics_command", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_diagnostics_terminal", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_diagnostics_inactive", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_transitional_lualine_a_normal_to_lualine_c_normal", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_transitional_lualine_b_normal_to_lualine_c_normal", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_transitional_lualine_a_normal_to_lualine_b_normal", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(
      0,
      "lualine_transitional_lualine_a_normal_to_lualine_c_filetype_MiniIconsAzure_normal",
      { fg = colors.fg, bg = nil }
    )
    vim.api.nvim_set_hl(0, "lualine_transitional_lualine_a_normal_to_lualine_c_13_normal", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_transitional_lualine_a_normal_to_lualine_b_normal", { fg = colors.fg, bg = nil })
    vim.api.nvim_set_hl(0, "lualine_transitional_lualine_b_normal_to_lualine_x_5_normal", { fg = colors.fg, bg = nil })

    vim.api.nvim_set_hl(0, "TabLine", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = nil })
    vim.api.nvim_set_hl(0, "TabLineSel", { bg = nil })
    vim.api.nvim_set_hl(0, "BufferLineFill", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_16_LV_Bold_normal", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_16_LV_Bold_insert", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_16_LV_Bold_visual", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_16_LV_Bold_replace", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_16_LV_Bold_command", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_16_LV_Bold_terminal", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_c_16_LV_Bold_inactive", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_transitional_lualine_a_command_to_lualine_c_13_command", { bg = nil })
    vim.api.nvim_set_hl(0, "lualine_transitional_lualine_b_command_to_lualine_x_8_command", { bg = nil })

    -- symbolsline
    vim.api.nvim_set_hl(0, "NavicText", { link = "String" })
  end,
})
