-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--- Plugins
local LSPkeys = require("lazyvim.plugins.lsp.keymaps").get()
-- change a keymap
LSPkeys[#LSPkeys + 1] = { "K", "<cmd>Lspsaga hover_doc<cr>" }

--- Increment/decrement

keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

--- Delete a word backwads
--keymap.set("n", "dw", 'vb"_d')

--- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

--- Jump list
keymap.set("n", "<C-m>", "<C-i>", opts)

--- New tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

--- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

--- Move window
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sl", "<C-w>l", opts)

--- Resize window
keymap.set("n", "<C-w><left>", "<C-w>>")
keymap.set("n", "<C-w><right>", "<C-w><")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

--- Diagnostics
-- keymap.set("n", "<C-j>", function()
--  vim.diagnostic.goto_next()
-- end)
-- keymap.set("n", "<C-k>", function()
--  vim.diagnostic.goto_prev()
-- end)
