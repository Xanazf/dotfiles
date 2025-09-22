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
      blue = "#61afef",
      green = "#98c379",
      purple = "#c678dd",
      cyan = "#56b6c2",
      red = "#e06c75",
      yellow = "#e5c07b",
      orange = "#d19a66",
      gray = "#5c6370",
    }

    -- Set lualine highlights with proper backgrounds
    vim.api.nvim_set_hl(0, "lualine_a_normal", { fg = colors.bg or "#282c34", bg = colors.blue, bold = true })
    vim.api.nvim_set_hl(0, "lualine_a_insert", { fg = colors.bg or "#282c34", bg = colors.green, bold = true })
    vim.api.nvim_set_hl(0, "lualine_a_visual", { fg = colors.bg or "#282c34", bg = colors.purple, bold = true })
    vim.api.nvim_set_hl(0, "lualine_a_replace", { fg = colors.bg or "#282c34", bg = colors.red, bold = true })
    vim.api.nvim_set_hl(0, "lualine_a_command", { fg = colors.bg or "#282c34", bg = colors.yellow, bold = true })

    vim.api.nvim_set_hl(0, "lualine_b_normal", { fg = colors.fg or "#abb2bf", bg = colors.gray })
    vim.api.nvim_set_hl(0, "lualine_c_normal", { fg = colors.fg or "#abb2bf", bg = "NONE" })

    -- Fix bufferline transparency issues
    --vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "NONE" })
    -- vim.api.nvim_set_hl(0, "BufferLineBackground", { fg = colors.gray, bg = "Normal" })
    --vim.api.nvim_set_hl(0, "BufferLineTab", { fg = colors.fg or "#abb2bf", bg = colors.gray })
    --vim.api.nvim_set_hl(0, "BufferLineTabSelected", { fg = colors.blue, bg = "NONE", bold = true })
    --vim.api.nvim_set_hl(0, "BufferLineTabClose", { fg = colors.red, bg = colors.gray })
    --vim.api.nvim_set_hl(0, "BufferLineBuffer", { fg = colors.gray, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = colors.fg or "#abb2bf", bg = "NONE", bold = true })
    --vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { fg = colors.gray, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineCloseButton", { fg = colors.gray, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", { fg = colors.red, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineCloseButtonVisible", { fg = colors.gray, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = colors.gray, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = colors.blue, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = colors.gray, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = colors.blue, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineModified", { fg = colors.yellow, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { fg = colors.yellow, bg = "NONE" })
    --vim.api.nvim_set_hl(0, "BufferLineModifiedVisible", { fg = colors.yellow, bg = "NONE" })
  end,
})

-- Apply immediately on startup as well
--vim.schedule(function()
--  pcall(vim.api.nvim_exec2, "doautocmd ColorScheme", {})
--end)
