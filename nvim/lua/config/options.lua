-- Options are automatically loaded before lazy.nvim startup

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.termguicolors = true

vim.g.snacks_animate = true
vim.g.lazyvim_picker = "snacks"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_blink_main = true

-- _G.get_navic_location = function()
--   local ok, navic = pcall(require, "nvim-navic")
--   if ok and navic.is_available() then
--     return navic.get_location()
--   end
--   return ""
-- end
-- vim.o.winbar = " %{%v:lua.get_navic_location()%}"
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.g.astro_typescript = "enable"
