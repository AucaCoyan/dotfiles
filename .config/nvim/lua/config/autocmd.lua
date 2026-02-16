-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Help page in a new tab',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  pattern = { '*.txt' },
  callback = function()
    if vim.o.filetype == 'help' then
      vim.cmd.wincmd 'T'
    end
  end,
})

-- set filetype = JSON on the following
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  desc = 'Apply the JSON fileype on the following formats:',
  -- follows vim glob pattenrs (file-pattern)
  pattern = { 'composer.lock', '*.jsonc', '*.jsonl' },
  command = 'set filetype=json',
})
