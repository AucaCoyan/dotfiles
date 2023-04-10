-- Keymaps script
--
-- <cr> stands for carriage return (normal enter)
-- <C> stands for control
-- <S> stands for shift
-- <A> stands for alt
--
-- noremap stands for no recurse map (no recursivty)
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- remap the nvim_set_keymap to a shorter function name
local keymap = vim.api.nvim_set_keymap
-- :help nvim_set_keymap for help

-- remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
-- instead of pressing Ctrl W and then Ctrl W h, 
-- you just go for Ctrl h
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- remap leader explorer to <leader>+e
keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
--      empty

-- Visual --
-- while in visual, press > or < to indent or des-indent a paragraph
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
-- same as Alt + up and Alt + Down in vs code
keymap("v", "<A-Up>", ":m .+1<CR>==", opts)
keymap("v", "<A-Down>", ":m .-2<CR>==", opts)
-- if I'm replacing one text with another with p
-- don't save the old text on de register
-- keep the clipboard the same
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
-- same as visual, but with visual block
keymap("x", "<A-Up>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-Down>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope
local builtin = require('telescope.builtin')
keymap("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", opts)                -- find files 
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)                             -- find text (live grep)
keymap("n", "<leader>th", "<cmd>lua require('telescope.builtin').colorscheme()<cr>", opts)  -- search through themes

-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
