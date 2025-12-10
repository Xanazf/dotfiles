-- Options are automatically loaded before lazy.nvim startup

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.termguicolors = true

vim.g.snacks_animate = false
vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_blink_main = true

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.g.astro_typescript = "enable"
