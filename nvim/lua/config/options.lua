-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.snacks_animate = false
vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_cmp = "blink.cmp"

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- local opt = vim.opt
-- local set_hl = vim.api.nvim_set_hl

-- set_hl(0, "NavicIconsFile",          {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsModule",        {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsNamespace",     {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsPackage",       {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsClass",         {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsMethod",        {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsProperty",      {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsField",         {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsConstructor",   {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsEnum",          {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsInterface",     {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsFunction",      {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsVariable",      {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsConstant",      {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsString",        {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsNumber",        {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsBoolean",       {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsArray",         {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsObject",        {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsKey",           {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsNull",          {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsEnumMember",    {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsStruct",        {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsEvent",         {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsOperator",      {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicIconsTypeParameter", {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicText",               {default = true, bg = "#000000", fg = "#ffffff"})
-- set_hl(0, "NavicSeparator",          {default = true, bg = "#000000", fg = "#ffffff"})
