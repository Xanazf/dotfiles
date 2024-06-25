-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc" },
  callback = function()
    local buffernumber = vim.api.nvim_get_current_buf()
    vim.diagnostic.enable(false, { pattern = { "json", "jsonc" }, bufnr = buffernumber })
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})
