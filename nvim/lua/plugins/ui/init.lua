---@type LazyPlugin[]
local misc = require("plugins.ui.misc")
---@type LazyPlugin[]
local bufferline = require("plugins.ui.bufferline")
---@type LazyPlugin[]
local statusline = require("plugins.ui.statusline")
---@type LazyPlugin[]
local mini = require("plugins.ui.mini")
---@type LazyPlugin[]
local noice = require("plugins.ui.noice")
---@type LazyPlugin[]
local snacks = require("plugins.ui.snacks")

---@return table
return vim.list_extend(
  vim.list_extend(vim.list_extend(vim.list_extend(vim.list_extend(bufferline, statusline), mini), misc), noice),
  snacks
)
