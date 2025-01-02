-- source the entire file
-- vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
-- collides with find on opened buffers

-- run the current line
-- vim.keymap.set('n', '<space>x', ':.lua<CR>')
-- collides with delete buffer

-- run the selected lines
vim.keymap.set('v', '<space>x', ':lua<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ tabs]]
-- go to next tab
vim.keymap.set('n', '<Tab>', '<cmd>tabNext<CR>')
-- shift tab
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<CR>')
-- new tab
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'new [b]uffer' })
-- buffer delete
vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', { desc = '[b]uffer [d]elete' })

-- quickfix list
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')

-- save with Ctrl + S
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd> w <cr>')

-- relative numbers
-- vim.keymap.set("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
-- vim.keymap.set("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

vim.keymap.set("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

-- set wrap
vim.keymap.set({'n', 'i', 'v'}, '<A-z>', "<cmd>set wrap! <CR>", { desc = "Toggle word wrap"})

