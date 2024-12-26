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
vim.keymap.set('n', '<tab>', '<cmd>tabNext<CR>')
-- shift tab
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<CR>')
-- new tab
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'new [b]uffer' })
-- buffer delete
vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', { desc = '[b]uffer [d]elete' })
