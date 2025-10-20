---@type LazyPlugin[]
local cmp = require("plugins.code.cmp")
---@type LazyPlugin[]
local fmt = require("plugins.code.fmt")
---@type LazyPlugin[]
local lint = require("plugins.code.lint")
---@type LazyPlugin[]
local debug = require("plugins.code.debug")

return vim.list_extend(vim.list_extend(vim.list_extend(cmp, fmt), lint), debug)
