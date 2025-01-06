-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.cmd.language = 'en_US' -- forces vim to have en_US interface language

--vim.g.python3_host_prog = 'C:/Users/AucaMaillo/repos/dotfiles/.config/.venv/Scripts/python.exe'
--
-- Set the python3_host_prog variable
vim.g.python3_host_prog = '~/repos/dotfiles/.config/venv/Scripts/python'

require 'config.autocmd'
require 'config.keymaps'
require 'config.options'
-- structured installation
-- https://lazy.folke.io/installation
require 'config.lazy'
