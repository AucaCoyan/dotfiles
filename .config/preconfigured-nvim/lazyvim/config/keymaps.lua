-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- New tab
-- keymap.set("n", "te", "tabedit") -- new tab
keymap.set("n", "<tab>", ":bnext<Return>", opts)
keymap.set("n", "<s-tab>", ":bprev<Return>", opts)

-- vs code classic Ctrl-P
keymap.set("n", "<C-P>", "<leader>ff")
