-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

---@type vim.keymap
local keymap = vim.keymap
---@type vim.keymap.set.Opts
local opts = { noremap = true, silent = true }
-- vim.tbl_values(opts)

-- Increment/decrement
keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true, silent = true })
keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true, silent = true })

-- Select all
keymap.set("n", "<leader>sa", "gg<S-v>G", { desc = "Select All", noremap = true, silent = true })

-- Jump lists
keymap.set("n", "<C-m>", "<C-i>", { desc = "Jump lists", noremap = true, silent = true })

-- Tabs
keymap.set("n", "<leader><tab>e", ":tabedit<CR>", { desc = "New Tab", noremap = true, silent = true })
keymap.set("n", "te", ":tabedit<CR>", { desc = "New Tab", noremap = true, silent = true })
keymap.set("n", "<Tab>", ":tabnext<CR>", { desc = "Next Tab", noremap = true, silent = true })
keymap.set("n", "<S-Tab>", ":tabprev<CR>", { desc = "Previous Tab", noremap = true, silent = true })

-- Window splits
keymap.set("n", "<leader>ws", ":split<CR>", { desc = "Split Horizontal", noremap = true, silent = true })
keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "Split Vertical", noremap = true, silent = true })
keymap.set("n", "<leader>-", ":split<CR>", { desc = "Split Horizontal", noremap = true, silent = true })
keymap.set("n", "<leader>|", ":vsplit<CR>", { desc = "Split Vertical", noremap = true, silent = true })

-- Window resizing
keymap.set("n", "<C-Left>", "<C-w><", { desc = "Decrease Width", noremap = true, silent = true })
keymap.set("n", "<C-Right>", "<C-w>>", { desc = "Increase Width", noremap = true, silent = true })
keymap.set("n", "<C-Up>", "<C-w>+", { desc = "Increase Height", noremap = true, silent = true })
keymap.set("n", "<C-Down>", "<C-w>-", { desc = "Decrease Height", noremap = true, silent = true })

-- Diagnostics
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic", noremap = true, silent = true })
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic Quickfix", noremap = true, silent = true })

-- Better paste in visual mode (doesn't replace register)
keymap.set("v", "p", '"_dP', { desc = "Paste without yanking", noremap = true, silent = true })

-- Alternative move lines up/down (LazyVim has Alt+j/k)
keymap.set("n", "<leader>j", ":m .+1<CR>==", { desc = "Move Line Down", noremap = true, silent = true })
keymap.set("n", "<leader>k", ":m .-2<CR>==", { desc = "Move Line Up", noremap = true, silent = true })
keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down", noremap = true, silent = true })
keymap.set("v", "<leader>k", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up", noremap = true, silent = true })
