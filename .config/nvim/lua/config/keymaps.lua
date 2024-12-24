-- source the entire file
vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')

-- run the current line
-- vim.keymap.set('n', '<space>x', ':.lua<CR>')
-- collides with delete buffer

-- run the selected lines
vim.keymap.set('v', '<space>x', ':lua<CR>')
