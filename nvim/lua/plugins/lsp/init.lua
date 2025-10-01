---@module "plugins.lsp.init"
-- LSP Configuration Module
-- This module extends LazyVim's default LSP configuration with custom settings
-- All configurations use opts functions to merge with LazyVim defaults rather than replace them

---@type LazyPlugin[]
local lsp = require("plugins.lsp.lsp")
---@type LazyPlugin[]
local treesitter = require("plugins.lsp.treesitter")
---@type LazyPlugin[]
local mason = require("plugins.lsp.mason")
---@type LazyPlugin[]
local misc = require("plugins.lsp.misc")

-- Return all LSP-related plugin configurations
-- These will be merged with LazyVim's existing plugin configurations
return vim.list_extend(vim.list_extend(vim.list_extend(lsp, treesitter), mason), misc)
